use std::{
    collections::HashSet,
    fmt::Write as FmtWrite,
    fs::{self, OpenOptions},
    io::Write,
    path::{Path, PathBuf},
    process::{self, Stdio},
    sync::{
        Arc, Mutex,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant, SystemTime, UNIX_EPOCH},
};

use clap::Parser;
use eyre::{Result, WrapErr, eyre};
use futures::{StreamExt, stream::FuturesUnordered};
use nanocodex::{
    AgentEvent, AgentEventKind, AgentEvents, Nanocodex, ReasoningMode, Thinking, Tool, ToolContext,
    ToolDefinition, ToolExecution, ToolInput, ToolResult, Tools, TurnResult, async_trait,
};
use serde::{Deserialize, Serialize};
use serde_json::{Value, json};
use sha2::{Digest, Sha256};
use tokio::{process::Command, sync::Semaphore};

const LOOP_MANAGER: &str = include_str!("../../prompts/research-loop-manager.md");
const COMPACT_TEXT_LIMIT: usize = 16 * 1024;

#[derive(Parser)]
#[command(about = "Run a persistent progress-aware Nanocodex research loop")]
struct Args {
    /// Optional dotenv file used only to load credentials.
    #[arg(long)]
    env_file: Option<PathBuf>,

    /// Research workspace containing runs/, prompts, sources, and verifiers.
    #[arg(long, default_value = ".")]
    workspace: PathBuf,

    /// Campaign executable launched by the outer Code Mode manager.
    #[arg(long, default_value = "target/release/nanocodex-erdos")]
    campaign_binary: PathBuf,

    /// Pre-approved verifier passed to every child campaign.
    #[arg(long)]
    verifier: Option<PathBuf>,

    /// Optional shell command which independently recognizes completion.
    #[arg(long)]
    success_command: Option<String>,

    /// Immutable objective files. Their contents are frozen into the loop.
    #[arg(long = "objective", required = true)]
    objectives: Vec<PathBuf>,

    /// Maximum outer manager turns.
    #[arg(long, default_value_t = 12)]
    max_rounds: u32,

    /// Maximum child campaigns launched by the complete loop.
    #[arg(long, default_value_t = 48)]
    max_campaigns: u64,

    /// Maximum campaigns accepted by one Code Mode batch.
    #[arg(long, default_value_t = 8)]
    max_batch_size: usize,

    /// Maximum child campaign processes executing concurrently.
    #[arg(long, default_value_t = 4)]
    max_parallel_campaigns: usize,

    /// Total outer loop wall-time budget.
    #[arg(long, default_value_t = 604_800)]
    loop_timeout_seconds: u64,

    /// Child campaign wall-time budget.
    #[arg(long, default_value_t = 43_200)]
    campaign_timeout_seconds: u64,

    /// Worker calls available to each child campaign.
    #[arg(long, default_value_t = 80)]
    campaign_worker_calls: u64,

    /// Retained workers available to each child campaign.
    #[arg(long, default_value_t = 20)]
    campaign_retained_workers: u64,

    /// Concurrent workers available inside each child campaign.
    #[arg(long, default_value_t = 12)]
    campaign_concurrent_workers: usize,

    /// Exact jobs available inside each child campaign.
    #[arg(long, default_value_t = 12)]
    campaign_exact_jobs: u64,

    /// Concurrent exact jobs available inside each child campaign.
    #[arg(long, default_value_t = 4)]
    campaign_concurrent_exact_jobs: usize,

    /// Lead turns available inside each child campaign.
    #[arg(long, default_value_t = 8)]
    campaign_lead_turns: u32,

    /// Request fast service for manager and child model calls.
    #[arg(long, default_value_t = true)]
    fast_mode: bool,

    /// Stable provider-side prompt-cache identity.
    #[arg(long, default_value = "nanocodex-erdos-outer-loop-v1")]
    prompt_cache_key: String,
}

#[derive(Clone)]
struct CampaignConfig {
    workspace: PathBuf,
    campaign_binary: PathBuf,
    verifier: Option<PathBuf>,
    loop_directory: PathBuf,
    fast_mode: bool,
    max_batch_size: usize,
    campaign_timeout: Duration,
    worker_calls: u64,
    retained_workers: u64,
    concurrent_workers: usize,
    exact_jobs: u64,
    concurrent_exact_jobs: usize,
    lead_turns: u32,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct CampaignBatchInput {
    campaigns: Vec<CampaignRequest>,
}

#[derive(Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
struct CampaignRequest {
    label: String,
    representation: String,
    dead_end_escaped: String,
    hypothesis: String,
    decision_rule: String,
    problem: String,
}

#[derive(Serialize)]
struct CampaignOutcome {
    label: String,
    status: &'static str,
    representation: String,
    dead_end_escaped: String,
    hypothesis: String,
    decision_rule: String,
    process_id: Option<u32>,
    exit_code: Option<i32>,
    run_id: Option<String>,
    run_directory: Option<String>,
    compact_summary: String,
    error: Option<String>,
}

#[derive(Serialize)]
struct CampaignBatchOutput {
    outcomes: Vec<CampaignOutcome>,
    pending_in_batch: usize,
    launched_total: u64,
    launched_remaining: u64,
}

#[derive(Clone)]
struct RunCampaignBatch {
    config: Arc<CampaignConfig>,
    launched: Arc<AtomicU64>,
    route_fingerprints: Arc<Mutex<HashSet<String>>>,
    outcomes: Arc<Mutex<Vec<CampaignOutcome>>>,
    semaphore: Arc<Semaphore>,
    journal: Arc<Mutex<std::fs::File>>,
    sequence: Arc<AtomicU64>,
    max_campaigns: u64,
}

impl RunCampaignBatch {
    fn reserve(&self, requested: u64) -> Result<()> {
        self.launched
            .fetch_update(Ordering::SeqCst, Ordering::SeqCst, |current| {
                current
                    .checked_add(requested)
                    .filter(|next| *next <= self.max_campaigns)
            })
            .map(|_| ())
            .map_err(|current| {
                eyre!(
                    "campaign budget exceeded: used {current}, requested {requested}, limit {}",
                    self.max_campaigns
                )
            })
    }

