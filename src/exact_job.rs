use std::{
    fs::{self, File, OpenOptions},
    io::{Read, Seek, SeekFrom, Write},
    path::{Component, Path, PathBuf},
    process::Stdio,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant, UNIX_EPOCH},
};

use eyre::{Result, WrapErr};
use nanocodex::{
    Tool, ToolContext, ToolDefinition, ToolExecution, ToolInput, ToolResult, async_trait,
};
use serde::{Deserialize, Serialize};
use serde_json::json;
use sha2::{Digest, Sha256};
use tokio::{process::Child, sync::Semaphore};

const MAX_JOB_SECONDS: u64 = 21_600;
const OUTPUT_TAIL_BYTES: u64 = 32 * 1024;

#[derive(Clone)]
pub(crate) struct ExactJobRunner {
    state: Arc<ExactJobState>,
    scope: Option<Arc<ExactJobScope>>,
}

struct ExactJobState {
    run_directory: PathBuf,
    max_jobs: u64,
    max_concurrent_jobs: usize,
    artifact_baseline_bytes: u64,
    max_artifact_bytes: u64,
    used_jobs: AtomicU64,
    next_id: AtomicU64,
    permits: Arc<Semaphore>,
}

struct ExactJobScope {
    max_jobs: u64,
    used_jobs: AtomicU64,
}

#[derive(Serialize)]
pub(crate) struct ExactJobBudget {
    jobs_used: u64,
    jobs_remaining: u64,
    max_concurrent_jobs: usize,
    artifact_bytes: u64,
    artifact_bytes_remaining: u64,
    max_artifact_bytes: u64,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct ExactJobInput {
    label: String,
    purpose: ExactJobPurpose,
    hypothesis: String,
    enrichment: String,
    decision_rule: String,
    pilot: String,
    script: String,
    timeout_seconds: u64,
    no_progress_seconds: u64,
    #[serde(default)]
    heartbeat_path: Option<String>,
}

#[derive(Clone, Copy, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
enum ExactJobPurpose {
    TargetedPilot,
    Falsifier,
    Certificate,
    Formalization,
    Verification,
}

#[derive(Serialize)]
struct ExactJobResult {
    job_id: u64,
    label: String,
    purpose: ExactJobPurpose,
    hypothesis: String,
    enrichment: String,
    decision_rule: String,
    pilot: String,
    status: ExactJobStatus,
    exit_code: Option<i32>,
    elapsed_seconds: u64,
    last_progress_seconds_ago: u64,
    stdout_path: String,
    stderr_path: String,
    stdout_bytes: u64,
    stderr_bytes: u64,
    stdout_sha256: String,
    stderr_sha256: String,
    stdout_tail: String,
    stderr_tail: String,
    heartbeat_path: Option<String>,
    artifact_bytes: u64,
    max_artifact_bytes: u64,
    script: String,
}

#[derive(Clone, Copy, Serialize)]
#[serde(rename_all = "kebab-case")]
enum ExactJobStatus {
    Completed,
    Failed,
    TimedOut,
    NoProgress,
    ArtifactLimit,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct FileProgress {
    bytes: u64,
    modified_nanos: Option<u128>,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct ProgressSignature {
    stdout: FileProgress,
    stderr: FileProgress,
    heartbeat: Option<FileProgress>,
}

struct SupervisedOutcome {
    status: ExactJobStatus,
    exit_code: Option<i32>,
    elapsed_seconds: u64,
    last_progress_seconds_ago: u64,
    artifact_bytes: u64,
}

struct JobSupervision<'a> {
    stdout_path: &'a Path,
    stderr_path: &'a Path,
    heartbeat_path: Option<&'a Path>,
    timeout: Duration,
    no_progress_timeout: Duration,
    run_directory: &'a Path,
    artifact_baseline_bytes: u64,
    max_artifact_bytes: u64,
}

impl ExactJobRunner {
    pub(crate) fn new(
        run_directory: PathBuf,
        max_jobs: u64,
        max_concurrent_jobs: usize,
        max_artifact_bytes: u64,
    ) -> Self {
        let artifact_baseline_bytes = directory_size(&run_directory).unwrap_or(0);
        Self {
            state: Arc::new(ExactJobState {
                run_directory,
                max_jobs,
                max_concurrent_jobs,
                artifact_baseline_bytes,
                max_artifact_bytes,
                used_jobs: AtomicU64::new(0),
                next_id: AtomicU64::new(0),
                permits: Arc::new(Semaphore::new(max_concurrent_jobs)),
            }),
            scope: None,
        }
    }

