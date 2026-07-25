# Nanocodex Erdős

A source-backed knowledge base and executable research-manager scaffold for
AI-assisted mathematics. It collects public cases from 22 April through
22 July 2026, reconstructs the prompts and harnesses that produced them, and
turns those lessons into a concrete Nanocodex application design.

The name is broader than Erdős problems. The corpus includes conjecture proofs
and counterexamples, formal theorem proving, exact computational certificates,
optimization records, statistics, quantum optimization, and cases where an AI
system rediscovered a result hidden in the literature.

## Featured result: Erdős 700(ii)

[![Lean proof](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml/badge.svg)](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml)
[![Rust harness](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/rust.yml/badge.svg)](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/rust.yml)

This repository now includes the complete kernel-checked Lean proof that there
are infinitely many composite \(n\) with

\[
\left(\min_{1<k\le n/2}\gcd\left(n,\binom nk\right)\right)^2>n.
\]

- [Lean project, proof overview, and verification](proof/README.md)
- [Human-readable mathematical proof](proof/docs/proof.md)
- [Exact historical/formal statement audit](proof/docs/statement-audit.md)
- [Nanocodex research methodology and attribution](docs/methodology.md)

The proof is presented for independent mathematical and formal review. The
canonical problem page still listed part (ii) as open when the development was
completed; kernel verification is not a substitute for external novelty and
community review.

## Part (i): explicit checked characterization

The repository also proves the exact boundary-antichain characterization

```text
f(n) = n / P(n) ↔ BoundarySafe(n)
```

for every composite `n > 1`, then refines the semantic obstruction into the
finite integer/Boolean system `ExplicitG.G`. The checked compiler theorem

```lean
Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible
```

proves that the raw selector, prefix-product, digit, and borrow constraints
have neither false positives nor false negatives relative to the semantic
factor tableau. `./proof/scripts/verify-part-i.sh` builds the complete chain,
rejects proof placeholders, audits dependencies, and runs finite regression
tests through `n = 1000`.

## Start here

- [Erdős 700(ii) proof](proof/README.md): pinned Lean project and CI verifier.
- [Methodology case study](docs/methodology.md): how the harness selected,
  concentrated on, audited, and formalized this result.
- [Case catalog](cases/README.md): evidence-tiered index of discoveries and claims.
- [Erdős census](cases/erdos-census.md): accepted, partial, and provisional results.
- [Prompt field guide](prompts/README.md): reusable patterns extracted from public prompts.
- [Methods taxonomy](methods/README.md): how the successful systems actually searched.
- [Web and specialized tools](methods/web-search-and-specialized-tools.md): execution-policy and provenance matrix.
- [Verification ladder](methods/verification.md): what different evidence does and does not establish.
- [Nanocodex architecture](architecture/nanocodex-math-agent.md): proposed system built from current library APIs.
- [Tool-native orchestration](harness/tool-native-orchestration.md): typed feedback loops beyond subagents.
- [RLM orchestration lessons](harness/rlm-orchestration-lessons.md): trace-driven scheduling and context-offloading rules.
- [Breakthrough campaign runbook](harness/breakthrough-runbook.md): target selection, verifier-first execution, closure steering, and promotion gates.
- [Live runtime validation](harness/live-runtime-validation.md): retained evidence
  for long silent Pro calls, transport-only retries, and Bash/Code Mode use.
- [Exact-verdict campaign shortlist](campaigns/gym-shortlist.md): five screened targets and hard no-go gates.
- [Experiment protocol](harness/experiment-protocol.md): how to run research without fooling ourselves.
- [Machine-readable catalog](data/cases.jsonl) and [schema](data/case.schema.json).
- [Primary source index](sources/README.md).
- [Roadmap](ROADMAP.md).

## Executable scaffold

