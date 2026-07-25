use std::{
    collections::HashMap,
    fs::{self, OpenOptions},
    io::Write,
    path::{Path, PathBuf},
    process,
    sync::{
        Arc, Weak,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant, SystemTime, UNIX_EPOCH},
};

use clap::{Parser, ValueEnum};
use eyre::{Result, WrapErr};
use nanocodex::{
    AgentEvent, AgentEventKind, AgentEvents, AgentHandle, Nanocodex, ReasoningMode, Thinking, Tool,
    ToolContext, ToolDefinition, ToolExecution, ToolInput, ToolResult, Tools, Turn, TurnResult,
    async_trait,
};
use serde::{Deserialize, Serialize};
use serde_json::json;
use sha2::{Digest, Sha256};
use tokio::sync::Semaphore;

mod artifact_reader;
mod exact_job;

use artifact_reader::ArtifactReader;
use exact_job::ExactJobRunner;

const RESEARCH_MANAGER: &str = include_str!("../prompts/research-manager.md");
const NOVELTY_AUDITOR: &str = include_str!("../prompts/novelty-auditor.md");
const CLOSURE_STEER: &str = "Enter closure mode now. Partial results remain valuable in the ledger but do not count as a resolution. Select the most promising route and attempt one complete unconditional proof or explicit counterexample that satisfies the frozen target. Produce and freeze the full artifact bundle, then submit it to the pre-approved verifier if one exists. Do not raise confidence or claim success unless the applicable host gate passes. If no route can meet the gate within the remaining budget, return blocked with the strongest verified partial result and the exact missing lemma.";
const WORKER_CLOSURE_STEER: &str = "Your caller-owned whole-worker deadline is approaching. Stop opening new searches now. Cancel or bound any remaining computation, synthesize the strongest checkable lemmas, exact candidates, computations, counterexamples, and explicit unknowns already obtained, and return the complete report in this turn. Do not spend the remaining time polishing prose or claim a result you did not verify.";
const NANOCODEX_GIT_COMMIT: &str = env!("NANOCODEX_GIT_COMMIT");
const NANOCODEX_BUILD_DIRTY: &str = env!("NANOCODEX_BUILD_DIRTY");
const NANOCODEX_SOURCE_SHA256: &str = env!("NANOCODEX_SOURCE_SHA256");
const DEFAULT_MAX_EXACT_ARTIFACT_BYTES: u64 = 4 * 1024 * 1024 * 1024;

#[derive(Parser)]
#[command(about = "Run an evidence-first AI mathematics research session")]
struct Args {
    /// Optional dotenv file used only to load credentials; its contents are never recorded.
    #[arg(long)]
    env_file: Option<PathBuf>,

    /// Workspace visible to the agent. Run artifacts are written beneath runs/.
    #[arg(long, default_value = ".")]
    workspace: PathBuf,

    /// Stable provider-side cache identity for this immutable agent recipe.
    #[arg(long, default_value = "nanocodex-erdos-research-manager-v1")]
    prompt_cache_key: String,

    /// Enforced relationship between discovery and web/literature search.
    #[arg(long, value_enum, default_value_t = WebPolicy::NoveltyOnly)]
    web_policy: WebPolicy,

    /// Request priority processing for lead, worker, and novelty-audit model calls.
    #[arg(long, default_value_t = false)]
    fast_mode: bool,

    /// Maximum child-agent prompts, including retained follow-ups.
    #[arg(long, default_value_t = 64)]
    max_worker_calls: u64,

    /// Maximum number of retained clean or contextual child sessions.
    #[arg(long, default_value_t = 16)]
    max_retained_workers: u64,

    /// Maximum number of child turns executing at once.
    #[arg(long, default_value_t = 8)]
    max_concurrent_workers: usize,

    /// Per-child deadline; timed-out turns are explicitly cancelled. Zero disables it.
    #[arg(long, default_value_t = 0)]
    worker_timeout_seconds: u64,

    /// Ask each child to synthesize its report after this many seconds, before its hard deadline.
    #[arg(long)]
    worker_closure_after_seconds: Option<u64>,

    /// Maximum tasks accepted by one host-owned batch call.
    #[arg(long, default_value_t = 12)]
    max_batch_size: usize,

    /// Maximum exact-computation jobs accepted during one campaign.
    #[arg(long, default_value_t = 64)]
    max_exact_jobs: u64,

    /// Maximum exact-computation jobs executing at once.
    #[arg(long, default_value_t = 4)]
    max_concurrent_exact_jobs: usize,

    /// Maximum aggregate artifact growth from exact jobs in one campaign.
    #[arg(long, default_value_t = DEFAULT_MAX_EXACT_ARTIFACT_BYTES)]
    max_exact_artifact_bytes: u64,

    /// Maximum exact-computation jobs one clean worker may consume.
    #[arg(long, default_value_t = 8)]
    max_exact_jobs_per_worker: u64,

    /// Pre-approved deterministic verifier executable; receives a frozen-candidate manifest path.
    #[arg(long)]
    verifier: Option<PathBuf>,

    /// Deadline for one verifier invocation.
    #[arg(long, default_value_t = 300)]
    verifier_timeout_seconds: u64,

    /// Inject the evidence-qualified closure-mode steer after this many seconds.
    #[arg(long)]
    closure_after_seconds: Option<u64>,

    /// Maximum retained lead turns inside one campaign. Unverified outcomes trigger another turn.
    #[arg(long, default_value_t = 4)]
    max_lead_turns: u32,

    /// Hard wall-time budget for all lead turns in one campaign.
    #[arg(long, default_value_t = 21_600)]
    campaign_timeout_seconds: u64,

    /// The exact mathematical problem and desired completion criteria.
    problem: String,
}

#[derive(Clone, Copy, Debug, Serialize, ValueEnum)]
#[serde(rename_all = "kebab-case")]
enum WebPolicy {
    Disabled,
    NoveltyOnly,
    FullResearch,
}

impl WebPolicy {
    const fn discovery_enabled(self) -> bool {
        matches!(self, Self::FullResearch)
    }

    const fn name(self) -> &'static str {
        match self {
            Self::Disabled => "disabled",
            Self::NoveltyOnly => "novelty-only",
            Self::FullResearch => "full-research",
        }
    }

    const fn runs_novelty_audit(self) -> bool {
        !matches!(self, Self::Disabled)
    }
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct AgentTask {
    role: String,
    task: String,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct FollowUpTask {
    agent_id: u64,
    task: String,
}

#[derive(Serialize)]
struct WorkerResult {
    agent_id: u64,
    kind: &'static str,
    role: String,
    report: String,
    report_path: String,
    snapshot_path: String,
    budget: BudgetSnapshot,
}

#[derive(Serialize)]
struct FollowUpResult {
    agent_id: u64,
    report: String,
    snapshot_path: String,
    budget: BudgetSnapshot,
}

#[derive(Serialize)]
struct CampaignManifest<'a> {
    protocol_version: u32,
    session_id: &'a str,
    created_at_epoch_seconds: u64,
    nanocodex_git_commit: &'static str,
    nanocodex_source_sha256: &'static str,
    nanocodex_build_dirty: bool,
    model: &'static str,
    reasoning_mode: &'static str,
    thinking: &'static str,
    fast_mode: bool,
    discovery_policy: &'static str,
    web_policy: WebPolicy,
    max_worker_calls: u64,
    max_retained_workers: u64,
    max_concurrent_workers: usize,
    worker_timeout_seconds: u64,
    worker_closure_after_seconds: Option<u64>,
    max_batch_size: usize,
    max_exact_jobs: u64,
    max_concurrent_exact_jobs: usize,
    max_exact_artifact_bytes: u64,
    max_exact_jobs_per_worker: u64,
    verifier: Option<&'a VerifierIdentity>,
    closure_after_seconds: Option<u64>,
    max_lead_turns: u32,
    campaign_timeout_seconds: u64,
    problem_sha256: String,
    research_manager_sha256: String,
}

impl CampaignManifest<'_> {
    fn write(&self, path: &Path) -> Result<()> {
        let mut file = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(path)
            .wrap_err("failed to create campaign manifest")?;
        serde_json::to_writer_pretty(&mut file, self)
            .wrap_err("failed to encode campaign manifest")?;
        writeln!(file).wrap_err("failed to finish campaign manifest")?;
        Ok(())
    }
}

#[derive(Serialize)]
struct RecordedAgentEvent<'a> {
    agent: &'a str,
    event: &'a AgentEvent,
}

#[derive(Clone)]
struct CampaignRecorder {
    events: Arc<std::sync::Mutex<std::fs::File>>,
    observers: Arc<std::sync::Mutex<Vec<tokio::task::JoinHandle<Result<()>>>>>,
}