    fn accept_novel_routes(&self, requests: &[CampaignRequest]) -> Result<()> {
        let requested_fingerprints = requests
            .iter()
            .map(|request| {
                sha256(
                    format!(
                        "{}\n{}\n{}\n{}",
                        normalize(&request.representation),
                        normalize(&request.dead_end_escaped),
                        normalize(&request.hypothesis),
                        normalize(&request.problem)
                    )
                    .as_bytes(),
                )
            })
            .collect::<Vec<_>>();
        let mut route_fingerprints = self
            .route_fingerprints
            .lock()
            .map_err(|_| eyre!("route-fingerprint lock poisoned"))?;
        let mut batch = HashSet::new();
        for (request, fingerprint) in requests.iter().zip(&requested_fingerprints) {
            if route_fingerprints.contains(fingerprint) || !batch.insert(fingerprint.clone()) {
                return Err(eyre!(
                    "duplicate route rejected for `{}`; record a material representation change",
                    request.label
                ));
            }
        }
        route_fingerprints.extend(batch);
        Ok(())
    }

    async fn run_one(&self, request: CampaignRequest) -> CampaignOutcome {
        let permit = match self.semaphore.clone().acquire_owned().await {
            Ok(permit) => permit,
            Err(error) => {
                return failed_outcome(
                    request,
                    None,
                    format!("campaign semaphore closed: {error}"),
                );
            }
        };
        let _permit = permit;
        match self.run_one_inner(request.clone()).await {
            Ok(outcome) => outcome,
            Err(error) => failed_outcome(request, None, format!("{error:#}")),
        }
    }