The Rust binary is a verifier-first research manager, not a claim that
autonomous mathematics has been solved. It runs GPT-5.6 Pro through Nanocodex,
gives the lead agent Code Mode and standard workspace tools, and exposes
application-owned tools for clean-room workers, contextual forks, retained
follow-ups, immutable candidate freezing, and pre-approved verification.

### Persistent Code Mode research loop

`research-loop` adds an outer portfolio controller around those campaigns. It
keeps one Pro/Max Nanocodex manager session alive across rounds, gives that
manager normal Code Mode workspace tools, and exposes a host-owned
`run_campaign_batch` tool. Every campaign request must name its mathematical
representation, falsifiable hypothesis, dead end escaped, and
outcome-dependent decision rule.

The host rejects exact duplicate route fingerprints and owns campaign
concurrency, total campaign count, wall time, prompt freezing, compact result
collection, and success detection. A model message cannot stop the loop:
completion requires either a verifier-accepted frozen candidate or an explicit
success command.

Child outcomes are journaled as soon as they finish. A verified or
`strong-candidate` report returns control to the manager immediately while
other detached campaigns continue under the shared concurrency bound. The
manager can therefore inspect, promote, and run the host gate without waiting
for the slowest member of a batch. Prose `candidate.json` answers never count
as success without the host gate.

```sh
cargo build --release --bin nanocodex-erdos --bin research-loop
./harness/run-erdos700-loop.sh i
./harness/run-erdos700-loop.sh iii
```

Loop state is retained beneath `loops/loop-*/`; child research remains beneath
`runs/math-*/`. Manager telemetry and session snapshots are operator-only and
are explicitly excluded from model research input.

```sh
cp .env.example .env
# Keep the complete LR closure alive for every multi-hour child process.
nix build .#lr --out-link .nix-math-env
nix develop .#lr --command cargo run --release -- \
  --env-file ../nanocodex/.env \
  --workspace . \
  --web-policy novelty-only \
  --max-worker-calls 64 \
  --max-retained-workers 16 \
  --max-concurrent-workers 8 \
  --max-exact-jobs 64 \
  --max-concurrent-exact-jobs 4 \
  --max-exact-artifact-bytes 4294967296 \
  --max-exact-jobs-per-worker 8 \
  --worker-timeout-seconds 0 \
  --worker-closure-after-seconds 720 \
  --verifier /absolute/path/to/preapproved-checker \
  --closure-after-seconds 14400 \
  --max-lead-turns 4 \
  --campaign-timeout-seconds 21600 \
  "Prove or disprove the supplied conjecture. Produce an auditable evidence package."
```

The important model configuration is:

```rust
Nanocodex::builder(api_key)
    .reasoning_mode(ReasoningMode::Pro)
    .thinking(Thinking::Max)
```

GPT-5.6 Pro is a reasoning mode, not a separate model slug. Nanocodex's Code
Mode lets the lead write adaptive orchestration programs with loops and
conditionals. The host-owned `spawn_math_batch` handles mechanical fan-out,
concurrency, deadlines, cancellation, and result ordering. Independent workers
are fresh capability-minimal Nanocodex sessions; contextual branches use
`AgentHandle::fork` only when inherited state is intentional. The
`record_evidence` tool writes typed JSONL records and `freeze_candidate` creates
content-addressed audit boundaries. Successful worker reports are retained by
the host under `worker-reports/` and returned with `report_path`, so a malformed
model-side batch loop cannot discard them. `--web-policy` supports `disabled`,
`novelty-only`, and `full-research`.

Every completed lead or worker boundary also writes its complete
`TurnResult::snapshot()` beneath the ignored `session-snapshots/` directory in
that run. These files make completed typed history resumable after a process
handoff and contain the full unredacted conversation, reasoning payloads, and
tool data; protect them like the API trace. An unfinished response is not
committed or presented as recoverable.