impl CampaignRecorder {
    fn create(path: &Path) -> Result<Self> {
        let events = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(path)
            .wrap_err("failed to create event record")?;
        Ok(Self {
            events: Arc::new(std::sync::Mutex::new(events)),
            observers: Arc::new(std::sync::Mutex::new(Vec::new())),
        })
    }

    fn observe(&self, label: String, mut events: AgentEvents) -> Result<()> {
        let recorder = self.clone();
        let observer = tokio::spawn(async move {
            while let Some(event) = events.recv().await {
                recorder.write_event(&label, &event)?;
                if matches!(
                    event.kind,
                    AgentEventKind::RunStarted
                        | AgentEventKind::ModelAttemptRetrying
                        | AgentEventKind::RunCompleted
                        | AgentEventKind::RunFailed
                ) {
                    eprintln!(
                        "[{label}] {:?} seq={} request_id={}",
                        event.kind, event.seq, event.request_id
                    );
                }
            }
            Ok(())
        });
        self.observers
            .lock()
            .map_err(|_| std::io::Error::other("event observer lock poisoned"))?
            .push(observer);
        Ok(())
    }

    fn write_event(&self, label: &str, event: &AgentEvent) -> Result<()> {
        let mut file = self
            .events
            .lock()
            .map_err(|_| std::io::Error::other("event file lock poisoned"))?;
        serde_json::to_writer(
            &mut *file,
            &RecordedAgentEvent {
                agent: label,
                event,
            },
        )
        .wrap_err("failed to encode agent event")?;
        writeln!(file).wrap_err("failed to append agent event")?;
        file.flush().wrap_err("failed to flush agent event")?;
        Ok(())
    }

    async fn finish(&self) -> Result<()> {
        let observers = {
            let mut observers = self
                .observers
                .lock()
                .map_err(|_| std::io::Error::other("event observer lock poisoned"))?;
            std::mem::take(&mut *observers)
        };
        for observer in observers {
            observer
                .await
                .wrap_err("event observer task failed")?
                .wrap_err("event observer failed")?;
        }
        Ok(())
    }
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct FreezeCandidateInput {
    label: String,
    claim: String,
    artifacts: Vec<String>,
    #[serde(default)]
    dependencies: Vec<String>,
}

#[derive(Deserialize, Serialize)]
struct FrozenArtifact {
    source_path: String,
    path: String,
    bytes: u64,
    sha256: String,
}

struct StagedArtifact {
    source_path: String,
    contents: Vec<u8>,
    sha256: String,
}

#[derive(Deserialize, Serialize)]
struct FrozenCandidate {
    candidate_id: String,
    label: String,
    claim: String,
    created_at_epoch_seconds: u64,
    artifacts: Vec<FrozenArtifact>,
    dependencies: Vec<String>,
    manifest_path: String,
}

struct CandidateStore {
    run_directory: PathBuf,
    write_lock: std::sync::Mutex<()>,
}

impl CandidateStore {
    fn new(run_directory: PathBuf) -> Self {
        Self {
            run_directory,
            write_lock: std::sync::Mutex::new(()),
        }
    }