    #[allow(clippy::too_many_lines)]
    async fn run_one_inner(&self, request: CampaignRequest) -> Result<CampaignOutcome> {
        let sequence = self.sequence.fetch_add(1, Ordering::SeqCst) + 1;
        let slug = slug(&request.label);
        let campaign_directory = self
            .config
            .loop_directory
            .join("campaigns")
            .join(format!("{sequence:04}-{slug}"));
        fs::create_dir_all(&campaign_directory)
            .wrap_err("failed to create loop campaign directory")?;
        let prompt_path = campaign_directory.join("problem.md");
        fs::write(&prompt_path, &request.problem).wrap_err("failed to freeze campaign prompt")?;
        fs::write(
            campaign_directory.join("route.json"),
            serde_json::to_vec_pretty(&request)?,
        )
        .wrap_err("failed to freeze route metadata")?;

        let stdout_path = campaign_directory.join("stdout.log");
        let stderr_path = campaign_directory.join("stderr.log");
        let stdout =
            std::fs::File::create(&stdout_path).wrap_err("failed to create child stdout log")?;
        let stderr =
            std::fs::File::create(&stderr_path).wrap_err("failed to create child stderr log")?;

        let mut command = Command::new(&self.config.campaign_binary);
        command
            .current_dir(&self.config.workspace)
            .arg("--workspace")
            .arg(&self.config.workspace)
            .arg("--prompt-cache-key")
            .arg("nanocodex-erdos-loop-child-v1")
            .arg("--web-policy")
            .arg("full-research")
            .arg("--max-worker-calls")
            .arg(self.config.worker_calls.to_string())
            .arg("--max-retained-workers")
            .arg(self.config.retained_workers.to_string())
            .arg("--max-concurrent-workers")
            .arg(self.config.concurrent_workers.to_string())
            .arg("--worker-timeout-seconds")
            .arg("0")
            .arg("--worker-closure-after-seconds")
            .arg("3600")
            .arg("--max-batch-size")
            .arg(self.config.concurrent_workers.to_string())
            .arg("--max-exact-jobs")
            .arg(self.config.exact_jobs.to_string())
            .arg("--max-concurrent-exact-jobs")
            .arg(self.config.concurrent_exact_jobs.to_string())
            .arg("--max-exact-jobs-per-worker")
            .arg("1")
            .arg("--max-exact-artifact-bytes")
            .arg((1024_u64 * 1024 * 1024).to_string())
            .arg("--verifier-timeout-seconds")
            .arg("1200")
            .arg("--closure-after-seconds")
            .arg("10800")
            .arg("--max-lead-turns")
            .arg(self.config.lead_turns.to_string())
            .arg("--campaign-timeout-seconds")
            .arg(self.config.campaign_timeout.as_secs().to_string());
        if self.config.fast_mode {
            command.arg("--fast-mode");
        }
        if let Some(verifier) = &self.config.verifier {
            command.arg("--verifier").arg(verifier);
        }
        command
            .arg(&request.problem)
            .stdout(Stdio::from(stdout))
            .stderr(Stdio::from(stderr))
            .kill_on_drop(true);

        let mut child = command.spawn().wrap_err("failed to spawn child campaign")?;
        let process_id = child.id();
        let host_timeout = self
            .config
            .campaign_timeout
            .saturating_add(Duration::from_secs(300));
        let deadline = tokio::time::Instant::now() + host_timeout;
        let mut candidate_poll = tokio::time::interval(Duration::from_secs(15));
        candidate_poll.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Skip);
        let mut early_run_id = None;
        let (exit_code, process_succeeded) = loop {
            tokio::select! {
                status = child.wait() => {
                    let status = status.wrap_err("failed to wait for child campaign")?;
                    break (status.code(), status.success());
                }
                () = tokio::time::sleep_until(deadline) => {
                    let _ = child.kill().await;
                    let _ = child.wait().await;
                    let run_id =
                        process_id.and_then(|pid| find_run_id(&self.config.workspace, pid));
                    return Ok(CampaignOutcome {
                        label: request.label,
                        status: "timed-out",
                        representation: request.representation,
                        dead_end_escaped: request.dead_end_escaped,
                        hypothesis: request.hypothesis,
                        decision_rule: request.decision_rule,
                        process_id,
                        exit_code: None,
                        run_directory: run_id
                            .as_ref()
                            .map(|id| self.config.workspace.join("runs").join(id))
                            .map(|path| path.to_string_lossy().into_owned()),
                        run_id,
                        compact_summary:
                            "child campaign exceeded its host wall-time budget".to_owned(),
                        error: None,
                    });
                }
                _ = candidate_poll.tick() => {
                    let Some(run_id) =
                        process_id.and_then(|pid| find_run_id(&self.config.workspace, pid))
                    else {
                        continue;
                    };
                    let run_directory = self.config.workspace.join("runs").join(&run_id);
                    let status = classify_campaign_run(&run_directory);
                    if matches!(status, "verified" | "strong-candidate") {
                        early_run_id = Some(run_id);
                        tokio::spawn(async move {
                            let _ = child.wait().await;
                        });
                        break (None, true);
                    }
                }
            }
        };
        let run_id = early_run_id
            .or_else(|| process_id.and_then(|pid| find_run_id(&self.config.workspace, pid)));
        let run_directory = run_id
            .as_ref()
            .map(|id| self.config.workspace.join("runs").join(id));
        let compact_summary = match &run_directory {
            Some(directory) => compact_run_summary(directory)?,
            None => compact_file_tail(&stdout_path, COMPACT_TEXT_LIMIT)?,
        };
        let outcome_status = if process_succeeded {
            run_directory
                .as_deref()
                .map_or("completed", classify_campaign_run)
        } else {
            "failed"
        };
        Ok(CampaignOutcome {
            label: request.label,
            status: outcome_status,
            representation: request.representation,
            dead_end_escaped: request.dead_end_escaped,
            hypothesis: request.hypothesis,
            decision_rule: request.decision_rule,
            process_id,
            exit_code,
            run_id,
            run_directory: run_directory.map(|path| path.to_string_lossy().into_owned()),
            compact_summary,
            error: (!process_succeeded).then(|| "child campaign exited unsuccessfully".to_owned()),
        })
    }

    fn append_outcomes(&self, outcomes: &[CampaignOutcome]) -> Result<()> {
        let mut journal = self
            .journal
            .lock()
            .map_err(|_| eyre!("loop journal lock poisoned"))?;
        for outcome in outcomes {
            serde_json::to_writer(&mut *journal, outcome)
                .wrap_err("failed to encode campaign outcome")?;
            writeln!(journal).wrap_err("failed to append campaign outcome")?;
        }
        journal
            .flush()
            .wrap_err("failed to flush campaign journal")?;
        Ok(())
    }

    fn record_outcome(&self, outcome: &CampaignOutcome) -> Result<()> {
        self.append_outcomes(std::slice::from_ref(outcome))?;
        self.outcomes
            .lock()
            .map_err(|_| eyre!("campaign-outcome lock poisoned"))?
            .push(clone_outcome(outcome));
        Ok(())
    }

    async fn run_and_record(&self, request: CampaignRequest) -> Result<CampaignOutcome> {
        let outcome = self.run_one(request).await;
        self.record_outcome(&outcome)?;
        Ok(outcome)
    }
}