    pub(crate) fn scoped(&self, max_jobs: u64) -> Self {
        Self {
            state: self.state.clone(),
            scope: Some(Arc::new(ExactJobScope {
                max_jobs,
                used_jobs: AtomicU64::new(0),
            })),
        }
    }

    pub(crate) fn budget_summary(&self) -> String {
        let budget = self.budget_snapshot();
        format!(
            "jobs_used={}, jobs_remaining={}, artifact_bytes={}, artifact_bytes_remaining={}",
            budget.jobs_used,
            budget.jobs_remaining,
            budget.artifact_bytes,
            budget.artifact_bytes_remaining
        )
    }

    pub(crate) fn budget_snapshot(&self) -> ExactJobBudget {
        let jobs_used = self.state.used_jobs.load(Ordering::Relaxed);
        let artifact_bytes = self.artifact_bytes();
        ExactJobBudget {
            jobs_used,
            jobs_remaining: self.state.max_jobs.saturating_sub(jobs_used),
            max_concurrent_jobs: self.state.max_concurrent_jobs,
            artifact_bytes,
            artifact_bytes_remaining: self.state.max_artifact_bytes.saturating_sub(artifact_bytes),
            max_artifact_bytes: self.state.max_artifact_bytes,
        }
    }

    fn artifact_bytes(&self) -> u64 {
        directory_size(&self.state.run_directory)
            .unwrap_or(u64::MAX)
            .saturating_sub(self.state.artifact_baseline_bytes)
    }

    async fn run(&self, input: ExactJobInput) -> Result<ExactJobResult> {
        let runner = self.clone();
        tokio::spawn(async move { runner.run_owned(input).await })
            .await
            .map_err(|error| std::io::Error::other(format!("exact-job task failed: {error}")))?
    }

    fn reserve_budget(&self) -> Result<()> {
        if let Some(scope) = &self.scope {
            scope
                .used_jobs
                .fetch_update(Ordering::AcqRel, Ordering::Relaxed, |used| {
                    (used < scope.max_jobs).then_some(used + 1)
                })
                .map_err(|_| {
                    std::io::Error::other(format!(
                        "per-worker exact-computation quota exhausted ({})",
                        scope.max_jobs
                    ))
                })?;
        }
        self.state
            .used_jobs
            .fetch_update(Ordering::AcqRel, Ordering::Relaxed, |used| {
                (used < self.state.max_jobs).then_some(used + 1)
            })
            .map_err(|_| {
                if let Some(scope) = &self.scope {
                    scope.used_jobs.fetch_sub(1, Ordering::AcqRel);
                }
                std::io::Error::other("exact-computation job budget exhausted")
            })?;
        Ok(())
    }