    fn freeze(&self, mut input: FreezeCandidateInput) -> Result<FrozenCandidate> {
        if input.artifacts.is_empty() {
            return Err(std::io::Error::other("at least one artifact is required").into());
        }
        input.dependencies.sort();
        input.dependencies.dedup();

        let root = self
            .run_directory
            .canonicalize()
            .wrap_err("failed to resolve run directory")?;
        let mut staged_artifacts = input
            .artifacts
            .into_iter()
            .map(|relative| staged_artifact(&root, &relative))
            .collect::<Result<Vec<_>>>()?;
        staged_artifacts.sort_by(|left, right| left.source_path.cmp(&right.source_path));
        staged_artifacts.dedup_by(|left, right| left.source_path == right.source_path);

        let artifact_identity = staged_artifacts
            .iter()
            .map(|artifact| {
                json!({
                    "source_path": artifact.source_path,
                    "bytes": artifact.contents.len(),
                    "sha256": artifact.sha256,
                })
            })
            .collect::<Vec<_>>();

        let identity = serde_json::to_vec(&json!({
            "label": &input.label,
            "claim": &input.claim,
            "artifacts": artifact_identity,
            "dependencies": &input.dependencies,
        }))
        .wrap_err("failed to encode candidate identity")?;
        let candidate_id = sha256(&identity);
        let relative_manifest = format!("frozen/{candidate_id}.json");
        let manifest_path = root.join(&relative_manifest);

        let _guard = self
            .write_lock
            .lock()
            .map_err(|_| std::io::Error::other("candidate store lock poisoned"))?;
        fs::create_dir_all(root.join("frozen"))
            .wrap_err("failed to create frozen-candidate directory")?;
        if manifest_path.exists() {
            let retained =
                fs::read(&manifest_path).wrap_err("failed to read existing frozen candidate")?;
            let candidate: FrozenCandidate = serde_json::from_slice(&retained)
                .wrap_err("failed to decode existing frozen candidate")?;
            validate_frozen_artifacts(&root, &candidate.artifacts)?;
            return Ok(candidate);
        }

        let artifacts = materialize_frozen_artifacts(&root, &candidate_id, staged_artifacts)?;

        let candidate = FrozenCandidate {
            candidate_id,
            label: input.label,
            claim: input.claim,
            created_at_epoch_seconds: epoch_seconds()?,
            artifacts,
            dependencies: input.dependencies,
            manifest_path: relative_manifest,
        };
        let mut file = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(&manifest_path)
            .wrap_err("failed to create frozen-candidate manifest")?;
        serde_json::to_writer_pretty(&mut file, &candidate)
            .wrap_err("failed to encode frozen candidate")?;
        writeln!(file).wrap_err("failed to finish frozen-candidate manifest")?;
        file.sync_all()
            .wrap_err("failed to sync frozen-candidate manifest")?;
        let mut permissions = file
            .metadata()
            .wrap_err("failed to inspect frozen manifest permissions")?
            .permissions();
        permissions.set_readonly(true);
        fs::set_permissions(&manifest_path, permissions)
            .wrap_err("failed to make frozen-candidate manifest read-only")?;
        Ok(candidate)
    }
}

struct FreezeCandidate {
    store: Arc<CandidateStore>,
}

#[async_trait]
impl Tool for FreezeCandidate {
    fn name(&self) -> &'static str {
        "freeze_candidate"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Freeze a candidate from existing files inside the assigned run directory. The host validates containment, copies every byte stream into a read-only content-addressed snapshot, and writes an immutable manifest for independent audit.",
            json!({
                "type": "object",
                "properties": {
                    "label": { "type": "string" },
                    "claim": { "type": "string", "description": "Exact claim made by this candidate; do not silently weaken the target." },
                    "artifacts": {
                        "type": "array",
                        "minItems": 1,
                        "items": { "type": "string", "description": "Path relative to the run directory." }
                    },
                    "dependencies": { "type": "array", "items": { "type": "string" } }
                },
                "required": ["label", "claim", "artifacts"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let candidate = self.store.freeze(input.decode_json()?)?;
        Ok(ToolExecution::json(&candidate))
    }
}

#[derive(Serialize)]
struct VerifierIdentity {
    executable: String,
    sha256: String,
    timeout_seconds: u64,
}

struct CandidateVerifier {
    executable: PathBuf,
    identity: VerifierIdentity,
    run_directory: PathBuf,
    results: std::sync::Mutex<Vec<VerificationResult>>,
}

impl CandidateVerifier {
    fn load(path: &Path, timeout_seconds: u64, run_directory: PathBuf) -> Result<Self> {
        let executable = path
            .canonicalize()
            .wrap_err("failed to resolve --verifier")?;
        if !executable.is_file() {
            return Err(std::io::Error::other("--verifier must name a file").into());
        }
        let bytes = fs::read(&executable).wrap_err("failed to read verifier executable")?;
        Ok(Self {
            identity: VerifierIdentity {
                executable: executable.to_string_lossy().into_owned(),
                sha256: sha256(&bytes),
                timeout_seconds,
            },
            executable,
            run_directory,
            results: std::sync::Mutex::new(Vec::new()),
        })
    }

    async fn verify(&self, candidate_id: &str) -> Result<VerificationResult> {
        if candidate_id.len() != 64
            || !candidate_id
                .bytes()
                .all(|byte| byte.is_ascii_hexdigit() && !byte.is_ascii_uppercase())
        {
            return Err(
                std::io::Error::other("candidate_id must be 64 lowercase hex digits").into(),
            );
        }
        let manifest = self
            .run_directory
            .join("frozen")
            .join(format!("{candidate_id}.json"));
        if !manifest.is_file() {
            return Err(std::io::Error::other("unknown frozen candidate").into());
        }
        let manifest_bytes = fs::read(&manifest).wrap_err("failed to read candidate manifest")?;
        let mut command = tokio::process::Command::new(&self.executable);
        command
            .arg(&manifest)
            .current_dir(&self.run_directory)
            .env_remove("OPENAI_API_KEY")
            .kill_on_drop(true);
        let output = tokio::time::timeout(
            Duration::from_secs(self.identity.timeout_seconds),
            command.output(),
        )
        .await
        .map_err(|_| std::io::Error::new(std::io::ErrorKind::TimedOut, "verifier timed out"))?
        .wrap_err("verifier process failed")?;
        let result = VerificationResult {
            candidate_id: candidate_id.to_owned(),
            accepted: output.status.success(),
            exit_code: output.status.code(),
            verifier_sha256: self.identity.sha256.clone(),
            candidate_manifest_sha256: sha256(&manifest_bytes),
            stdout: bounded_output(&output.stdout),
            stderr: bounded_output(&output.stderr),
        };
        self.results
            .lock()
            .map_err(|_| std::io::Error::other("verifier result lock poisoned"))?
            .push(result.clone());
        Ok(result)
    }

    fn accepted_candidate(&self) -> Result<Option<String>> {
        Ok(self
            .results
            .lock()
            .map_err(|_| std::io::Error::other("verifier result lock poisoned"))?
            .iter()
            .find(|result| result.accepted)
            .map(|result| result.candidate_id.clone()))
    }

    fn result_summary(&self) -> Result<String> {
        let results = self
            .results
            .lock()
            .map_err(|_| std::io::Error::other("verifier result lock poisoned"))?;
        if results.is_empty() {
            return Ok("no verifier invocation has been recorded".to_owned());
        }
        Ok(results
            .iter()
            .enumerate()
            .map(|(index, result)| {
                format!(
                    "attempt {} candidate={} accepted={} exit_code={:?}",
                    index + 1,
                    result.candidate_id,
                    result.accepted,
                    result.exit_code
                )
            })
            .collect::<Vec<_>>()
            .join("; "))
    }
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct VerifyCandidateInput {
    candidate_id: String,
}

#[derive(Clone, Serialize)]
struct VerificationResult {
    candidate_id: String,
    accepted: bool,
    exit_code: Option<i32>,
    verifier_sha256: String,
    candidate_manifest_sha256: String,
    stdout: String,
    stderr: String,
}

struct VerifyCandidate {
    verifier: Arc<CandidateVerifier>,
}

#[async_trait]
impl Tool for VerifyCandidate {
    fn name(&self) -> &'static str {
        "verify_candidate"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Run the campaign's pre-approved deterministic verifier against one frozen candidate manifest. Exit status zero is the verifier acceptance signal; complete bounded stdout and stderr are returned as evidence.",
            json!({
                "type": "object",
                "properties": {
                    "candidate_id": { "type": "string", "pattern": "^[0-9a-f]{64}$" }
                },
                "required": ["candidate_id"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let input: VerifyCandidateInput = input.decode_json()?;
        let result = self.verifier.verify(&input.candidate_id).await?;
        Ok(ToolExecution::json(&result))
    }
}

fn bounded_output(bytes: &[u8]) -> String {
    const LIMIT: usize = 64 * 1024;
    let end = bytes.len().min(LIMIT);
    let mut output = String::from_utf8_lossy(&bytes[..end]).into_owned();
    if bytes.len() > LIMIT {
        output.push_str("\n[output truncated at 65536 bytes]");
    }
    output
}

fn staged_artifact(root: &Path, relative: &str) -> Result<StagedArtifact> {
    let relative_path = Path::new(relative);
    if relative_path.is_absolute() {
        return Err(std::io::Error::other("artifact path must be relative").into());
    }
    let path = root.join(relative_path);
    let canonical = path
        .canonicalize()
        .wrap_err_with(|| format!("failed to resolve artifact `{relative}`"))?;
    if !canonical.starts_with(root) || !canonical.is_file() {
        return Err(std::io::Error::other(format!(
            "artifact `{relative}` is not a file contained by the run directory"
        ))
        .into());
    }
    let bytes =
        fs::read(&canonical).wrap_err_with(|| format!("failed to read artifact `{relative}`"))?;
    let normalized = canonical
        .strip_prefix(root)
        .wrap_err("failed to normalize artifact path")?
        .to_string_lossy()
        .into_owned();
    Ok(StagedArtifact {
        source_path: normalized,
        sha256: sha256(&bytes),
        contents: bytes,
    })
}

fn materialize_frozen_artifacts(
    root: &Path,
    candidate_id: &str,
    staged_artifacts: Vec<StagedArtifact>,
) -> Result<Vec<FrozenArtifact>> {
    let snapshot_root = PathBuf::from("frozen").join(candidate_id).join("artifacts");
    let mut artifacts = Vec::with_capacity(staged_artifacts.len());
    for staged in staged_artifacts {
        let relative_snapshot = snapshot_root.join(&staged.source_path);
        let snapshot = root.join(&relative_snapshot);
        let parent = snapshot.parent().ok_or_else(|| {
            std::io::Error::other("frozen artifact snapshot has no parent directory")
        })?;
        fs::create_dir_all(parent).wrap_err_with(|| {
            format!(
                "failed to create frozen artifact directory `{}`",
                parent.display()
            )
        })?;
        let mut file = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(&snapshot)
            .wrap_err_with(|| {
                format!("failed to create frozen artifact `{}`", snapshot.display())
            })?;
        file.write_all(&staged.contents).wrap_err_with(|| {
            format!("failed to write frozen artifact `{}`", snapshot.display())
        })?;
        file.sync_all()
            .wrap_err_with(|| format!("failed to sync frozen artifact `{}`", snapshot.display()))?;
        let mut permissions = file
            .metadata()
            .wrap_err("failed to inspect frozen artifact permissions")?
            .permissions();
        permissions.set_readonly(true);
        fs::set_permissions(&snapshot, permissions)
            .wrap_err("failed to make frozen artifact read-only")?;
        artifacts.push(FrozenArtifact {
            source_path: staged.source_path,
            path: relative_snapshot.to_string_lossy().into_owned(),
            bytes: u64::try_from(staged.contents.len())
                .wrap_err("artifact size does not fit in u64")?,
            sha256: staged.sha256,
        });
    }
    Ok(artifacts)
}

fn validate_frozen_artifacts(root: &Path, artifacts: &[FrozenArtifact]) -> Result<()> {
    for artifact in artifacts {
        let path = root.join(&artifact.path);
        let canonical = path
            .canonicalize()
            .wrap_err_with(|| format!("failed to resolve frozen artifact `{}`", artifact.path))?;
        if !canonical.starts_with(root) || !canonical.is_file() {
            return Err(std::io::Error::other(format!(
                "frozen artifact `{}` is not a contained file",
                artifact.path
            ))
            .into());
        }
        let bytes = fs::read(&canonical)
            .wrap_err_with(|| format!("failed to read frozen artifact `{}`", artifact.path))?;
        let size = u64::try_from(bytes.len()).wrap_err("artifact size does not fit in u64")?;
        if size != artifact.bytes || sha256(&bytes) != artifact.sha256 {
            return Err(std::io::Error::other(format!(
                "frozen artifact `{}` no longer matches its manifest",
                artifact.path
            ))
            .into());
        }
    }
    Ok(())
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "snake_case")]
enum EvidenceKind {
    Observation,
    Computation,
    Lemma,
    Candidate,
    Refutation,
    Source,
    Verification,
    Failure,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct EvidenceInput {
    route: String,
    kind: EvidenceKind,
    claim: String,
    evidence: String,
    status: String,
    #[serde(default)]
    artifacts: Vec<String>,
    #[serde(default)]
    sources: Vec<String>,
}

#[derive(Serialize)]
struct EvidenceRecord {
    sequence: u64,
    recorded_at_epoch_seconds: u64,
    route: String,
    kind: EvidenceKind,
    claim: String,
    evidence: String,
    status: String,
    artifacts: Vec<String>,
    sources: Vec<String>,
}

struct CampaignLedger {
    path: PathBuf,
    next_sequence: AtomicU64,
    write_lock: std::sync::Mutex<()>,
}

impl CampaignLedger {
    fn new(path: PathBuf) -> Self {
        Self {
            path,
            next_sequence: AtomicU64::new(1),
            write_lock: std::sync::Mutex::new(()),
        }
    }

    fn append(&self, input: EvidenceInput) -> Result<EvidenceRecord> {
        let record = EvidenceRecord {
            sequence: self.next_sequence.fetch_add(1, Ordering::Relaxed),
            recorded_at_epoch_seconds: epoch_seconds()?,
            route: input.route,
            kind: input.kind,
            claim: input.claim,
            evidence: input.evidence,
            status: input.status,
            artifacts: input.artifacts,
            sources: input.sources,
        };
        let _guard = self
            .write_lock
            .lock()
            .map_err(|_| std::io::Error::other("campaign ledger lock poisoned"))?;
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(&self.path)
            .wrap_err("failed to open campaign ledger")?;
        serde_json::to_writer(&mut file, &record).wrap_err("failed to encode evidence record")?;
        writeln!(file).wrap_err("failed to append evidence record")?;
        Ok(record)
    }
}

struct RecordEvidence {
    ledger: Arc<CampaignLedger>,
}

#[async_trait]
impl Tool for RecordEvidence {
    fn name(&self) -> &'static str {
        "record_evidence"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Append one typed observation, lemma, computation, source, failure, candidate, or verification result to the host-owned campaign ledger.",
            json!({
                "type": "object",
                "properties": {
                    "route": { "type": "string", "description": "Stable route or audit identifier." },
                    "kind": {
                        "type": "string",
                        "enum": ["observation", "computation", "lemma", "candidate", "refutation", "source", "verification", "failure"]
                    },
                    "claim": { "type": "string", "description": "Atomic mathematical or procedural claim." },
                    "evidence": { "type": "string", "description": "Concrete support, falsifier, command result, or remaining gap." },
                    "status": {
                        "type": "string",
                        "enum": ["open", "supported", "refuted", "verified", "blocked"]
                    },
                    "artifacts": { "type": "array", "items": { "type": "string" } },
                    "sources": { "type": "array", "items": { "type": "string" } }
                },
                "required": ["route", "kind", "claim", "evidence", "status"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let record = self.ledger.append(input.decode_json()?)?;
        Ok(ToolExecution::json(&record))
    }
}

#[derive(Serialize)]
struct BudgetSnapshot {
    calls_used: u64,
    calls_remaining: u64,
    retained_workers: u64,
    retained_workers_remaining: u64,
}

struct WorkerLimits {
    max_calls: u64,
    used_calls: AtomicU64,
    max_retained_workers: u64,
    retained_workers: AtomicU64,
    permits: Arc<Semaphore>,
    worker_timeout: Option<Duration>,
    worker_closure_after: Option<Duration>,
}

impl WorkerLimits {
    fn new(
        max_calls: u64,
        max_retained_workers: u64,
        max_concurrent_workers: usize,
        worker_timeout: Option<Duration>,
        worker_closure_after: Option<Duration>,
    ) -> Self {
        Self {
            max_calls,
            used_calls: AtomicU64::new(0),
            max_retained_workers,
            retained_workers: AtomicU64::new(0),
            permits: Arc::new(Semaphore::new(max_concurrent_workers)),
            worker_timeout,
            worker_closure_after,
        }
    }

    async fn acquire_permit(&self) -> std::io::Result<tokio::sync::OwnedSemaphorePermit> {
        Arc::clone(&self.permits)
            .acquire_owned()
            .await
            .map_err(|_| std::io::Error::other("worker concurrency limiter stopped"))
    }

    fn acquire_call(&self) -> std::io::Result<BudgetSnapshot> {
        self.used_calls
            .fetch_update(Ordering::AcqRel, Ordering::Relaxed, |used| {
                (used < self.max_calls).then_some(used + 1)
            })
            .map_err(|_| std::io::Error::other("worker model-call budget exhausted"))?;
        Ok(self.snapshot())
    }

    fn reserve_worker(&self) -> std::io::Result<()> {
        self.retained_workers
            .fetch_update(Ordering::AcqRel, Ordering::Relaxed, |retained| {
                (retained < self.max_retained_workers).then_some(retained + 1)
            })
            .map(|_| ())
            .map_err(|_| std::io::Error::other("retained-worker budget exhausted"))
    }

    fn release_worker(&self) {
        self.retained_workers.fetch_sub(1, Ordering::AcqRel);
    }

    fn snapshot(&self) -> BudgetSnapshot {
        let calls_used = self.used_calls.load(Ordering::Relaxed);
        let retained_workers = self.retained_workers.load(Ordering::Relaxed);
        BudgetSnapshot {
            calls_used,
            calls_remaining: self.max_calls.saturating_sub(calls_used),
            retained_workers,
            retained_workers_remaining: self.max_retained_workers.saturating_sub(retained_workers),
        }
    }
}

struct ChildAgents {
    next_id: AtomicU64,
    agents: tokio::sync::Mutex<HashMap<u64, Nanocodex>>,
}

impl Default for ChildAgents {
    fn default() -> Self {
        Self {
            next_id: AtomicU64::new(0),
            agents: tokio::sync::Mutex::new(HashMap::new()),
        }
    }
}

impl ChildAgents {
    fn next_id(&self) -> u64 {
        self.next_id.fetch_add(1, Ordering::Relaxed) + 1
    }

    async fn insert(&self, id: u64, agent: Nanocodex) {
        self.agents.lock().await.insert(id, agent);
    }

    async fn get(&self, id: u64) -> Option<Nanocodex> {
        self.agents.lock().await.get(&id).cloned()
    }

    async fn shutdown(&self) {
        self.agents.lock().await.clear();
    }
}

#[derive(Clone, Copy)]
enum ChildKind {
    Spawn,
    Fork,
}

impl ChildKind {
    const fn name(self) -> &'static str {
        match self {
            Self::Spawn => "spawn_math_agent",
            Self::Fork => "fork_math_agent",
        }
    }

    const fn result_name(self) -> &'static str {
        match self {
            Self::Spawn => "independent",
            Self::Fork => "contextual-fork",
        }
    }

    const fn description(self) -> &'static str {
        match self {
            Self::Spawn => {
                "Start a reusable clean-room mathematics agent with no parent conversation, run its first task, and return an agent ID and report."
            }
            Self::Fork => {
                "Fork a reusable mathematics agent from the invoking agent's latest safe context, run its first task, and return an agent ID and report."
            }
        }
    }

    fn prompt(self, role: &str, task: &str) -> String {
        match self {
            Self::Spawn => format!(
                "You are an independent {role} in a mathematical research program. You inherit no conclusions from the lead. Attack only the delegated task, expose assumptions, and return lemmas, counterexamples, computations, or objections that can be checked independently. Do not claim success merely because another model agrees.\n\nDelegated task:\n{task}"
            ),
            Self::Fork => format!(
                "Act as the contextual {role} for the current research branch. Preserve the exact problem statement, but challenge inherited conclusions and repair only what can be justified.\n\nDelegated task:\n{task}"
            ),
        }
    }
}

struct CleanWorkerFactory {
    api_key: String,
    workspace: PathBuf,
    session_prefix: String,
    prompt_cache_key: String,
    fast_mode: bool,
    exact_jobs: ExactJobRunner,
    max_exact_jobs_per_worker: u64,
    artifacts: ArtifactReader,
}

impl CleanWorkerFactory {
    fn build(&self, agent_id: u64) -> Result<(Nanocodex, AgentEvents)> {
        let tools = Tools::builder()
            .without_defaults()
            .tool(self.artifacts.clone())
            .tool(self.exact_jobs.scoped(self.max_exact_jobs_per_worker))
            .build()?;
        Nanocodex::builder(self.api_key.clone())
            .session_id(format!("{}-worker-{agent_id}", self.session_prefix))
            .prompt_cache_key(self.prompt_cache_key.clone())
            .shared_prompt_cache()
            .instructions(format!(
                "You are a bounded clean-room worker inside a mathematical research campaign. You receive only the delegated task. Return checkable mathematical content and explicit uncertainty. Mathematical inference is your primary work: first seek a structural lemma, representation, proof step, obstruction, or sharply targeted experiment. Do not turn the task into a generic census merely because computation is available. You have no writable filesystem, web, or child-agent tools. Read prior retained evidence with inspect_research_artifacts; never spend exact-computation jobs on find/cat/sed. Recorder-owned events.jsonl files are observability streams, not research artifacts: never read, search, copy, or paginate them. Artifact paths are relative to the host's runs/ directory. The current run prefix is `{}`; therefore a current-run path such as `delayed3/summary.json` must be read as `{}/delayed3/summary.json`. List `.` if you need to discover other retained run prefixes. For every mathematically justified CAS, solver, enumeration, compiler, or long computation, use the host-supervised run_exact_job tool; state the hypothesis it tests, why the search distribution is enriched, the decision rule, and the kill rule, then emit progress or a heartbeat and inspect its retained output. A heartbeat alone is not a resumable checkpoint: any search that can approach its deadline must atomically persist and consume a versioned cursor or completed-shard manifest, and retain an early restart/resume self-check. Your exact-job quota is deliberately local so other routes retain compute. Do not pretend to have executed a check you could not perform.",
                self.session_prefix, self.session_prefix
            ))
            .reasoning_mode(ReasoningMode::Pro)
            .thinking(Thinking::Max)
            .fast_mode(self.fast_mode)
            .tools(tools)
            .workspace(&self.workspace)
            .build()
            .wrap_err("failed to build clean mathematics worker")
    }
}

#[derive(Clone)]
struct ChildAgent {
    agent: AgentHandle,
    clean_factory: Arc<CleanWorkerFactory>,
    agents: Weak<ChildAgents>,
    limits: Arc<WorkerLimits>,
    recorder: CampaignRecorder,
    run_directory: PathBuf,
    kind: ChildKind,
}

impl ChildAgent {
    fn new(
        agent: AgentHandle,
        clean_factory: Arc<CleanWorkerFactory>,
        agents: Weak<ChildAgents>,
        limits: Arc<WorkerLimits>,
        recorder: CampaignRecorder,
        run_directory: PathBuf,
        kind: ChildKind,
    ) -> Self {
        Self {
            agent,
            clean_factory,
            agents,
            limits,
            recorder,
            run_directory,
            kind,
        }
    }

    async fn run(&self, task: AgentTask) -> Result<WorkerResult> {
        let AgentTask { role, task } = task;
        let agents = self
            .agents
            .upgrade()
            .ok_or_else(|| std::io::Error::other("child-agent registry stopped"))?;
        let _permit = self.limits.acquire_permit().await?;
        self.limits.reserve_worker()?;
        let budget = match self.limits.acquire_call() {
            Ok(budget) => budget,
            Err(error) => {
                self.limits.release_worker();
                return Err(error.into());
            }
        };
        let agent_id = agents.next_id();
        let child_result = match self.kind {
            ChildKind::Spawn => self.clean_factory.build(agent_id),
            ChildKind::Fork => self.agent.fork().await.map_err(eyre::Report::from),
        };
        let (child, events) = match child_result {
            Ok(child) => child,
            Err(error) => {
                self.limits.release_worker();
                return Err(error);
            }
        };
        self.recorder
            .observe(format!("agent-{agent_id}:{role}"), events)?;
        let turn = match child.prompt(self.kind.prompt(&role, &task)).await {
            Ok(turn) => turn,
            Err(error) => {
                self.limits.release_worker();
                return Err(error.into());
            }
        };
        let result = match await_worker_turn(
            turn,
            self.limits.worker_timeout,
            self.limits.worker_closure_after,
        )
        .await
        {
            Ok(result) => result,
            Err(error) => {
                self.limits.release_worker();
                return Err(error);
            }
        };
        let snapshot_path = match retain_turn_snapshot(
            &self.run_directory,
            &format!("agent-{agent_id}-call-{}", budget.calls_used),
            &result,
        ) {
            Ok(path) => path,
            Err(error) => {
                self.limits.release_worker();
                return Err(error);
            }
        };
        let report = result.final_message;
        let report_path = match retain_worker_report(&self.run_directory, agent_id, &role, &report)
        {
            Ok(path) => path,
            Err(error) => {
                self.limits.release_worker();
                return Err(error);
            }
        };
        agents.insert(agent_id, child).await;
        Ok(WorkerResult {
            agent_id,
            kind: self.kind.result_name(),
            role,
            report,
            report_path,
            snapshot_path,
            budget,
        })
    }
}

#[async_trait]
impl Tool for ChildAgent {
    fn name(&self) -> &'static str {
        self.kind.name()
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            self.kind.description(),
            json!({
                "type": "object",
                "properties": {
                    "role": {
                        "type": "string",
                        "description": "Short role such as counterexample-scout, proof-architect, formalizer, or adversarial-auditor."
                    },
                    "task": {
                        "type": "string",
                        "description": "A complete, bounded mathematical assignment with required evidence."
                    }
                },
                "required": ["role", "task"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let result = self.run(input.decode_json()?).await?;
        Ok(ToolExecution::json(&result))
    }
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct AgentBatchInput {
    tasks: Vec<AgentTask>,
}

#[derive(Serialize)]
struct AgentBatchItem {
    index: usize,
    status: &'static str,
    result: Option<WorkerResult>,
    error: Option<String>,
}

#[derive(Serialize)]
struct AgentBatchResult {
    items: Vec<AgentBatchItem>,
    succeeded: usize,
    failed: usize,
}

struct AgentBatch {
    runner: ChildAgent,
    max_batch_size: usize,
}

#[async_trait]
impl Tool for AgentBatch {
    fn name(&self) -> &'static str {
        "spawn_math_batch"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Run a bounded batch of independent clean-room mathematical assignments. The host owns concurrency, per-child deadlines, cancellation, ordering, automatic report retention, and compact failure reporting. Returns one object shaped as {items: [{index, status, result, error}], succeeded, failed}; each completed result includes report_path, and consumers must read result.items rather than iterating the top-level object.",
            json!({
                "type": "object",
                "properties": {
                    "tasks": {
                        "type": "array",
                        "minItems": 1,
                        "maxItems": self.max_batch_size,
                        "items": {
                            "type": "object",
                            "properties": {
                                "role": { "type": "string" },
                                "task": { "type": "string", "description": "Complete bounded assignment with its evidence/output contract." }
                            },
                            "required": ["role", "task"],
                            "additionalProperties": false
                        }
                    }
                },
                "required": ["tasks"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let input: AgentBatchInput = input.decode_json()?;
        if input.tasks.is_empty() || input.tasks.len() > self.max_batch_size {
            return Err(std::io::Error::other(format!(
                "batch size must be between 1 and {}",
                self.max_batch_size
            ))
            .into());
        }
        let calls = input
            .tasks
            .into_iter()
            .enumerate()
            .map(|(index, task)| async move {
                match self.runner.run(task).await {
                    Ok(result) => AgentBatchItem {
                        index,
                        status: "completed",
                        result: Some(result),
                        error: None,
                    },
                    Err(error) => AgentBatchItem {
                        index,
                        status: "failed",
                        result: None,
                        error: Some(format!("{error:#}")),
                    },
                }
            });
        let items = futures::future::join_all(calls).await;
        let succeeded = items
            .iter()
            .filter(|item| item.status == "completed")
            .count();
        let failed = items.len().saturating_sub(succeeded);
        Ok(ToolExecution::json(&AgentBatchResult {
            items,
            succeeded,
            failed,
        }))
    }
}

async fn await_worker_turn(
    turn: Turn,
    timeout: Option<Duration>,
    closure_after: Option<Duration>,
) -> Result<TurnResult> {
    let control = turn.control();
    let closure = closure_after.map(|delay| {
        let control = control.clone();
        tokio::spawn(async move {
            tokio::time::sleep(delay).await;
            control.steer(WORKER_CLOSURE_STEER).await
        })
    });
    let result = turn.result();
    tokio::pin!(result);
    let completed = if let Some(timeout) = timeout {
        let deadline = tokio::time::sleep(timeout);
        tokio::pin!(deadline);
        tokio::select! {
            completed = &mut result => Ok(completed?),
            () = &mut deadline => {
                let _ = control.cancel().await;
                let _ = result.await;
                Err(std::io::Error::new(
                    std::io::ErrorKind::TimedOut,
                    format!("worker turn exceeded {} seconds and was cancelled", timeout.as_secs()),
                ).into())
            }
        }
    } else {
        Ok(result.await?)
    };
    if let Some(closure) = closure {
        if !closure.is_finished() {
            closure.abort();
        }
        match closure.await {
            Ok(Ok(())) | Err(_) => {}
            Ok(Err(error)) => eprintln!("worker closure steer was not accepted: {error}"),
        }
    }
    completed
}

fn retain_worker_report(
    run_directory: &Path,
    agent_id: u64,
    role: &str,
    report: &str,
) -> Result<String> {
    let reports = run_directory.join("worker-reports");
    fs::create_dir_all(&reports).wrap_err("failed to create worker-report directory")?;
    let relative = format!("worker-reports/agent-{agent_id}-{}.md", artifact_slug(role));
    let path = run_directory.join(&relative);
    let mut file = OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(&path)
        .wrap_err("failed to create retained worker report")?;
    file.write_all(report.as_bytes())
        .wrap_err("failed to write retained worker report")?;
    if !report.ends_with('\n') {
        writeln!(file).wrap_err("failed to finish retained worker report")?;
    }
    Ok(relative)
}

fn retain_turn_snapshot(run_directory: &Path, name: &str, result: &TurnResult) -> Result<String> {
    let snapshots = run_directory.join("session-snapshots");
    fs::create_dir_all(&snapshots).wrap_err("failed to create session-snapshot directory")?;
    let relative = format!("session-snapshots/{name}.json");
    let path = run_directory.join(&relative);
    let mut file = OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(&path)
        .wrap_err("failed to create retained session snapshot")?;
    serde_json::to_writer(&mut file, &result.snapshot())
        .wrap_err("failed to serialize retained session snapshot")?;
    file.sync_all()
        .wrap_err("failed to sync retained session snapshot")?;
    Ok(relative)
}

fn artifact_slug(value: &str) -> String {
    let mut slug = String::new();
    let mut previous_separator = false;
    for character in value.chars().take(80) {
        if character.is_ascii_alphanumeric() {
            slug.push(character.to_ascii_lowercase());
            previous_separator = false;
        } else if !previous_separator && !slug.is_empty() {
            slug.push('-');
            previous_separator = true;
        }
    }
    while slug.ends_with('-') {
        slug.pop();
    }
    if slug.is_empty() {
        "worker".to_owned()
    } else {
        slug
    }
}

struct PromptAgent {
    agents: Weak<ChildAgents>,
    limits: Arc<WorkerLimits>,
    run_directory: PathBuf,
}

#[async_trait]
impl Tool for PromptAgent {
    fn name(&self) -> &'static str {
        "prompt_math_agent"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Send a targeted follow-up to a retained mathematics agent while preserving that child's private conversation and work.",
            json!({
                "type": "object",
                "properties": {
                    "agent_id": { "type": "integer", "minimum": 1 },
                    "task": {
                        "type": "string",
                        "description": "The next check, repair, formalization request, or adversarial question."
                    }
                },
                "required": ["agent_id", "task"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let FollowUpTask { agent_id, task } = input.decode_json()?;
        let agents = self
            .agents
            .upgrade()
            .ok_or_else(|| std::io::Error::other("child-agent registry stopped"))?;
        let child = agents
            .get(agent_id)
            .await
            .ok_or_else(|| std::io::Error::other(format!("unknown agent_id {agent_id}")))?;
        let _permit = self.limits.acquire_permit().await?;
        let budget = self.limits.acquire_call()?;
        let turn = child.prompt(task).await?;
        let result = await_worker_turn(
            turn,
            self.limits.worker_timeout,
            self.limits.worker_closure_after,
        )
        .await?;
        let snapshot_path = retain_turn_snapshot(
            &self.run_directory,
            &format!("agent-{agent_id}-call-{}", budget.calls_used),
            &result,
        )?;
        Ok(ToolExecution::json(&FollowUpResult {
            agent_id,
            report: result.final_message,
            snapshot_path,
            budget,
        }))
    }
}

struct CampaignRuntime {
    workspace: PathBuf,
    session_id: String,
    run_directory: PathBuf,
    recorder: CampaignRecorder,
    artifacts: ArtifactReader,
    children: Arc<ChildAgents>,
    limits: Arc<WorkerLimits>,
    ledger: Arc<CampaignLedger>,
    candidates: Arc<CandidateStore>,
    verifier: Option<Arc<CandidateVerifier>>,
    clean_workers: Arc<CleanWorkerFactory>,
    exact_jobs: ExactJobRunner,
}

impl CampaignRuntime {
    fn initialize(args: &Args, api_key: &str, workspace: PathBuf) -> Result<Self> {
        let session_id = session_id()?;
        let run_directory = workspace.join("runs").join(&session_id);
        fs::create_dir_all(&run_directory).wrap_err("failed to create run directory")?;
        fs::write(run_directory.join("problem.md"), &args.problem)
            .wrap_err("failed to freeze problem statement")?;
        let verifier = args
            .verifier
            .as_deref()
            .map(|path| {
                CandidateVerifier::load(path, args.verifier_timeout_seconds, run_directory.clone())
                    .map(Arc::new)
            })
            .transpose()?;
        CampaignManifest {
            protocol_version: 1,
            session_id: &session_id,
            created_at_epoch_seconds: epoch_seconds()?,
            nanocodex_git_commit: NANOCODEX_GIT_COMMIT,
            nanocodex_source_sha256: NANOCODEX_SOURCE_SHA256,
            nanocodex_build_dirty: NANOCODEX_BUILD_DIRTY == "true",
            model: "gpt-5.6-sol",
            reasoning_mode: "pro",
            thinking: "max",
            fast_mode: args.fast_mode,
            discovery_policy: "inference-first-v1",
            web_policy: args.web_policy,
            max_worker_calls: args.max_worker_calls,
            max_retained_workers: args.max_retained_workers,
            max_concurrent_workers: args.max_concurrent_workers,
            worker_timeout_seconds: args.worker_timeout_seconds,
            worker_closure_after_seconds: args.worker_closure_after_seconds,
            max_batch_size: args.max_batch_size,
            max_exact_jobs: args.max_exact_jobs,
            max_concurrent_exact_jobs: args.max_concurrent_exact_jobs,
            max_exact_artifact_bytes: args.max_exact_artifact_bytes,
            max_exact_jobs_per_worker: args.max_exact_jobs_per_worker,
            verifier: verifier.as_ref().map(|verifier| &verifier.identity),
            closure_after_seconds: args.closure_after_seconds,
            max_lead_turns: args.max_lead_turns,
            campaign_timeout_seconds: args.campaign_timeout_seconds,
            problem_sha256: sha256(args.problem.as_bytes()),
            research_manager_sha256: sha256(RESEARCH_MANAGER.as_bytes()),
        }
        .write(&run_directory.join("campaign.json"))?;
        let exact_jobs = ExactJobRunner::new(
            run_directory.clone(),
            args.max_exact_jobs,
            args.max_concurrent_exact_jobs,
            args.max_exact_artifact_bytes,
        );
        let artifacts = ArtifactReader::new(&workspace)?;
        Ok(Self {
            recorder: CampaignRecorder::create(&run_directory.join("events.jsonl"))?,
            artifacts: artifacts.clone(),
            children: Arc::new(ChildAgents::default()),
            limits: Arc::new(WorkerLimits::new(
                args.max_worker_calls,
                args.max_retained_workers,
                args.max_concurrent_workers,
                (args.worker_timeout_seconds != 0)
                    .then(|| Duration::from_secs(args.worker_timeout_seconds)),
                args.worker_closure_after_seconds.map(Duration::from_secs),
            )),
            ledger: Arc::new(CampaignLedger::new(run_directory.join("ledger.jsonl"))),
            candidates: Arc::new(CandidateStore::new(run_directory.clone())),
            exact_jobs: exact_jobs.clone(),
            verifier,
            clean_workers: Arc::new(CleanWorkerFactory {
                api_key: api_key.to_owned(),
                workspace: workspace.clone(),
                session_prefix: session_id.clone(),
                prompt_cache_key: format!("{}-clean-worker-v1", args.prompt_cache_key),
                fast_mode: args.fast_mode,
                exact_jobs,
                max_exact_jobs_per_worker: args.max_exact_jobs_per_worker,
                artifacts,
            }),
            workspace,
            session_id,
            run_directory,
        })
    }

    fn build_lead(&self, args: &Args, api_key: &str) -> Result<(Nanocodex, AgentEvents)> {
        let children = Arc::downgrade(&self.children);
        let ledger = self.ledger.clone();
        let candidates = self.candidates.clone();
        let limits = self.limits.clone();
        let clean_workers = self.clean_workers.clone();
        let recorder = self.recorder.clone();
        let verifier = self.verifier.clone();
        let web_policy = args.web_policy;
        let max_batch_size = args.max_batch_size;
        let exact_jobs = self.exact_jobs.clone();
        let artifacts = self.artifacts.clone();
        let run_directory = self.run_directory.clone();
        Nanocodex::builder(api_key.to_owned())
            .session_id(&self.session_id)
            .prompt_cache_key(args.prompt_cache_key.clone())
            .shared_prompt_cache()
            .instructions(RESEARCH_MANAGER)
            .reasoning_mode(ReasoningMode::Pro)
            .thinking(Thinking::Max)
            .fast_mode(args.fast_mode)
            .tools_factory(move |handle| {
                let clean_runner = ChildAgent::new(
                    handle.clone(),
                    clean_workers.clone(),
                    children.clone(),
                    limits.clone(),
                    recorder.clone(),
                    run_directory.clone(),
                    ChildKind::Spawn,
                );
                let tools = Tools::builder()
                    .web_search(web_policy.discovery_enabled())
                    .tool(RecordEvidence {
                        ledger: ledger.clone(),
                    })
                    .tool(artifacts.clone())
                    .tool(FreezeCandidate {
                        store: candidates.clone(),
                    })
                    .tool(exact_jobs.clone())
                    .tool(AgentBatch {
                        runner: clean_runner.clone(),
                        max_batch_size,
                    })
                    .tool(clean_runner)
                    .tool(ChildAgent::new(
                        handle,
                        clean_workers.clone(),
                        children.clone(),
                        limits.clone(),
                        recorder.clone(),
                        run_directory.clone(),
                        ChildKind::Fork,
                    ))
                    .tool(PromptAgent {
                        agents: children.clone(),
                        limits: limits.clone(),
                        run_directory: run_directory.clone(),
                    });
                match &verifier {
                    Some(verifier) => tools
                        .tool(VerifyCandidate {
                            verifier: verifier.clone(),
                        })
                        .build(),
                    None => tools.build(),
                }
            })
            .workspace(&self.workspace)
            .build()
            .wrap_err("failed to build lead research agent")
    }

    fn discovery_task(&self, args: &Args) -> String {
        let search = if args.web_policy.discovery_enabled() {
            "enabled"
        } else {
            "disabled"
        };
        let verification = if self.verifier.is_some() {
            "A pre-approved `verify_candidate` tool is available; a zero exit status is the host verifier gate."
        } else {
            "No pre-approved campaign verifier was supplied. You may produce a strong candidate, but model review alone cannot make the run verified."
        };
        let worker_deadline = if args.worker_timeout_seconds == 0 {
            "no host-imposed child deadline".to_owned()
        } else {
            format!("a {}-second child deadline", args.worker_timeout_seconds)
        };
        format!(
            "Research the mathematical problem below using the full evidence-first protocol. The immutable problem statement is between the delimiters and has already been frozen in `problem.md`. Write all artifacts only beneath `{}`. The enforced campaign web policy is `{}`; web search during this discovery phase is `{search}`. A separate clean novelty auditor will run only after discovery when policy permits. You have at most {} worker prompts, {} retained workers, {} concurrent child turns, {worker_deadline}, and batches of at most {} assignments. You also have {} host-supervised exact-computation jobs with at most {} executing concurrently. Treat model inference as the primary discovery engine: prioritize theorem transfer, structural reductions, proof construction, counterexample design, and adversarial gap repair. Computation should test a focused mathematical hypothesis, generate a compact certificate, or verify a candidate—not replace research with an undirected census. Prefer `spawn_math_batch` for mechanically parallel independent reasoning routes. When a long enumeration, solver, compiler, or CAS process is mathematically justified, use `run_exact_job`; first record its hypothesis, enriched search representation, decision rule, checkpoint, and kill rule. Use individual or retained workers only when adaptation is necessary. Use `record_evidence` for load-bearing facts and `freeze_candidate` before claiming a complete candidate. {verification} Finish with a status of verified, strong-candidate, partial, refuted, rediscovered, or blocked; never silently weaken the target.\n\n--- PROBLEM START ---\n{}\n--- PROBLEM END ---",
            self.run_directory.display(),
            args.web_policy.name(),
            args.max_worker_calls,
            args.max_retained_workers,
            args.max_concurrent_workers,
            args.max_batch_size,
            args.max_exact_jobs,
            args.max_concurrent_exact_jobs,
            args.problem
        )
    }

    fn verifier_accepted_candidate(&self) -> Result<Option<String>> {
        self.verifier
            .as_ref()
            .map_or_else(|| Ok(None), |verifier| verifier.accepted_candidate())
    }

    fn continuation_task(&self, turn_index: u32, remaining: Duration) -> Result<String> {
        let verification = self.verifier.as_ref().map_or_else(
            || Ok("no pre-approved verifier is configured".to_owned()),
            |verifier| verifier.result_summary(),
        )?;
        let budget = self.limits.snapshot();
        Ok(format!(
            "HOST FAILURE DETECTOR: lead turn {turn_index} ended without a verifier-accepted candidate. This is a provisional research failure, not permission to stop the campaign. Read the retained conversation, `ledger.jsonl`, frozen candidates, exact-job records, and exact verifier feedback. First write a concise failure postmortem identifying the falsified assumption, exhausted representation, stalled job, or missing certificate. Then choose a materially different mathematical route or representation; do not merely paraphrase the failed argument or increase a generic search bound. Prefer a new structural lemma, theorem transfer, proof decomposition, or designed counterexample. Use host-supervised exact computation only to test a focused claim, produce a compact certificate, or verify a candidate. Repair a rejected frozen candidate when feedback is actionable, and use clean workers only for genuinely independent work. Freeze and verify every complete candidate. You have approximately {} seconds of campaign wall time remaining. Worker budget: calls_used={}, calls_remaining={}, retained_workers={}, retained_workers_remaining={}. Exact-job budget: {}. Verifier state: {verification}. Continue now. Return blocked only when the host-enforced campaign budget is actually exhausted; the host, not this turn, decides when that has happened.",
            remaining.as_secs(),
            budget.calls_used,
            budget.calls_remaining,
            budget.retained_workers,
            budget.retained_workers_remaining,
            self.exact_jobs.budget_summary(),
        ))
    }

    async fn run_novelty_audit(&self, args: &Args, api_key: &str) -> Result<()> {
        let ledger = self.ledger.clone();
        let (auditor, events) = Nanocodex::builder(api_key.to_owned())
            .session_id(format!("{}-novelty", self.session_id))
            .prompt_cache_key(format!("{}-novelty-v1", args.prompt_cache_key))
            .shared_prompt_cache()
            .instructions(NOVELTY_AUDITOR)
            .reasoning_mode(ReasoningMode::Pro)
            .thinking(Thinking::Max)
            .fast_mode(args.fast_mode)
            .tools_factory(move |_| {
                Tools::builder()
                    .web_search(true)
                    .tool(RecordEvidence {
                        ledger: ledger.clone(),
                    })
                    .build()
            })
            .workspace(&self.workspace)
            .build()?;
        self.recorder
            .observe("novelty-auditor".to_owned(), events)?;
        let task = format!(
            "Perform an independent novelty and source audit of the completed discovery run under `{}`. Read `problem.md`, `lead-final.md`, `ledger.jsonl`, every `frozen/*.json` manifest, and their referenced artifacts. You may use unrestricted web search. Write the complete audit only beneath the run directory, especially `novelty-audit.md`. Record every material source and overlap determination with `record_evidence`. Do not edit discovery artifacts or repair the proof.\n\nRun directory: {}",
            args.web_policy.name(),
            self.run_directory.display()
        );
        let novelty = auditor.prompt(task).await?.result().await?;
        fs::write(
            self.run_directory.join("novelty-final.md"),
            &novelty.final_message,
        )
        .wrap_err("failed to retain novelty-auditor final message")?;
        println!("\n--- novelty audit ---\n{}", novelty.final_message);
        drop(auditor);
        Ok(())
    }
}

async fn await_lead_turn(
    turn: Turn,
    timeout: Duration,
    closure_after: Option<Duration>,
) -> Result<Option<TurnResult>> {
    let control = turn.control();
    let closure = closure_after.map(|delay| {
        let control = control.clone();
        tokio::spawn(async move {
            tokio::time::sleep(delay).await;
            control.steer(CLOSURE_STEER).await
        })
    });
    let result = turn.result();
    tokio::pin!(result);
    let deadline = tokio::time::sleep(timeout);
    tokio::pin!(deadline);
    let completed = tokio::select! {
        completed = &mut result => Some(completed?),
        () = &mut deadline => {
            let _ = control.cancel().await;
            let _ = result.await;
            None
        }
    };
    if let Some(closure) = closure {
        if !closure.is_finished() {
            closure.abort();
        }
        match closure.await {
            Ok(Ok(())) | Err(_) => {}
            Ok(Err(error)) => eprintln!("closure-mode steer was not accepted: {error}"),
        }
    }
    Ok(completed)
}

#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();
    if let Some(env_file) = &args.env_file {
        dotenvy::from_path(env_file).wrap_err("failed to load --env-file")?;
    } else {
        let _ = dotenvy::dotenv();
    }
    validate_args(&args)?;
    let api_key = std::env::var("OPENAI_API_KEY").wrap_err("OPENAI_API_KEY is required")?;
    let workspace = args
        .workspace
        .canonicalize()
        .wrap_err("failed to resolve --workspace")?;
    let campaign = CampaignRuntime::initialize(&args, &api_key, workspace)?;
    let (agent, events) = campaign.build_lead(&args, &api_key)?;
    campaign.recorder.observe("lead".to_owned(), events)?;
    let started = Instant::now();
    let campaign_timeout = Duration::from_secs(args.campaign_timeout_seconds);
    let mut task = campaign.discovery_task(&args);
    let mut final_message = String::new();
    let mut stop_reason = "lead-turn budget exhausted".to_owned();
    for turn_index in 1..=args.max_lead_turns {
        let remaining = campaign_timeout.saturating_sub(started.elapsed());
        if remaining.is_zero() {
            "campaign wall-time budget exhausted".clone_into(&mut stop_reason);
            break;
        }
        let turn = agent.prompt(task).await?;
        let closure = (turn_index == 1)
            .then(|| args.closure_after_seconds.map(Duration::from_secs))
            .flatten()
            .filter(|delay| *delay < remaining);
        let Some(result) = await_lead_turn(turn, remaining, closure).await? else {
            "campaign wall-time budget exhausted during an active turn"
                .clone_into(&mut stop_reason);
            break;
        };
        retain_turn_snapshot(
            &campaign.run_directory,
            &format!("lead-turn-{turn_index}"),
            &result,
        )?;
        final_message.clone_from(&result.final_message);
        fs::write(
            campaign
                .run_directory
                .join(format!("lead-turn-{turn_index}.md")),
            &result.final_message,
        )
        .wrap_err("failed to retain lead turn message")?;
        println!("\n--- lead turn {turn_index} ---\n{}", result.final_message);

        if let Some(candidate_id) = campaign.verifier_accepted_candidate()? {
            stop_reason = format!("verifier accepted candidate {candidate_id}");
            break;
        }
        if turn_index == args.max_lead_turns {
            break;
        }
        let remaining = campaign_timeout.saturating_sub(started.elapsed());
        if remaining.is_zero() {
            "campaign wall-time budget exhausted".clone_into(&mut stop_reason);
            break;
        }
        task = campaign.continuation_task(turn_index, remaining)?;
    }
    if final_message.is_empty() {
        final_message = format!("Campaign stopped without a completed lead turn: {stop_reason}.");
    }
    fs::write(campaign.run_directory.join("lead-final.md"), &final_message)
        .wrap_err("failed to retain lead final message")?;
    fs::write(
        campaign.run_directory.join("campaign-final.json"),
        serde_json::to_vec_pretty(&json!({
            "stop_reason": stop_reason,
            "elapsed_seconds": started.elapsed().as_secs(),
            "verifier_accepted_candidate": campaign.verifier_accepted_candidate()?,
            "worker_budget": campaign.limits.snapshot(),
            "exact_job_budget": campaign.exact_jobs.budget_snapshot(),
        }))?,
    )
    .wrap_err("failed to retain host campaign verdict")?;
    println!("\n--- host stop reason ---\n{stop_reason}");
    campaign.children.shutdown().await;
    drop(agent);
    if args.web_policy.runs_novelty_audit() {
        campaign.run_novelty_audit(&args, &api_key).await?;
    }
    campaign.recorder.finish().await?;
    println!("\nrun directory: {}", campaign.run_directory.display());
    Ok(())
}

fn validate_args(args: &Args) -> Result<()> {
    if args.max_lead_turns == 0
        || args.campaign_timeout_seconds == 0
        || args.max_concurrent_workers == 0
        || args.max_batch_size == 0
        || args.max_exact_jobs == 0
        || args.max_concurrent_exact_jobs == 0
        || args.max_exact_artifact_bytes == 0
        || args.max_exact_jobs_per_worker == 0
    {
        return Err(std::io::Error::other(
            "turn, campaign, batch, worker-concurrency, and exact-job limits must be positive",
        )
        .into());
    }
    if args.worker_closure_after_seconds.is_some_and(|closure| {
        closure == 0 || (args.worker_timeout_seconds != 0 && closure >= args.worker_timeout_seconds)
    }) {
        return Err(std::io::Error::other(
            "--worker-closure-after-seconds must be positive and, when a worker timeout is enabled, less than --worker-timeout-seconds",
        )
        .into());
    }
    Ok(())
}

fn session_id() -> Result<String> {
    let epoch = epoch_seconds()?;
    Ok(format!("math-{epoch}-{}", process::id()))
}

fn epoch_seconds() -> Result<u64> {
    Ok(SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .wrap_err("system clock predates Unix epoch")?
        .as_secs())
}

fn sha256(bytes: &[u8]) -> String {
    format!("{:x}", Sha256::digest(bytes))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn campaign_ledger_appends_monotonic_jsonl() -> Result<()> {
        let path = std::env::temp_dir().join(format!(
            "nanocodex-erdos-ledger-{}-{}.jsonl",
            process::id(),
            epoch_seconds()?
        ));
        let ledger = CampaignLedger::new(path.clone());

        for claim in ["first claim", "second claim"] {
            ledger.append(EvidenceInput {
                route: "test-route".to_owned(),
                kind: EvidenceKind::Observation,
                claim: claim.to_owned(),
                evidence: "test evidence".to_owned(),
                status: "open".to_owned(),
                artifacts: Vec::new(),
                sources: Vec::new(),
            })?;
        }

        let records = std::fs::read_to_string(&path)
            .wrap_err("failed to read test ledger")?
            .lines()
            .map(serde_json::from_str::<serde_json::Value>)
            .collect::<Result<Vec<_>, _>>()?;
        assert_eq!(records.len(), 2);
        assert_eq!(records[0]["sequence"], 1);
        assert_eq!(records[1]["sequence"], 2);
        assert_eq!(records[1]["claim"], "second claim");

        std::fs::remove_file(path).wrap_err("failed to remove test ledger")?;
        Ok(())
    }

    #[test]
    fn candidate_freeze_is_content_addressed_and_idempotent() -> Result<()> {
        let directory = std::env::temp_dir().join(format!(
            "nanocodex-erdos-freeze-{}-{}",
            process::id(),
            epoch_seconds()?
        ));
        fs::create_dir_all(&directory).wrap_err("failed to create test run directory")?;
        fs::write(directory.join("candidate.md"), "exact candidate")
            .wrap_err("failed to create test candidate")?;
        let store = CandidateStore::new(directory.clone());

        let freeze = || FreezeCandidateInput {
            label: "test candidate".to_owned(),
            claim: "the exact test claim".to_owned(),
            artifacts: vec!["candidate.md".to_owned()],
            dependencies: vec!["lemma-1".to_owned()],
        };
        let first = store.freeze(freeze())?;
        let second = store.freeze(freeze())?;

        assert_eq!(first.candidate_id, second.candidate_id);
        assert_eq!(first.artifacts.len(), 1);
        assert_eq!(first.artifacts[0].source_path, "candidate.md");
        assert_eq!(
            first.artifacts[0].path,
            format!("frozen/{}/artifacts/candidate.md", first.candidate_id)
        );
        assert!(directory.join(&first.manifest_path).is_file());
        fs::write(directory.join("candidate.md"), "mutated live candidate")?;
        assert_eq!(
            fs::read_to_string(directory.join(&first.artifacts[0].path))?,
            "exact candidate"
        );

        fs::remove_dir_all(directory).wrap_err("failed to remove test run directory")?;
        Ok(())
    }

    #[test]
    fn worker_limits_enforce_both_budgets() -> Result<()> {
        let limits = WorkerLimits::new(1, 1, 1, Some(Duration::from_secs(1)), None);
        limits.reserve_worker()?;
        let snapshot = limits.acquire_call()?;
        assert_eq!(snapshot.calls_remaining, 0);
        assert_eq!(snapshot.retained_workers_remaining, 0);
        assert!(limits.acquire_call().is_err());
        assert!(limits.reserve_worker().is_err());
        limits.release_worker();
        assert_eq!(limits.snapshot().retained_workers, 0);
        Ok(())
    }

    #[test]
    fn worker_reports_are_retained_under_safe_paths() -> Result<()> {
        let directory = std::env::temp_dir().join(format!(
            "nanocodex-erdos-report-{}-{}",
            process::id(),
            epoch_seconds()?
        ));
        fs::create_dir_all(&directory)?;
        let relative = retain_worker_report(
            &directory,
            7,
            "Adversarial / Auditor ../",
            "checkable report",
        )?;

        assert_eq!(relative, "worker-reports/agent-7-adversarial-auditor.md");
        assert_eq!(
            fs::read_to_string(directory.join(relative))?,
            "checkable report\n"
        );
        fs::remove_dir_all(directory)?;
        Ok(())
    }

    #[cfg(unix)]
    #[tokio::test]
    async fn preapproved_verifier_runs_against_frozen_manifest() -> Result<()> {
        use std::os::unix::fs::PermissionsExt;

        let directory = std::env::temp_dir().join(format!(
            "nanocodex-erdos-verifier-{}-{}",
            process::id(),
            epoch_seconds()?
        ));
        fs::create_dir_all(&directory).wrap_err("failed to create verifier test directory")?;
        fs::write(directory.join("candidate.md"), "candidate")?;
        let candidate = CandidateStore::new(directory.clone()).freeze(FreezeCandidateInput {
            label: "verified test".to_owned(),
            claim: "test claim".to_owned(),
            artifacts: vec!["candidate.md".to_owned()],
            dependencies: Vec::new(),
        })?;
        let verifier_path = directory.join("verifier.sh");
        fs::write(&verifier_path, "#!/bin/sh\ntest -f \"$1\"\n")?;
        fs::set_permissions(&verifier_path, fs::Permissions::from_mode(0o700))?;
        let verifier = CandidateVerifier::load(&verifier_path, 5, directory.clone())?;

        let result = verifier.verify(&candidate.candidate_id).await?;
        assert!(result.accepted);
        assert_eq!(result.exit_code, Some(0));
        assert_eq!(
            verifier.accepted_candidate()?,
            Some(candidate.candidate_id.clone())
        );
        assert!(verifier.result_summary()?.contains("accepted=true"));

        fs::remove_dir_all(directory).wrap_err("failed to remove verifier test directory")?;
        Ok(())
    }
}