#[async_trait]
impl Tool for RunCampaignBatch {
    fn name(&self) -> &'static str {
        "run_campaign_batch"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "Launch and await a bounded batch of independent research campaigns. The host rejects exact duplicate representations, owns concurrency and deadlines, freezes every prompt, and returns compact terminal artifacts. Long Pro calls have no event-idle timeout.",
            json!({
                "type": "object",
                "properties": {
                    "campaigns": {
                        "type": "array",
                        "minItems": 1,
                        "maxItems": self.config.max_batch_size,
                        "items": {
                            "type": "object",
                            "properties": {
                                "label": { "type": "string" },
                                "representation": { "type": "string", "description": "Concrete mathematical representation, not a role name." },
                                "dead_end_escaped": { "type": "string", "description": "Specific exhausted route and the material distinction." },
                                "hypothesis": { "type": "string", "description": "One quantified falsifiable claim." },
                                "decision_rule": { "type": "string", "description": "How proof, falsification, or failure changes the portfolio." },
                                "problem": { "type": "string", "description": "Complete immutable campaign assignment with artifact and verification requirements." }
                            },
                            "required": ["label", "representation", "dead_end_escaped", "hypothesis", "decision_rule", "problem"],
                            "additionalProperties": false
                        }
                    }
                },
                "required": ["campaigns"],
                "additionalProperties": false
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let input: CampaignBatchInput = input.decode_json()?;
        if input.campaigns.is_empty() || input.campaigns.len() > self.config.max_batch_size {
            return Err(eyre!(
                "campaign batch size must be between 1 and {}",
                self.config.max_batch_size
            )
            .into());
        }
        self.accept_novel_routes(&input.campaigns)?;
        self.reserve(input.campaigns.len() as u64)?;
        let batch_size = input.campaigns.len();
        let mut tasks = input
            .campaigns
            .into_iter()
            .map(|request| {
                let runner = self.clone();
                tokio::spawn(async move { runner.run_and_record(request).await })
            })
            .collect::<FuturesUnordered<_>>();
        let mut outcomes = Vec::with_capacity(batch_size);
        while let Some(joined) = tasks.next().await {
            let outcome = joined
                .wrap_err("campaign task panicked")?
                .wrap_err("failed to record campaign outcome")?;
            let requires_attention = outcome_requires_manager_attention(&outcome);
            outcomes.push(outcome);
            if requires_attention {
                break;
            }
        }
        // Dropping a Tokio JoinHandle detaches its task. The remaining campaigns
        // continue under the shared semaphore and record their outcomes directly,
        // while the manager can inspect the noteworthy result immediately.
        let pending_in_batch = batch_size.saturating_sub(outcomes.len());
        let launched_total = self.launched.load(Ordering::SeqCst);
        Ok(ToolExecution::json(&CampaignBatchOutput {
            outcomes,
            pending_in_batch,
            launched_total,
            launched_remaining: self.max_campaigns.saturating_sub(launched_total),
        }))
    }
}

fn clone_outcome(outcome: &CampaignOutcome) -> CampaignOutcome {
    CampaignOutcome {
        label: outcome.label.clone(),
        status: outcome.status,
        representation: outcome.representation.clone(),
        dead_end_escaped: outcome.dead_end_escaped.clone(),
        hypothesis: outcome.hypothesis.clone(),
        decision_rule: outcome.decision_rule.clone(),
        process_id: outcome.process_id,
        exit_code: outcome.exit_code,
        run_id: outcome.run_id.clone(),
        run_directory: outcome.run_directory.clone(),
        compact_summary: outcome.compact_summary.clone(),
        error: outcome.error.clone(),
    }
}

fn failed_outcome(
    request: CampaignRequest,
    process_id: Option<u32>,
    error: String,
) -> CampaignOutcome {
    CampaignOutcome {
        label: request.label,
        status: "failed",
        representation: request.representation,
        dead_end_escaped: request.dead_end_escaped,
        hypothesis: request.hypothesis,
        decision_rule: request.decision_rule,
        process_id,
        exit_code: None,
        run_id: None,
        run_directory: None,
        compact_summary: String::new(),
        error: Some(error),
    }
}

fn classify_campaign_run(run_directory: &Path) -> &'static str {
    if verifier_accepted(run_directory) {
        return "verified";
    }
    let mut status_text = String::new();
    for path in [
        Some(run_directory.join("report.md")),
        Some(run_directory.join("lead-final.md")),
        latest_lead_turn(run_directory),
    ]
    .into_iter()
    .flatten()
    {
        if let Ok(contents) = fs::read_to_string(path) {
            status_text.push_str(&contents);
            status_text.push('\n');
        }
    }
    classify_unverified_status(&status_text)
}

fn classify_unverified_status(status_text: &str) -> &'static str {
    let status = status_text.to_lowercase();
    if status.contains("strong-candidate")
        || status.contains("strong candidate")
        || status.contains("**verified**")
        || status.contains("status: verified")
    {
        "strong-candidate"
    } else if status.contains("**blocked")
        || status.contains("status: blocked")
        || status.contains("target unresolved")
    {
        "blocked"
    } else if status.contains("**partial")
        || status.contains("status: partial")
        || status.contains("provisional status: **partial")
    {
        "partial"
    } else {
        "completed"
    }
}

fn outcome_requires_manager_attention(outcome: &CampaignOutcome) -> bool {
    matches!(outcome.status, "verified" | "strong-candidate")
}

#[derive(Default, Serialize)]
struct PortfolioMetrics {
    launched_campaigns: usize,
    active_campaigns: usize,
    completed_campaigns: usize,
    frozen_candidates: usize,
    accepted_candidates: usize,
    evidence_records: usize,
    worker_reports: usize,
}