Long computation uses `run_exact_job`, a typed application-owned tool rather
than an opaque subagent or raw shell session. It invokes `/bin/bash -c` in the
campaign directory, removes the API credential, enforces both a total deadline
and a no-progress watchdog, kills the complete process group on failure, and
retains hashed stdout, stderr, script, and result records. It also enforces a
campaign-wide exact-artifact growth budget (4 GiB by default); crossing it
kills the process group with explicit `artifact-limit` status before a
productive but unbounded materialization fills the filesystem. A search must emit
periodic log checkpoints or update a declared heartbeat file; `no-progress` is
reported as an explicit bounded unknown that the next lead turn must diagnose.
The host detaches accepted exact jobs from the invoking model cell, so a yielded
cell, compaction, or caller cancellation cannot erase the terminal job record;
the owned job still completes or is killed by its declared policy and retains
its result.
The lead and clean workers read prior retained evidence through the bounded, read-only
`inspect_research_artifacts` tool. Those reads do not spend exact-job budget.
The tool hides and rejects every live `events.jsonl`: recorder output is an
operator-only observability stream and must never feed itself through a model
tool result.
Each worker receives a local `--max-exact-jobs-per-worker` quota layered over
the campaign-wide pool, preventing the first concurrency wave from starving
later mathematical routes.
Large finite searches should stream deduplicated summaries, top-K candidates,
and resumable shard checkpoints. Do not persist every raw candidate when the
domain can reach millions of rows merely because SQLite makes that convenient.
For a job to count as resumable, its script must both write and read a
versioned cursor or completed-shard manifest, validate the input hash, and skip
completed work after restart. A timestamp-only heartbeat does not satisfy this
contract.
This watchdog applies to deterministic child processes, where the job controls
its heartbeat. It is deliberately distinct from the disabled Pro transport
idle watchdog: provider-side reasoning silence is not observable progress and
must not trigger a restart.

Build `.#lr` to the persistent `.nix-math-env` output link, then enter
`nix develop .#lr` once around the harness, as in the command above. The output
link is a Nix GC root: it keeps Sage and the complete transitive math closure
alive even if garbage collection runs during a multi-hour campaign. Every Bash
and exact-job process inherits those Sage, Lean, and solver paths. Do not invoke
nested `nix develop` from a live campaign directory: this knowledge base is
currently a path flake, so Nix may snapshot the growing `runs/` tree on every
nested invocation.

Pro requests may legitimately remain silent for more than five minutes while
the provider is reasoning. The adjacent Nanocodex transport therefore disables
the per-event idle watchdog in `ReasoningMode::Pro`; Standard mode retains its
300-second watchdog. The harness's whole-worker deadline also defaults to
disabled (`--worker-timeout-seconds 0`); whole-turn and campaign limits remain
independent operator controls. Set a positive value only when the campaign
deliberately needs a hard worker boundary. Retrying merely because a Pro
response is silent discards uncommitted reasoning and restarts paid model work.

`--worker-closure-after-seconds` is not an idle timeout. It sends one explicit
steer so a productive worker can stop opening searches and return its exact
partial report. With a nonzero whole-worker timeout it must precede that hard
deadline; with `--worker-timeout-seconds 0` it may be used as a synthesis nudge
without later cancellation. The request is never restarted merely for silence.

An optional pre-approved verifier receives frozen-candidate manifests and is
hashed into the campaign provenance. Optional timed closure steering turns the
public “enough partial results” prompt into an evidence-qualified phase change:
finish an unconditional object and pass the gate, or return honestly blocked.

A lead turn that ends without verifier acceptance no longer ends the process.
The host retains the same lead session, injects verifier feedback and remaining
budgets, requires a failure postmortem and a materially different route, and
continues up to `--max-lead-turns` or `--campaign-timeout-seconds`. This is one
campaign and one provenance record, not selective retrying. `campaign-final.json`
records the host stop reason and is authoritative over optimistic model prose.

The Cargo dependency points at the dedicated adjacent `../nanocodex-latest`
worktree. It tracks the current upstream master checkpoint plus the audited Pro
transport patch, and build-time fingerprints bind every campaign manifest to
the exact Nanocodex source used.

