# Live campaign lessons

Observed on 23 July 2026 from:

- local stretched-LR run `math-1784815173-35687`;
- remote Ramsey run `math-1784820415-1873164`.

These are harness findings, not mathematical outcome claims. Confirmed
observations are separated from proposed explanations.

## What worked

### The host verifier remains the right trust boundary

Neither a promising 39-vertex Ramsey graph nor extensive negative LR searches
was allowed to become a success claim. No frozen candidate passed a host
verifier. Textual confidence, a worker's use of the word "candidate", and a
near-miss artifact had no effect on the terminal acceptance predicate.

### Host-owned exact jobs are productive

Across the two inspected runs, 47 of 58 terminal exact-job records completed
successfully, seven failed with retained diagnostics, and four were terminated
for no progress. The jobs produced reusable exact artifacts including:

- exhaustive restricted-family no-go certificates;
- complete delayed-`P(3)` checks;
- explicit 39-vertex triangle-free graphs with independence number nine;
- circulant obstruction classes and local-search checkpoints.

The separation between stochastic research turns and deterministic
computation is worth keeping.

### Removing the Pro event-idle timeout was correct

Healthy Pro calls can take many minutes before producing a useful boundary
event. An arbitrary transport event-idle deadline would have killed useful
work. However, "no event timeout" must not mean "no supervision"; the missing
controls are campaign- and route-level, not a reinstated transport timer.

## P0: supervise campaigns as durable jobs

### Evidence

The remote Ramsey process and its tmux server disappeared after roughly 24
minutes. The run contains no `campaign-final.json`, no frozen candidate, and no
terminal campaign record. One exact job has logs without its expected terminal
JSON record. No kernel OOM event was found. The root cause is not established.

Locally, three overlapping stretched-LR campaign processes remained alive,
including superseded runs more than six hours old.

### Required change

Add an application-owned campaign registry and supervisor:

- one durable campaign ID, PID, host, problem fingerprint, deployment
  fingerprint, and lease;
- `status`, `stop`, `resume`, and `recover` operations;
- a default duplicate-problem lock, with explicit `--allow-duplicate`;
- child-exit monitoring outside the campaign process;
- supervisor-authored `crashed` terminal records when the child exits without
  one;
- startup recovery that reconstructs missing exact-job terminal records from
  logs, process state, and atomic metadata;
- graceful termination that cancels process groups and writes the final state.

Do not use tmux as the source of truth. It can remain a convenience wrapper.

## P0: make long tools asynchronous without model polling

### Evidence

Workers submitted a host-owned exact computation, received a yielded cell, and
then spent additional model calls invoking `wait`. This consumes expensive Pro
turns to poll deterministic work and leaves the run vulnerable when a worker
or campaign dies between polls.

### Required change

Replace the polling-shaped interface with:

```text
submit_exact_job(spec) -> job_id
await_exact_jobs(job_ids) -> terminal records
```

The host should await jobs without another model call and schedule a new model
turn only when:

- a job completes or fails;
- a route hits a preregistered milestone;
- verifier feedback becomes available;
- operator steering arrives.

The same event-driven rule should apply to worker batches.

## P0: make route state and evidence host-owned

### Evidence

Both human-readable ledgers remained near their initialization state despite
dozens of exact jobs and several meaningful partial results. The artifacts
exist, but the model did not consistently call `record_evidence`.

Workers also converged repeatedly on circulant/Cayley Ramsey searches despite
being assigned nominally different roles.

### Required change

Every exact job must belong to a route and automatically append a computation
event to the ledger. Introduce first-class operations:

```text
create_route(hypothesis, representation, falsifier, budget)
submit_exact_job(route_id, spec)
record_route_result(route_id, terminal_job)
stop_route(route_id, reason)
branch_route(route_id, new_representation)
```

Before accepting a route, compare its representation and falsifier with active
and exhausted routes. Warn or reject near-duplicates unless the caller records
the material distinction.

## P1: replace fixed silence watchdogs with progress leases

### Evidence

The LR diagonal self-product census completed weights 1 through 10 and wrote
valid checkpoints, then was killed as `no-progress` after 90 seconds inside a
more expensive inner computation. The script was CPU-bound but silent. Similar
jobs were not automatically resumed from their retained checkpoint.

### Required change

- Treat explicit heartbeat updates as progress leases rather than only file
  modification checks.
- Allow the job to declare expected maximum atomic-step duration.
- Observe process CPU consumption and child liveness as diagnostic signals,
  without treating CPU usage alone as proof of useful progress.
- Require a machine-readable resume cursor for jobs above a duration or search
  size threshold.
- Add `resume_exact_job(job_id)` using the frozen script, environment, and
  checkpoint.
- Distinguish `stalled`, `lease-expired`, `timeout`, `failed`, and
  `campaign-crashed`.

## P1: preflight capabilities instead of paying models to probe them

### Evidence

Several exact-job slots were spent on solver and environment inventory. A
Ramsey worker later failed because Sage's `bliss` graph canonicalization module
was absent. Tool-path reporting alone did not reveal this missing capability.

### Required change

Expose a free, structured `environment_capabilities()` result produced before
discovery. It should execute small functional self-tests for declared
capabilities, for example:

- Sage graph construction, canonical labeling, and automorphism groups;
- SAT solver invocation and certificate behavior;
- Normaliz/LattE parsing;
- Lean compilation;
- Yosys/ABC equivalence checking for hardware campaigns.