impl PortfolioMetrics {
    fn summary(&self) -> String {
        format!(
            "launched={}, active={}, completed={}, frozen_candidates={}, accepted_candidates={}, evidence_records={}, worker_reports={}",
            self.launched_campaigns,
            self.active_campaigns,
            self.completed_campaigns,
            self.frozen_candidates,
            self.accepted_candidates,
            self.evidence_records,
            self.worker_reports
        )
    }
}

#[derive(Serialize)]
struct LoopManifest<'a> {
    protocol_version: u32,
    loop_id: &'a str,
    created_at_epoch_seconds: u64,
    workspace: String,
    campaign_binary: String,
    objective_sha256: String,
    max_rounds: u32,
    max_campaigns: u64,
    max_parallel_campaigns: usize,
    fast_mode: bool,
}

#[derive(Serialize)]
struct RecordedEvent<'a> {
    agent: &'a str,
    event: &'a AgentEvent,
}

#[allow(clippy::too_many_lines)]
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
    let campaign_binary = resolve_from(&workspace, &args.campaign_binary)
        .canonicalize()
        .wrap_err("failed to resolve campaign executable")?;
    let verifier = args
        .verifier
        .as_ref()
        .map(|path| resolve_from(&workspace, path))
        .map(|path| path.canonicalize())
        .transpose()
        .wrap_err("failed to resolve verifier")?;
    let objective = load_objectives(&workspace, &args.objectives)?;
    let loop_id = format!("loop-{}-{}", epoch_seconds()?, process::id());
    let loop_directory = workspace.join("loops").join(&loop_id);
    fs::create_dir_all(loop_directory.join("campaigns"))
        .wrap_err("failed to create loop directory")?;
    fs::write(loop_directory.join("objective.md"), &objective)
        .wrap_err("failed to freeze loop objective")?;
    write_json(
        &loop_directory.join("loop.json"),
        &LoopManifest {
            protocol_version: 1,
            loop_id: &loop_id,
            created_at_epoch_seconds: epoch_seconds()?,
            workspace: workspace.to_string_lossy().into_owned(),
            campaign_binary: campaign_binary.to_string_lossy().into_owned(),
            objective_sha256: sha256(objective.as_bytes()),
            max_rounds: args.max_rounds,
            max_campaigns: args.max_campaigns,
            max_parallel_campaigns: args.max_parallel_campaigns,
            fast_mode: args.fast_mode,
        },
    )?;

    let outcomes = Arc::new(Mutex::new(Vec::new()));
    let journal = Arc::new(Mutex::new(
        OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(loop_directory.join("campaigns.jsonl"))
            .wrap_err("failed to create campaign journal")?,
    ));
    let run_campaigns = RunCampaignBatch {
        config: Arc::new(CampaignConfig {
            workspace: workspace.clone(),
            campaign_binary,
            verifier,
            loop_directory: loop_directory.clone(),
            fast_mode: args.fast_mode,
            max_batch_size: args.max_batch_size,
            campaign_timeout: Duration::from_secs(args.campaign_timeout_seconds),
            worker_calls: args.campaign_worker_calls,
            retained_workers: args.campaign_retained_workers,
            concurrent_workers: args.campaign_concurrent_workers,
            exact_jobs: args.campaign_exact_jobs,
            concurrent_exact_jobs: args.campaign_concurrent_exact_jobs,
            lead_turns: args.campaign_lead_turns,
        }),
        launched: Arc::new(AtomicU64::new(0)),
        route_fingerprints: Arc::new(Mutex::new(HashSet::new())),
        outcomes: outcomes.clone(),
        semaphore: Arc::new(Semaphore::new(args.max_parallel_campaigns)),
        journal,
        sequence: Arc::new(AtomicU64::new(0)),
        max_campaigns: args.max_campaigns,
    };

    let tool = run_campaigns.clone();
    let tool_workspace = workspace.clone();
    let (manager, events) = Nanocodex::builder(api_key)
        .session_id(loop_id.clone())
        .prompt_cache_key(args.prompt_cache_key.clone())
        .shared_prompt_cache()
        .instructions(LOOP_MANAGER)
        .reasoning_mode(ReasoningMode::Pro)
        .thinking(Thinking::Max)
        .fast_mode(args.fast_mode)
        .tools_factory(move |_| {
            Tools::builder()
                .working_directory(tool_workspace.to_string_lossy().into_owned())
                .tool(tool.clone())
                .build()
        })
        .workspace(&workspace)
        .build()
        .wrap_err("failed to build research-loop manager")?;
    let event_task = record_events(events, loop_directory.join("telemetry.jsonl"));

    let started = Instant::now();
    let loop_timeout = Duration::from_secs(args.loop_timeout_seconds);
    let mut previous_metrics = PortfolioMetrics::default();
    let mut final_reason = "outer round budget exhausted".to_owned();
    let mut final_message = String::new();

    for round in 1..=args.max_rounds {
        if started.elapsed() >= loop_timeout {
            "outer loop wall-time budget exhausted".clone_into(&mut final_reason);
            break;
        }
        let before = outcomes
            .lock()
            .map_err(|_| eyre!("campaign-outcome lock poisoned"))?
            .len();
        let task = manager_task(
            round,
            &loop_directory,
            &objective,
            &previous_metrics,
            run_campaigns.launched.load(Ordering::SeqCst),
            args.max_campaigns,
        );
        let turn = manager.prompt(task).await?;
        let control = turn.control();
        let remaining = loop_timeout.saturating_sub(started.elapsed());
        let result = turn.result();
        tokio::pin!(result);
        let deadline = tokio::time::sleep(remaining);
        tokio::pin!(deadline);
        let completed: TurnResult = tokio::select! {
            completed = &mut result => completed?,
            () = &mut deadline => {
                let _ = control.cancel().await;
                let _ = result.await;
                "outer loop wall-time exhausted during manager turn".clone_into(&mut final_reason);
                break;
            }
        };
        final_message.clone_from(&completed.final_message);
        fs::write(
            loop_directory.join(format!("manager-round-{round}.md")),
            &completed.final_message,
        )
        .wrap_err("failed to retain manager round")?;
        fs::write(
            loop_directory.join(format!("manager-round-{round}.snapshot.json")),
            serde_json::to_vec_pretty(&completed.snapshot())?,
        )
        .wrap_err("failed to retain manager session snapshot")?;

        let (metrics, launched_this_round) = {
            let current_outcomes = outcomes
                .lock()
                .map_err(|_| eyre!("campaign-outcome lock poisoned"))?;
            let launched_campaigns = usize::try_from(run_campaigns.launched.load(Ordering::SeqCst))
                .wrap_err("launched campaign count does not fit usize")?;
            (
                portfolio_metrics(&current_outcomes, launched_campaigns)?,
                current_outcomes.len().saturating_sub(before),
            )
        };
        write_json(
            &loop_directory.join(format!("metrics-round-{round}.json")),
            &metrics,
        )?;

        if host_success(&workspace, &outcomes, args.success_command.as_deref()).await? {
            "host success gate accepted the research result".clone_into(&mut final_reason);
            previous_metrics = metrics;
            break;
        }
        if launched_this_round == 0 {
            fs::write(
                loop_directory.join(format!("host-failure-round-{round}.md")),
                "The manager launched no campaign and no success gate passed. This round is a host-classified failure; the next round must launch a materially different route.\n",
            )
            .wrap_err("failed to record empty-round failure")?;
        }
        previous_metrics = metrics;
    }

    write_json(
        &loop_directory.join("loop-final.json"),
        &json!({
            "reason": final_reason,
            "elapsed_seconds": started.elapsed().as_secs(),
            "metrics": previous_metrics,
            "final_message": final_message,
        }),
    )?;
    println!("loop directory: {}", loop_directory.display());
    println!("stop reason: {final_reason}");
    drop(manager);
    event_task
        .await
        .wrap_err("manager event recorder task failed")??;
    Ok(())
}

