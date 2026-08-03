# Nanocodex research harness

The Rust crate in this repository is the application used to run
evidence-producing AI-mathematics campaigns. Nanocodex supplies the owned agent
session, Responses WebSocket, typed history, Code Mode, and caller-defined tool
interface. This crate owns mathematical research policy.

## What the application owns

- immutable problem and statement packages;
- clean worker portfolios and retained follow-up turns;
- exact-job supervision and artifact budgets;
- typed evidence records;
- content-addressed candidate freezing;
- pre-approved verifier invocation;
- closure steering and failure-aware continuation;
- ignored run storage and compact campaign reports.

These are deliberately application concerns, not Nanocodex core abstractions.

## Compatibility status

The retained application source predates Nanocodex's current `0.3.0` public
API. Against a freshly updated `../nanocodex-latest` at `origin/master`,
`cargo test --all-targets` currently fails at the tool/event/builder API
boundary. The mathematical proof package does not depend on the Rust harness.

Before launching another campaign, migrate this application to the current
Nanocodex API and restore the Rust CI gate. Do not paper over the mismatch by
building against the unrelated working tree in `../nanocodex`.

## Entry points

```sh
cargo build --release --bin nanocodex-erdos --bin research-loop

# Persistent adaptive loops
./harness/run-erdos700-loop.sh i
./harness/run-erdos700-loop.sh iii

# One frozen inference-first campaign
./harness/run-inference-campaign.sh campaigns/problems/erdos-700-iii.md
```

These commands describe the intended entry points; the compatibility blocker
above must be closed first.

Use the pinned Nix shell for Lean, solvers, computer algebra, and the Rust
toolchain:

```sh
nix build .#lr --out-link .nix-math-env
nix develop .#lr
math-env-report > tool-versions.json
cargo test --all-targets
```

The output link is a GC root. Retain it while long-running campaigns still
depend on the environment.

## Model and runtime policy

The lead uses GPT-5.6 Pro with maximum thinking. Pro inference may remain
silent for a long time; absence of streamed text is not a reason to restart a
healthy response. Deterministic subprocesses have separate host-owned
deadlines, progress checks, artifact limits, and process-group cleanup.

Code Mode is used for adaptive research decisions. Mechanical scheduling,
concurrency, cancellation, and ordering remain ordinary host code. Exact
computation is a falsifier or verifier for a named claim, not a substitute for
the mathematical argument.

## Read next

- `breakthrough-runbook.md`: campaign design and promotion gates.
- `experiment-protocol.md`: preregistration, evidence, and evaluation.
- `tool-contracts.md`: structured research-state transitions.
- `tool-native-orchestration.md`: when to prefer compilers and solvers over
  stochastic workers.
- `rlm-orchestration-lessons.md`: context offloading and host/model division.
- `live-campaign-lessons.md`: transport, retries, tail control, and environment.
- `live-runtime-validation.md`: retained runtime evidence.
- `docs/methodology.md`: the Part (ii) case study.

## Artifact boundary

Generated work belongs under `runs/` or `loops/` and is not committed by
default. Complete transcripts and snapshots contain unredacted model and tool
data; protect them like API traces. Durable mathematical status is promoted
into `docs/status.md` and `docs/part-iii-exploration-map.md` only after audit.