### Reproducible mathematics environment

The pinned Nix flake supplies the Rust/Nanocodex build chain plus the practical
proof and computation stack:

```sh
nix build .#lr --out-link .nix-math-env
nix develop .#lr
math-env-report > tool-versions.json
cargo run --bin math-environment-check
cargo test exact_job_can_invoke_the_lr_toolchain -- --ignored
cargo test --all-targets
```

The default shell includes Lean 4 and Lake, Z3, cvc5, HiGHS, GLPK, CBC,
MiniZinc, CaDiCaL, Kissat, FLINT, GAP, PARI/GP, Singular, Maxima, Graphviz,
Gnuplot, and a scientific Python/Jupyter environment. Two larger variants are
available:

```sh
nix develop .#formal  # adds Coq/Rocq, Isabelle, Vampire, E, Yices, Boolector
nix develop .#lr      # SageMath, Normaliz, LattE, exact solvers (+ polymake on Linux)
nix develop .#full    # formal shell plus SageMath
```

The pinned Python environment also exposes `import lrcalc` directly.  Use that
binding for high-throughput LR support and stretch screens; reserve Sage for
independent interpolation/polyhedral checks and the final verifier.  This
avoids realizing or launching a complete Sage process for every small exact
coefficient call.

For installation outside a development shell, use `nix profile install .`,
`.#formal`, or `.#full`. Before a long ephemeral-shell campaign, create a local
GC root with `nix build .#lr --out-link .nix-math-env`; remove that link only
after no retained process needs the closure. The flake never reads or supplies
`OPENAI_API_KEY`. Each campaign should retain `math-env-report` output alongside
its verifier artifacts; the flake lock pins package builds, while the report
records the actual executables selected on that machine.

`math-environment-check` is an end-to-end local smoke of the lead path: an
embedded Code Mode JavaScript cell calls Nanocodex `exec_command` with Bash,
resolves the installed proof/solver CLIs, invokes Lean and Z3, and imports the
Python mathematics stack. It requires no API key or model call. Clean-room
workers deliberately use `Tools::without_defaults()`: they have no raw shell,
but can read retained run evidence through `inspect_research_artifacts` and
invoke the same binaries through the capability-scoped `run_exact_job` broker,
which strips the API key, pins the working directory, supervises the process
group, and retains logs.

Example model-generated orchestration:

```js
const scouts = await tools.spawn_math_batch({
  tasks: ["counterexample", "extremal", "probabilistic", "computational"].map(role => ({
    role,
    task: `Attack the problem independently by the ${role} route. Return checkable lemmas.`
  }))
});

for (const item of scouts.items) {
  if (item.status === "completed") {
    text(item.result.report);
  }
}

// Synthesize a complete artifact, freeze it, and then give only the immutable
// claim and manifest to fresh adversarial auditors.
text(JSON.stringify({succeeded: scouts.succeeded, failed: scouts.failed}));
```

## Repository map

```text
cases/          result cards and the Erdős census
prompts/        prompt patterns, exact public artifacts, and templates
methods/        search strategies, verification, and failure analysis
harness/        experimental protocol and tool contracts
architecture/   Nanocodex application design and state model
data/           normalized JSONL catalog and JSON Schema
sources/        primary-source and audit index
templates/      new-case and run-report templates
src/            compiling Nanocodex research-manager scaffold
runs/           ignored runtime workspaces
proof/          pinned Lean proof of Erdős 700(ii)
docs/           result methodology and attribution
```

## Scope and epistemic policy

“Solved” is reserved for results with meaningful external acceptance. The
catalog records separate fields for mathematical status, AI role, novelty,
formalization, executable certificates, human review, and public prompt
availability. Benchmark solutions and formalizations of known results are
tracked as capabilities, not counted as new discoveries.

This is a best-effort public-source census. Private runs, deleted posts, and
unindexed discussions can make absolute completeness impossible.