fn manager_task(
    round: u32,
    loop_directory: &Path,
    objective: &str,
    previous: &PortfolioMetrics,
    launched: u64,
    max_campaigns: u64,
) -> String {
    let initial = if round == 1 {
        format!(
            "This is the first round. Read the existing runs and dead-end maps before launching anything.\n\n{objective}"
        )
    } else {
        "This is a continuation after a host-declared failure: no authoritative success gate accepted the previous round. Inspect the newly retained compact artifacts, identify the first exact missing lemma, and change representation if the prior route did not close it.".to_owned()
    };
    format!(
        "OUTER RESEARCH LOOP ROUND {round}. The immutable objective is at `{}`. Telemetry and session snapshots are operator-only and must never be read. Previous host metrics: {}. Campaign budget: {launched}/{max_campaigns} launched. Use Code Mode to inspect compact artifacts and run focused builds/verifiers. Then call `run_campaign_batch` with at least one materially new route unless the host gate is already demonstrably satisfied. Do not return a final answer merely describing what should be tried; launch the work and await it in this turn.\n\n{initial}",
        loop_directory.join("objective.md").display(),
        previous.summary(),
    )
}

async fn host_success(
    workspace: &Path,
    outcomes: &Arc<Mutex<Vec<CampaignOutcome>>>,
    success_command: Option<&str>,
) -> Result<bool> {
    let accepted = {
        let outcomes = outcomes
            .lock()
            .map_err(|_| eyre!("campaign-outcome lock poisoned"))?;
        outcomes.iter().any(|outcome| {
            outcome
                .run_directory
                .as_deref()
                .is_some_and(|directory| verifier_accepted(Path::new(directory)))
        })
    };
    if accepted {
        return Ok(true);
    }
    let Some(command) = success_command else {
        return Ok(false);
    };
    let status = Command::new("bash")
        .arg("-lc")
        .arg(command)
        .current_dir(workspace)
        .status()
        .await
        .wrap_err("failed to execute success command")?;
    Ok(status.success())
}

fn verifier_accepted(run_directory: &Path) -> bool {
    fs::read(run_directory.join("campaign-final.json"))
        .ok()
        .and_then(|bytes| serde_json::from_slice::<Value>(&bytes).ok())
        .and_then(|value| value.get("verifier_accepted_candidate").cloned())
        .is_some_and(|candidate| !candidate.is_null())
}