The scheduler should reject an assignment requiring a capability that the
worker or host does not have.

## P1: fix deployment provenance

### Evidence

The remote campaign recorded:

- `nanocodex_git_commit: "unknown"`;
- an empty-content source hash;
- `nanocodex_build_dirty: true`.

This is insufficient to reproduce or compare a run. The remote also used a
binary predating local artifact-reader and prompt fixes.

### Required change

Embed build provenance in the binary and create a signed or hashed deployment
manifest containing:

- Nanocodex and harness commits;
- dirty patch hashes when applicable;
- Rust and Nix closure fingerprints;
- prompt and verifier hashes;
- target triple and feature set.

The launcher must verify that the intended deployment fingerprint matches the
remote binary before accepting a campaign.

## P1: bound cost and redundancy, not Pro thinking time

### Evidence

Unlimited worker turn time allowed useful long reasoning, but retained workers
could make many sequential Pro calls while revisiting the same representation.
Static role fan-out did not guarantee route diversity.

### Required change

Keep Pro's transport event-idle deadline disabled, but allocate budgets by:

- route;
- model calls and tokens;
- exact-job CPU time;
- verified information gain;
- representation novelty;
- total monetary cost.

Reallocate budget when a route produces a checked lemma, a better score, a
counterexample, or a meaningful failure certificate. Stop funding prose-only
activity or repeated environment discovery.

## P0: make discovery inference-first

### Evidence

The current campaigns over-indexed on locally generated enumerations:

- the local LR run accepted at least 35 exact-job slots in under two hours;
- the remote Ramsey run accepted at least 25 exact-job slots in roughly 24
  minutes;
- many nominally distinct workers converged on script generation and bounded
  family search.

This behavior followed the harness incentive: exact jobs were plentiful,
strongly encouraged, and produced dense legible progress. The system optimized
for the easiest host-measured activity rather than for mathematical insight.

The strongest public AI-mathematics cases use a different balance. Their
decisive contribution is usually a representation, theorem bridge, structural
symmetry, proof architecture, or small designed counterexample. Computation and
formalization then test, extract, or certify that idea. Even the
correlation-gap counterexample follows
`semantic formulation -> targeted optimization -> exact certificate`, not an
undirected exhaustive census.

### Required change

Adopt an inference-first phase policy:

1. **Theory phase:** long reasoning, theorem transfer, structural reductions,
   proof and disproof sketches, and explicit gap maps. No long generic jobs.
2. **Designed-experiment phase:** small pilots attached to a written
   hypothesis, enriched candidate distribution, decision rule, and kill rule.
3. **Closure phase:** proof repair, exact candidate extraction,
   formalization, and authoritative verification.

Require a computation proposal to state:

- what mathematical claim it tests;
- why the searched family is structurally enriched;
- the smallest falsifying pilot;
- what either outcome changes;
- its cost and stopping rule.

Reject “try more random cases,” “raise the bound,” and “enumerate another
generic family” as route changes. For proof-shaped campaigns, reserve most of
the discovery budget for model work and cap speculative CPU search separately
from verification CPU. Do not cap exact checking of a real candidate merely to
meet an aesthetic ratio.

The right metric is not raw model tokens versus CPU seconds. Track:

- structural lemmas or equivalences per model call;
- proof gaps closed;
- proportion of exact jobs justified by a prior route hypothesis;
- compute spent on discovery versus verification;
- candidate enrichment over a generic baseline;
- verified information gain per dollar.

## P1: store full telemetry more efficiently

### Evidence

The local run reached approximately 536 MiB in under two hours. Raw inbound API
events, deltas, repeated tool schemas, and model-visible instructions dominate
the event stream.

### Required change

Preserve the required full-fidelity trace while changing its physical layout:

- zstd-compressed append-only event segments;
- content-addressed storage for repeated tool schemas and shared prompts;
- a small indexed lifecycle stream for monitoring;
- separate quotas for scientific artifacts and telemetry;
- periodic segment hashes and crash-safe indexes.

Do not delete or semantically truncate observed trace content.

## P2: distinguish typed state from textual monitoring

A textual occurrence of `CANDIDATE` is not a candidate transition. Monitoring
must derive success only from:

```text
frozen manifest exists
AND verifier invocation references that manifest hash
AND verifier exits with accepted=true
```

Dashboards and watchdogs should consume typed host state rather than grep model
output.

## P2: package domains around evaluators

The hardware-synthesis selection reinforces the same conclusion. The reusable
unit should be a domain pack containing:

- immutable problem and candidate schemas;
- fast screeners;
- authoritative verifier;
- route representations;
- score and novelty policy;
- resume-aware exact-job templates;
- failure taxonomy.

The core harness should orchestrate durable routes and artifacts. Mathematical,
logic-synthesis, and hardware-specific judgment should remain in application
domain packs.

## Implementation order

1. Campaign supervisor, registry, crash recovery, and duplicate lock.
2. Inference-first phase policy and computation-proposal gate.
3. Asynchronous exact jobs and worker batches without model polling.
4. Host-owned route objects and automatic evidence ingestion.
5. Capability preflight and deployment fingerprint enforcement.
6. Resume leases and adaptive no-progress policy.
7. Compressed, indexed full-fidelity telemetry.
8. Progress- and cost-aware portfolio allocation.