    async fn run_owned(&self, input: ExactJobInput) -> Result<ExactJobResult> {
        validate_input(&input)?;
        self.reserve_budget()?;
        let _permit = Arc::clone(&self.state.permits)
            .acquire_owned()
            .await
            .map_err(|_| std::io::Error::other("exact-computation job limiter stopped"))?;

        let job_id = self.state.next_id.fetch_add(1, Ordering::Relaxed) + 1;
        let jobs_directory = self.state.run_directory.join("exact-jobs");
        fs::create_dir_all(&jobs_directory)
            .wrap_err("failed to create exact-computation job directory")?;
        let stdout_path = jobs_directory.join(format!("job-{job_id}.stdout.log"));
        let stderr_path = jobs_directory.join(format!("job-{job_id}.stderr.log"));
        let result_path = jobs_directory.join(format!("job-{job_id}.json"));
        let heartbeat_path = input
            .heartbeat_path
            .as_deref()
            .map(|relative| contained_relative_path(&self.state.run_directory, relative))
            .transpose()?;

        let stdout = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(&stdout_path)
            .wrap_err("failed to create exact-job stdout log")?;
        let stderr = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(&stderr_path)
            .wrap_err("failed to create exact-job stderr log")?;
        let mut command = tokio::process::Command::new("/bin/bash");
        command
            .arg("-c")
            .arg(&input.script)
            .current_dir(&self.state.run_directory)
            .stdin(Stdio::null())
            .stdout(Stdio::from(stdout))
            .stderr(Stdio::from(stderr))
            .env_remove("OPENAI_API_KEY")
            .kill_on_drop(true);
        #[cfg(unix)]
        {
            use std::os::unix::process::CommandExt as _;
            command.as_std_mut().process_group(0);
        }
        let mut child = command
            .spawn()
            .wrap_err("failed to start exact-computation job")?;
        let pid = child
            .id()
            .ok_or_else(|| std::io::Error::other("exact job started without a process ID"))?;

        let outcome = supervise_job(
            &mut child,
            pid,
            JobSupervision {
                stdout_path: &stdout_path,
                stderr_path: &stderr_path,
                heartbeat_path: heartbeat_path.as_deref(),
                timeout: Duration::from_secs(input.timeout_seconds),
                no_progress_timeout: Duration::from_secs(input.no_progress_seconds),
                run_directory: &self.state.run_directory,
                artifact_baseline_bytes: self.state.artifact_baseline_bytes,
                max_artifact_bytes: self.state.max_artifact_bytes,
            },
        )
        .await?;

        let result = ExactJobResult {
            job_id,
            label: input.label,
            purpose: input.purpose,
            hypothesis: input.hypothesis,
            enrichment: input.enrichment,
            decision_rule: input.decision_rule,
            pilot: input.pilot,
            status: outcome.status,
            exit_code: outcome.exit_code,
            elapsed_seconds: outcome.elapsed_seconds,
            last_progress_seconds_ago: outcome.last_progress_seconds_ago,
            stdout_path: relative_path(&self.state.run_directory, &stdout_path)?,
            stderr_path: relative_path(&self.state.run_directory, &stderr_path)?,
            stdout_bytes: fs::metadata(&stdout_path)?.len(),
            stderr_bytes: fs::metadata(&stderr_path)?.len(),
            stdout_sha256: sha256_file(&stdout_path)?,
            stderr_sha256: sha256_file(&stderr_path)?,
            stdout_tail: file_tail(&stdout_path)?,
            stderr_tail: file_tail(&stderr_path)?,
            heartbeat_path: input.heartbeat_path,
            artifact_bytes: outcome.artifact_bytes,
            max_artifact_bytes: self.state.max_artifact_bytes,
            script: input.script,
        };
        let mut result_file = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(&result_path)
            .wrap_err("failed to create exact-job result")?;
        serde_json::to_writer_pretty(&mut result_file, &result)
            .wrap_err("failed to encode exact-job result")?;
        writeln!(result_file).wrap_err("failed to finish exact-job result")?;
        Ok(result)
    }
}

async fn supervise_job(
    child: &mut Child,
    pid: u32,
    supervision: JobSupervision<'_>,
) -> Result<SupervisedOutcome> {
    let started = Instant::now();
    let mut last_progress = started;
    let mut signature = progress_signature(
        supervision.stdout_path,
        supervision.stderr_path,
        supervision.heartbeat_path,
    );
    let (status, exit_code, artifact_bytes) = loop {
        let artifact_bytes = directory_size(supervision.run_directory)
            .unwrap_or(u64::MAX)
            .saturating_sub(supervision.artifact_baseline_bytes);
        if artifact_bytes > supervision.max_artifact_bytes {
            terminate_process_group(child, pid).await;
            break (ExactJobStatus::ArtifactLimit, None, artifact_bytes);
        }
        if let Ok(waited) = tokio::time::timeout(Duration::from_secs(1), child.wait()).await {
            let process_status = waited.wrap_err("failed waiting for exact job")?;
            break (
                if process_status.success() {
                    ExactJobStatus::Completed
                } else {
                    ExactJobStatus::Failed
                },
                process_status.code(),
                artifact_bytes,
            );
        }
        let next = progress_signature(
            supervision.stdout_path,
            supervision.stderr_path,
            supervision.heartbeat_path,
        );
        if next != signature {
            signature = next;
            last_progress = Instant::now();
        }
        if started.elapsed() >= supervision.timeout {
            terminate_process_group(child, pid).await;
            break (ExactJobStatus::TimedOut, None, artifact_bytes);
        }
        if last_progress.elapsed() >= supervision.no_progress_timeout {
            terminate_process_group(child, pid).await;
            break (ExactJobStatus::NoProgress, None, artifact_bytes);
        }
    };
    Ok(SupervisedOutcome {
        status,
        exit_code,
        elapsed_seconds: started.elapsed().as_secs(),
        last_progress_seconds_ago: last_progress.elapsed().as_secs(),
        artifact_bytes,
    })
}

#[async_trait]
impl Tool for ExactJobRunner {
    fn name(&self) -> &'static str {
        "run_exact_job"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Run one inference-supporting exact job under host-owned total, no-progress, and artifact-growth limits. This is not a generic compute escape hatch: every call must identify the mathematical hypothesis, explain why the tested family is enriched over undirected search, state the outcome-dependent route decision, and describe the smallest pilot. Use it for a targeted pilot, falsifier, certificate, formalization, or verification. Once accepted, the host-owned job and terminal record survive model-cell cancellation. The command runs through /bin/bash -c in the frozen campaign directory with OPENAI_API_KEY removed and inherits the pinned math-shell PATH. Invoke Sage, Lean, and solvers directly; do not run nested nix develop from the mutable campaign tree. Stdout/stderr are retained and count as progress; for quiet jobs, update heartbeat_path periodically. A stalled process group is killed and returned as no-progress. If exact jobs grow the campaign beyond the host artifact budget, the process group is killed and returned as artifact-limit rather than filling the filesystem.",
            json!({
                "type": "object",
                "properties": {
                    "label": { "type": "string", "description": "Short unique purpose of this exact computation." },
                    "purpose": {
                        "type": "string",
                        "enum": ["targeted-pilot", "falsifier", "certificate", "formalization", "verification"],
                        "description": "Inference-support role of this computation. Generic enumeration is intentionally not a purpose."
                    },
                    "hypothesis": {
                        "type": "string",
                        "description": "Focused mathematical claim or representation tested by this job."
                    },
                    "enrichment": {
                        "type": "string",
                        "description": "Structural reason the tested candidates or instances are enriched relative to undirected generic search."
                    },
                    "decision_rule": {
                        "type": "string",
                        "description": "How each material outcome will update, stop, or redirect the mathematical route."
                    },
                    "pilot": {
                        "type": "string",
                        "description": "Smallest falsifying pilot and why the submitted job is no larger than needed."
                    },
                    "script": { "type": "string", "description": "Complete bash script using the inherited pinned math tools directly. Emit periodic machine-readable checkpoints." },
                    "timeout_seconds": { "type": "integer", "minimum": 1, "maximum": MAX_JOB_SECONDS },
                    "no_progress_seconds": { "type": "integer", "minimum": 1, "maximum": MAX_JOB_SECONDS, "description": "Kill the full process group if neither logs nor heartbeat change for this interval." },
                    "heartbeat_path": { "type": "string", "description": "Optional path relative to the campaign run directory that the job updates atomically." }
                },
                "required": ["label", "purpose", "hypothesis", "enrichment", "decision_rule", "pilot", "script", "timeout_seconds", "no_progress_seconds"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let result = self.run(input.decode_json()?).await?;
        Ok(ToolExecution::json(&result))
    }
}

fn validate_input(input: &ExactJobInput) -> Result<()> {
    if [
        input.label.as_str(),
        input.hypothesis.as_str(),
        input.enrichment.as_str(),
        input.decision_rule.as_str(),
        input.pilot.as_str(),
        input.script.as_str(),
    ]
    .iter()
    .any(|value| value.trim().is_empty())
    {
        return Err(std::io::Error::other(
            "exact job label, inference justification, and script must be nonempty",
        )
        .into());
    }
    if !(1..=MAX_JOB_SECONDS).contains(&input.timeout_seconds) {
        return Err(std::io::Error::other(format!(
            "timeout_seconds must be between 1 and {MAX_JOB_SECONDS}"
        ))
        .into());
    }
    if input.no_progress_seconds == 0 || input.no_progress_seconds > input.timeout_seconds {
        return Err(std::io::Error::other(
            "no_progress_seconds must be positive and no greater than timeout_seconds",
        )
        .into());
    }
    if let Some(path) = input.heartbeat_path.as_deref() {
        let _ = contained_relative_path(Path::new("."), path)?;
    }
    Ok(())
}

fn contained_relative_path(root: &Path, relative: &str) -> Result<PathBuf> {
    let path = Path::new(relative);
    if relative.trim().is_empty()
        || path.is_absolute()
        || path
            .components()
            .any(|component| !matches!(component, Component::Normal(_)))
    {
        return Err(std::io::Error::other(
            "heartbeat_path must be a nonempty relative path without `..` components",
        )
        .into());
    }
    Ok(root.join(path))
}

fn progress_signature(
    stdout_path: &Path,
    stderr_path: &Path,
    heartbeat_path: Option<&Path>,
) -> ProgressSignature {
    ProgressSignature {
        stdout: file_progress(stdout_path),
        stderr: file_progress(stderr_path),
        heartbeat: heartbeat_path.map(file_progress),
    }
}

fn file_progress(path: &Path) -> FileProgress {
    let Ok(metadata) = fs::metadata(path) else {
        return FileProgress {
            bytes: 0,
            modified_nanos: None,
        };
    };
    FileProgress {
        bytes: metadata.len(),
        modified_nanos: metadata
            .modified()
            .ok()
            .and_then(|modified| modified.duration_since(UNIX_EPOCH).ok())
            .map(|duration| duration.as_nanos()),
    }
}

fn directory_size(root: &Path) -> std::io::Result<u64> {
    let mut bytes = 0_u64;
    let mut pending = vec![root.to_path_buf()];
    while let Some(directory) = pending.pop() {
        let entries = match fs::read_dir(&directory) {
            Ok(entries) => entries,
            Err(error) if error.kind() == std::io::ErrorKind::NotFound => continue,
            Err(error) => return Err(error),
        };
        for entry in entries {
            let entry = entry?;
            let file_type = match entry.file_type() {
                Ok(file_type) => file_type,
                Err(error) if error.kind() == std::io::ErrorKind::NotFound => continue,
                Err(error) => return Err(error),
            };
            if file_type.is_dir() {
                pending.push(entry.path());
            } else if file_type.is_file() {
                let metadata = match entry.metadata() {
                    Ok(metadata) => metadata,
                    Err(error) if error.kind() == std::io::ErrorKind::NotFound => continue,
                    Err(error) => return Err(error),
                };
                bytes = bytes.saturating_add(metadata.len());
            }
        }
    }
    Ok(bytes)
}

async fn terminate_process_group(child: &mut Child, pid: u32) {
    #[cfg(unix)]
    {
        let group = format!("-{pid}");
        send_process_group_signal("-TERM", &group);
        let leader_reaped = tokio::time::timeout(Duration::from_secs(2), child.wait())
            .await
            .is_ok();
        // The shell may exit before a descendant that ignores SIGTERM. Always
        // sweep the process group with SIGKILL before disarming the child.
        send_process_group_signal("-KILL", &group);
        if leader_reaped {
            return;
        }
    }
    let _ = child.kill().await;
    let _ = child.wait().await;
}

#[cfg(unix)]
fn send_process_group_signal(signal: &str, group: &str) {
    let _ = std::process::Command::new("/bin/kill")
        .args([signal, group])
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status();
}

fn sha256_file(path: &Path) -> Result<String> {
    let mut file = File::open(path).wrap_err("failed to open exact-job output for hashing")?;
    let mut digest = Sha256::new();
    let mut buffer = vec![0_u8; 64 * 1024];
    loop {
        let read = file
            .read(&mut buffer)
            .wrap_err("failed to read exact-job output for hashing")?;
        if read == 0 {
            break;
        }
        digest.update(&buffer[..read]);
    }
    Ok(format!("{:x}", digest.finalize()))
}

fn file_tail(path: &Path) -> Result<String> {
    let mut file = File::open(path).wrap_err("failed to open exact-job output")?;
    let bytes = file.metadata()?.len();
    let start = bytes.saturating_sub(OUTPUT_TAIL_BYTES);
    file.seek(SeekFrom::Start(start))?;
    let mut tail = Vec::new();
    file.read_to_end(&mut tail)?;
    let mut output = String::from_utf8_lossy(&tail).into_owned();
    if start > 0 {
        output.insert_str(0, "[earlier output retained in artifact]\n");
    }
    Ok(output)
}

fn relative_path(root: &Path, path: &Path) -> Result<String> {
    Ok(path
        .strip_prefix(root)
        .wrap_err("exact-job artifact escaped run directory")?
        .to_string_lossy()
        .into_owned())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_directory(label: &str) -> Result<PathBuf> {
        let epoch = std::time::SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .wrap_err("system clock predates Unix epoch")?
            .as_nanos();
        let directory = std::env::temp_dir().join(format!(
            "nanocodex-erdos-exact-{label}-{}-{epoch}",
            std::process::id()
        ));
        fs::create_dir_all(&directory)?;
        Ok(directory)
    }

    #[tokio::test]
    async fn exact_job_retains_output_and_result() -> Result<()> {
        let directory = test_directory("complete")?;
        let runner = ExactJobRunner::new(directory.clone(), 1, 1, u64::MAX);
        let result = runner
            .run(ExactJobInput {
                label: "small exact check".to_owned(),
                purpose: ExactJobPurpose::Verification,
                hypothesis: "The retained exact output contains the expected certificate."
                    .to_owned(),
                enrichment: "This deterministic smoke targets one known certificate value."
                    .to_owned(),
                decision_rule: "Accept only when the process exits zero and emits the value."
                    .to_owned(),
                pilot: "One constant-output command is the smallest functional pilot.".to_owned(),
                script: "printf 'certificate=17\\n'".to_owned(),
                timeout_seconds: 5,
                no_progress_seconds: 3,
                heartbeat_path: None,
            })
            .await?;
        assert!(matches!(result.status, ExactJobStatus::Completed));
        assert_eq!(result.exit_code, Some(0));
        assert!(result.stdout_tail.contains("certificate=17"));
        assert!(directory.join("exact-jobs/job-1.json").is_file());
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[cfg(unix)]
    #[tokio::test]
    async fn exact_job_kills_a_stalled_process_group() -> Result<()> {
        let directory = test_directory("stalled")?;
        let runner = ExactJobRunner::new(directory.clone(), 1, 1, u64::MAX);
        let result = runner
            .run(ExactJobInput {
                label: "intentional stall".to_owned(),
                purpose: ExactJobPurpose::TargetedPilot,
                hypothesis: "The no-progress supervisor terminates a silent process.".to_owned(),
                enrichment: "A deterministic sleep isolates the watchdog behavior.".to_owned(),
                decision_rule: "The route passes only if the status is no-progress.".to_owned(),
                pilot: "One sleeping process is the smallest watchdog pilot.".to_owned(),
                script: "sleep 30".to_owned(),
                timeout_seconds: 10,
                no_progress_seconds: 1,
                heartbeat_path: None,
            })
            .await?;
        assert!(matches!(result.status, ExactJobStatus::NoProgress));
        assert!(result.elapsed_seconds < 10);
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[tokio::test]
    #[ignore = "requires the pinned Nix LR environment"]
    async fn exact_job_can_invoke_the_lr_toolchain() -> Result<()> {
        let directory = test_directory("lr-toolchain")?;
        let runner = ExactJobRunner::new(directory.clone(), 1, 1, u64::MAX);
        let result = runner
            .run(ExactJobInput {
                label: "LR toolchain smoke".to_owned(),
                purpose: ExactJobPurpose::Verification,
                hypothesis: "Every pinned LR campaign capability executes successfully.".to_owned(),
                enrichment: "The commands directly exercise each required campaign tool."
                    .to_owned(),
                decision_rule: "A missing or failing tool blocks the campaign launch.".to_owned(),
                pilot: "One minimal invocation per tool is sufficient for preflight.".to_owned(),
                script: r#"set -euo pipefail
for program in sage lean Normaliz count python; do
  command -v "$program"
done
printf 'example (n : Nat) : n = n := rfl\n' > Smoke.lean
lean Smoke.lean
sage -python - <<'PY'
from sage.all import PolynomialRing, QQ
R = PolynomialRing(QQ, "t")
t = R.gen()
assert (t + 1) ** 3 == t**3 + 3*t**2 + 3*t + 1
print("sage-exact-stack=ok")
PY
python - <<'PY'
import lrcalc
assert lrcalc.lrcoef([3, 2, 1], [2, 1], [2, 1]) == 2
print("lrcalc-reference=ok")
PY
Normaliz --version
printf 'lr-toolchain=ok\n'
"#
                .to_owned(),
                timeout_seconds: 60,
                no_progress_seconds: 30,
                heartbeat_path: None,
            })
            .await?;
        assert!(matches!(result.status, ExactJobStatus::Completed));
        assert_eq!(result.exit_code, Some(0));
        assert!(result.stdout_tail.contains("sage-exact-stack=ok"));
        assert!(result.stdout_tail.contains("lrcalc-reference=ok"));
        assert!(result.stdout_tail.contains("lr-toolchain=ok"));
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[tokio::test]
    async fn exact_job_retains_terminal_record_after_caller_cancellation() -> Result<()> {
        let directory = test_directory("caller-cancelled")?;
        let runner = ExactJobRunner::new(directory.clone(), 1, 1, u64::MAX);
        let caller = tokio::spawn({
            let runner = runner.clone();
            async move {
                runner
                    .run(ExactJobInput {
                        label: "survive caller cancellation".to_owned(),
                        purpose: ExactJobPurpose::Verification,
                        hypothesis: "A host-owned job persists after its caller is cancelled."
                            .to_owned(),
                        enrichment: "A one-second deterministic child isolates cancellation."
                            .to_owned(),
                        decision_rule: "Pass only if a completed terminal record appears."
                            .to_owned(),
                        pilot: "One short delayed write is the smallest cancellation pilot."
                            .to_owned(),
                        script: "sleep 1; printf 'detached=complete\\n'".to_owned(),
                        timeout_seconds: 5,
                        no_progress_seconds: 3,
                        heartbeat_path: None,
                    })
                    .await
            }
        });
        let stdout_path = directory.join("exact-jobs/job-1.stdout.log");
        for _ in 0..20 {
            if stdout_path.is_file() {
                break;
            }
            tokio::time::sleep(Duration::from_millis(25)).await;
        }
        assert!(stdout_path.is_file());
        caller.abort();
        let result_path = directory.join("exact-jobs/job-1.json");
        for _ in 0..40 {
            if result_path.is_file() {
                break;
            }
            tokio::time::sleep(Duration::from_millis(100)).await;
        }
        assert!(result_path.is_file());
        let result: serde_json::Value = serde_json::from_slice(&fs::read(&result_path)?)?;
        assert_eq!(result["status"], "completed");
        assert!(
            result["stdout_tail"]
                .as_str()
                .is_some_and(|tail| tail.contains("detached=complete"))
        );
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[tokio::test]
    async fn scoped_exact_job_quota_does_not_starve_other_workers() -> Result<()> {
        let directory = test_directory("scoped-quota")?;
        let global = ExactJobRunner::new(directory.clone(), 3, 1, u64::MAX);
        let first_worker = global.scoped(1);
        let second_worker = global.scoped(1);
        let input = || ExactJobInput {
            label: "quota check".to_owned(),
            purpose: ExactJobPurpose::Verification,
            hypothesis: "A scoped quota prevents one worker from consuming another's jobs."
                .to_owned(),
            enrichment: "Two isolated worker scopes directly exercise quota ownership.".to_owned(),
            decision_rule: "The second call in one scope must fail while another succeeds."
                .to_owned(),
            pilot: "Two scopes and three attempted calls are the smallest quota pilot.".to_owned(),
            script: "true".to_owned(),
            timeout_seconds: 5,
            no_progress_seconds: 3,
            heartbeat_path: None,
        };
        assert!(first_worker.run(input()).await.is_ok());
        let Err(error) = first_worker.run(input()).await else {
            panic!("first worker should exhaust its local quota");
        };
        assert!(error.to_string().contains("per-worker"));
        assert!(second_worker.run(input()).await.is_ok());
        assert_eq!(global.budget_snapshot().jobs_used, 2);
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[cfg(unix)]
    #[tokio::test]
    async fn exact_job_stops_when_campaign_artifacts_exceed_limit() -> Result<()> {
        let directory = test_directory("artifact-limit")?;
        let runner = ExactJobRunner::new(directory.clone(), 1, 1, 1024);
        let result = runner
            .run(ExactJobInput {
                label: "intentional artifact growth".to_owned(),
                purpose: ExactJobPurpose::TargetedPilot,
                hypothesis: "The artifact limiter terminates a job that exceeds its allowance."
                    .to_owned(),
                enrichment: "A deterministic fixed-size write isolates artifact accounting."
                    .to_owned(),
                decision_rule: "Pass only if the terminal status is artifact-limit.".to_owned(),
                pilot: "One 4096-byte write exceeds the 1024-byte limit minimally.".to_owned(),
                script: "dd if=/dev/zero of=large.bin bs=4096 count=1 2>/dev/null; sleep 30"
                    .to_owned(),
                timeout_seconds: 10,
                no_progress_seconds: 5,
                heartbeat_path: None,
            })
            .await?;
        assert!(matches!(result.status, ExactJobStatus::ArtifactLimit));
        assert!(result.artifact_bytes > result.max_artifact_bytes);
        assert!(result.elapsed_seconds < 10);
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[test]
    fn heartbeat_path_cannot_escape_run_directory() {
        assert!(contained_relative_path(Path::new("/tmp/run"), "../outside").is_err());
        assert!(contained_relative_path(Path::new("/tmp/run"), "/tmp/outside").is_err());
        assert!(contained_relative_path(Path::new("/tmp/run"), "progress/checkpoint").is_ok());
    }
}