fn portfolio_metrics(outcomes: &[CampaignOutcome], launched: usize) -> Result<PortfolioMetrics> {
    let mut metrics = PortfolioMetrics {
        launched_campaigns: launched,
        active_campaigns: launched.saturating_sub(outcomes.len()),
        completed_campaigns: outcomes
            .iter()
            .filter(|outcome| {
                matches!(
                    outcome.status,
                    "completed" | "verified" | "strong-candidate" | "partial" | "blocked"
                )
            })
            .count(),
        ..PortfolioMetrics::default()
    };
    for run_directory in outcomes
        .iter()
        .filter_map(|outcome| outcome.run_directory.as_deref())
        .map(Path::new)
    {
        metrics.accepted_candidates += usize::from(verifier_accepted(run_directory));
        metrics.frozen_candidates += count_files(&run_directory.join("frozen"), Some("json"))?;
        metrics.worker_reports += count_files(&run_directory.join("worker-reports"), Some("md"))?;
        metrics.evidence_records += line_count(&run_directory.join("ledger.jsonl"))?;
    }
    Ok(metrics)
}

fn compact_run_summary(run_directory: &Path) -> Result<String> {
    let mut parts = Vec::new();
    if let Ok(final_state) = compact_file_tail(
        &run_directory.join("campaign-final.json"),
        COMPACT_TEXT_LIMIT / 4,
    ) {
        parts.push(format!("campaign-final.json:\n{final_state}"));
    }
    if let Ok(lead) =
        compact_file_tail(&run_directory.join("lead-final.md"), COMPACT_TEXT_LIMIT / 2)
    {
        parts.push(format!("lead-final.md:\n{lead}"));
    }
    if let Ok(report) = compact_file_tail(&run_directory.join("report.md"), COMPACT_TEXT_LIMIT / 2)
    {
        parts.push(format!("report.md:\n{report}"));
    }
    if let Some(path) = latest_lead_turn(run_directory)
        && let Ok(lead) = compact_file_tail(&path, COMPACT_TEXT_LIMIT / 4)
    {
        let name = path
            .file_name()
            .and_then(|name| name.to_str())
            .unwrap_or("latest lead turn");
        parts.push(format!("{name}:\n{lead}"));
    }
    if let Ok(ledger) =
        compact_file_tail(&run_directory.join("ledger.jsonl"), COMPACT_TEXT_LIMIT / 4)
    {
        parts.push(format!("ledger tail:\n{ledger}"));
    }
    let reports = count_files(&run_directory.join("worker-reports"), Some("md"))?;
    let candidates = count_files(&run_directory.join("frozen"), Some("json"))?;
    parts.push(format!(
        "worker_reports={reports}, frozen_candidate_manifests={candidates}"
    ));
    Ok(compact(&parts.join("\n\n"), COMPACT_TEXT_LIMIT))
}

fn latest_lead_turn(run_directory: &Path) -> Option<PathBuf> {
    fs::read_dir(run_directory)
        .ok()?
        .filter_map(Result::ok)
        .filter_map(|entry| {
            let name = entry.file_name().into_string().ok()?;
            let turn = name
                .strip_prefix("lead-turn-")?
                .strip_suffix(".md")?
                .parse::<u32>()
                .ok()?;
            Some((turn, entry.path()))
        })
        .max_by_key(|(turn, _)| *turn)
        .map(|(_, path)| path)
}

fn compact_file_tail(path: &Path, limit: usize) -> Result<String> {
    let bytes = fs::read(path).wrap_err_with(|| format!("failed to read {}", path.display()))?;
    let start = bytes.len().saturating_sub(limit);
    Ok(String::from_utf8_lossy(&bytes[start..]).into_owned())
}

fn count_files(directory: &Path, extension: Option<&str>) -> Result<usize> {
    if !directory.is_dir() {
        return Ok(0);
    }
    let mut count = 0;
    for entry in fs::read_dir(directory)
        .wrap_err_with(|| format!("failed to list {}", directory.display()))?
    {
        let entry = entry?;
        if entry.file_type()?.is_file()
            && extension.is_none_or(|extension| {
                entry.path().extension().and_then(|value| value.to_str()) == Some(extension)
            })
        {
            count += 1;
        }
    }
    Ok(count)
}

fn line_count(path: &Path) -> Result<usize> {
    match fs::read_to_string(path) {
        Ok(contents) => Ok(contents.lines().count()),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => Ok(0),
        Err(error) => Err(error).wrap_err_with(|| format!("failed to read {}", path.display())),
    }
}

fn find_run_id(workspace: &Path, process_id: u32) -> Option<String> {
    let suffix = format!("-{process_id}");
    fs::read_dir(workspace.join("runs"))
        .ok()?
        .filter_map(Result::ok)
        .filter_map(|entry| entry.file_name().into_string().ok())
        .find(|name| name.starts_with("math-") && name.ends_with(&suffix))
}

fn load_objectives(workspace: &Path, paths: &[PathBuf]) -> Result<String> {
    let mut objective = String::new();
    for path in paths {
        let path = resolve_from(workspace, path);
        let contents = fs::read_to_string(&path)
            .wrap_err_with(|| format!("failed to read objective {}", path.display()))?;
        write!(
            objective,
            "\n\n--- OBJECTIVE: {} ---\n{contents}",
            path.display()
        )
        .wrap_err("failed to compose objective")?;
    }
    Ok(objective)
}

fn resolve_from(workspace: &Path, path: &Path) -> PathBuf {
    if path.is_absolute() {
        path.to_path_buf()
    } else {
        workspace.join(path)
    }
}

fn validate_args(args: &Args) -> Result<()> {
    if args.max_rounds == 0
        || args.max_campaigns == 0
        || args.max_batch_size == 0
        || args.max_parallel_campaigns == 0
        || args.loop_timeout_seconds == 0
        || args.campaign_timeout_seconds == 0
        || args.campaign_worker_calls == 0
        || args.campaign_retained_workers == 0
        || args.campaign_concurrent_workers == 0
        || args.campaign_exact_jobs == 0
        || args.campaign_concurrent_exact_jobs == 0
        || args.campaign_lead_turns == 0
    {
        return Err(eyre!("all loop and campaign limits must be positive"));
    }
    if args.max_parallel_campaigns > args.max_batch_size {
        return Err(eyre!(
            "--max-parallel-campaigns cannot exceed --max-batch-size"
        ));
    }
    Ok(())
}

fn record_events(mut events: AgentEvents, path: PathBuf) -> tokio::task::JoinHandle<Result<()>> {
    tokio::spawn(async move {
        let mut file = OpenOptions::new()
            .create_new(true)
            .write(true)
            .open(path)
            .wrap_err("failed to create manager telemetry")?;
        while let Some(event) = events.recv().await {
            serde_json::to_writer(
                &mut file,
                &RecordedEvent {
                    agent: "portfolio-manager",
                    event: &event,
                },
            )
            .wrap_err("failed to encode manager event")?;
            writeln!(file).wrap_err("failed to append manager event")?;
            file.flush().wrap_err("failed to flush manager event")?;
            if matches!(
                event.kind,
                AgentEventKind::RunStarted
                    | AgentEventKind::ModelAttemptRetrying
                    | AgentEventKind::RunCompleted
                    | AgentEventKind::RunFailed
            ) {
                eprintln!(
                    "[portfolio-manager] {:?} seq={} request_id={}",
                    event.kind, event.seq, event.request_id
                );
            }
        }
        Ok(())
    })
}

fn write_json(path: &Path, value: &impl Serialize) -> Result<()> {
    let bytes = serde_json::to_vec_pretty(value)?;
    fs::write(path, bytes).wrap_err_with(|| format!("failed to write {}", path.display()))
}

fn normalize(value: &str) -> String {
    value
        .split_whitespace()
        .collect::<Vec<_>>()
        .join(" ")
        .to_lowercase()
}

fn slug(value: &str) -> String {
    let value = value
        .chars()
        .map(|character| {
            if character.is_ascii_alphanumeric() {
                character.to_ascii_lowercase()
            } else {
                '-'
            }
        })
        .collect::<String>();
    value
        .split('-')
        .filter(|part| !part.is_empty())
        .take(8)
        .collect::<Vec<_>>()
        .join("-")
}

fn compact(value: &str, limit: usize) -> String {
    if value.len() <= limit {
        return value.to_owned();
    }
    let mut start = value.len() - limit;
    while !value.is_char_boundary(start) {
        start += 1;
    }
    format!("[earlier content omitted]\n{}", &value[start..])
}

fn sha256(bytes: &[u8]) -> String {
    format!("{:x}", Sha256::digest(bytes))
}

fn epoch_seconds() -> Result<u64> {
    Ok(SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .wrap_err("system clock predates Unix epoch")?
        .as_secs())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn route_normalization_rejects_cosmetic_whitespace() {
        assert_eq!(
            normalize("  Factor   TABLEAU\nbridge "),
            "factor tableau bridge"
        );
    }

    #[test]
    fn compact_retains_utf8_tail() {
        let value = format!("{}proof", "λ".repeat(64));
        let compacted = compact(&value, 17);
        assert!(compacted.ends_with("proof"));
        assert!(compacted.is_char_boundary(compacted.len()));
    }

    #[test]
    fn slug_is_bounded_and_readable() {
        assert_eq!(
            slug("Part (iii): Adelic / product formula!"),
            "part-iii-adelic-product-formula"
        );
    }

    #[test]
    fn unverified_compiled_result_requires_manager_attention() {
        assert_eq!(
            classify_unverified_status(
                "# Report\n\n## Status\n\n**strong-candidate** — Lean exit 0"
            ),
            "strong-candidate"
        );
    }

    #[test]
    fn unresolved_result_does_not_trigger_candidate_handoff() {
        let status = classify_unverified_status(
            "# Report\n\n## Status\n\n**partial** — exact target unresolved",
        );
        assert_eq!(status, "blocked");
        assert!(!outcome_requires_manager_attention(&CampaignOutcome {
            label: String::new(),
            status,
            representation: String::new(),
            dead_end_escaped: String::new(),
            hypothesis: String::new(),
            decision_rule: String::new(),
            process_id: None,
            exit_code: Some(0),
            run_id: None,
            run_directory: None,
            compact_summary: String::new(),
            error: None,
        }));
    }
}
