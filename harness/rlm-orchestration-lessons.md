# RLM orchestration lessons

The adjacent `nanocodex-rlm` experiment is direct evidence about what
Nanocodex orchestration does and does not buy. It improved OOLONG-Synth
calibration overall from 0.6732 to 0.7234 and the 256K bucket from 0.5833 to
0.6667, but its confidence intervals crossed zero, it regressed at 128K, and
three cases failed from root-budget or tail behavior. These are tuning results,
not a passed held-out claim.

## Lessons carried into the math harness

### The harness is the computation graph

Exposing `spawn_agent` is only a capability. The useful object is a bounded
graph whose leaves receive locally tractable assignments, whose bulky state
stays outside root context, and whose lifecycle mechanics are deterministic.

For mathematics this means:

- the root chooses mathematical routes and interprets evidence;
- the host owns fan-out, ordering, concurrency, deadlines, cancellation, and
  budgets;
- compilers, solvers, and checkers own truth feedback;
- child reports remain Code Mode values or artifacts until the root needs a
  compact fact;
- a fresh agent is used for novelty and final adversarial review.

### Separate capacity dimensions

Total child calls, retained sessions, and active concurrency are different
budgets. The current harness exposes all three. Using every retained-session
slot in the first map phase leaves no capacity for targeted repair, so campaign
protocols should reserve calls deliberately.

### Tail control is correctness infrastructure

One pathological child should not consume the entire campaign deadline. Every
child turn receives a shorter deadline; on expiry the harness explicitly
cancels it and waits for termination. `spawn_math_batch` returns failures in
input order instead of aborting the whole batch or asking the root to reconstruct
which promise failed.

### Pro silence is not a transport failure

A stock Pro/Max call produced `response.in_progress`, then no application text
event for 125.418 seconds before completing successfully. Harder clean workers
crossed Nanocodex's former 300-second event-idle watchdog in lockstep. Each
retry opened a replacement socket and issued a fresh `response.create`, so it
restarted provider work rather than resuming it.

The transport now applies the event-idle watchdog only in Standard reasoning
mode. Pro waits for an event, a real socket error, caller cancellation, or the
harness's optional whole-worker deadline. `--worker-timeout-seconds 0` disables
that worker deadline when the operator deliberately wants an unbounded Pro
turn; campaign and exact-job limits remain independent cleanup boundaries.

### Reconnect replay must preserve late tool outputs

A one-hour socket rollover exposed a separate failure from idle timeout. A
yielded `exec` returned its initial `custom_tool_call_output`; later `notify()`
events arrived while a `wait` function call resumed that cell and reused the
original exec call ID. Nanocodex had cleared the committed call-pair tracker,
then classified the late notifications as orphans. Full-history replay removed
all outputs for that exec while retaining its call, and the Responses API
correctly rejected the request with `No tool output found`.

The adjacent checkout now retains committed pair identities until compaction
replaces history. A mock-WebSocket regression exercises yield, late notify,
socket loss, full replay, and successful completion. Long Pro operation needs
both policies: silence is allowed, and real reconnects replay every typed
call/output pair.

### Mechanical batching belongs in the host

The RLM root once generated invalid `Promise.all` plumbing and lost much of its
budget repairing the scheduler. `spawn_math_batch` accepts the mathematical
assignments as data and performs fan-out itself. Code Mode remains valuable for
adaptive route selection and reductions, not for reimplementing a semaphore.

### Enter the math environment once

Before starting a long campaign, run
`nix build .#lr --out-link .nix-math-env`. That persistent output link pins the
whole transitive LR closure; an ephemeral `nix develop` process and its copied
`PATH` strings are not themselves a reliable GC root for every later child.

Do not run `nix develop` inside individual exact jobs. This repository is a
path flake, so a nested invocation may snapshot the entire mutable worktree
before the actual command starts. In the live LR campaign the worktree was
5.2 GB because it included build output; eight nominally parallel shards spent
minutes contending on the path-input lock before Sage began.

Nested Nix also weakened process containment: `nix develop --command timeout`
placed each `timeout` child in a new process group. Terminating the outer shell
group left those bounded grandchildren reparented to PID 1. They eventually
finished under their own 600-second limits, but an application must not rely on
that accident. Launch the whole campaign once inside the named Nix shell and
have `run_exact_job` call Sage, Lean, and solvers directly through the inherited
`PATH`. Process-group cleanup is the containment boundary; jobs that create a
new session or process group are unsupported unless a stronger OS sandbox owns
their lifecycle.

An accepted exact job must also outlive its model-side Code Mode cell. Code
Mode may yield, compact, or abandon a cell while the child is still running.
The broker therefore moves the job into a host-owned task before awaiting it;
dropping the caller detaches observation, not execution or terminal-record
retention. The exact-job timeout and no-progress policy remain the cancellation
owners.

### Clean workers should be narrow, but computation should be brokered

Independent workers are fresh Nanocodex sessions and receive only their bounded
task, the path-contained read-only `inspect_research_artifacts` tool, and the
capability-scoped `run_exact_job` broker. They do not receive the host's
candidate, ledger, verifier, web, writable filesystem tool, or agent-scheduling
authority. Artifact reads do not consume computation jobs, and each worker has
a local exact-job quota below the shared campaign cap. Contextual forks remain
an exceptional local-branch mechanism, not the default map primitive.

The LR run showed the remaining gap: workers implemented long exact searches
inside yielded QuickJS cells because `run_exact_job` was available only to the
lead. Several cells retained gigabytes before finishing or being terminated.
The implemented boundary is a worker-callable, capability-scoped exact-job
broker: the worker submits a script, heartbeat path, total deadline, and
no-progress deadline; the host owns the shared campaign budget, concurrency
limit, aggregate exact-artifact growth cap, process group, and retained hashed
result. A live delayed-P(3) census demonstrated why the byte cap is distinct
from a heartbeat: the process was healthy while materializing a multi-gigabyte
SQLite domain that would eventually fill the host disk. Large routes must
stream deduplicated summaries, top-K candidates, and resumable shard state
rather than retain every raw row. It does not grant workers the
ledger, verifier, web, or arbitrary agent scheduler merely to let them run
Sage/lrcalc safely.

This is a scheduling and secret-isolation boundary, not an OS sandbox. The
broker removes `OPENAI_API_KEY`, pins the working directory, bounds aggregate
campaign artifact growth, and owns the process group, but `/bin/bash -c`
otherwise inherits the harness
process's filesystem permissions. Use a container or platform sandbox when
scripts themselves are untrusted.

### Provenance is sampled at build time

A prior RLM sweep accidentally combined a previously built binary with a later
adjacent Nanocodex checkout. This harness embeds the clean dependency commit,
relevant source-tree SHA-256, and dirty flag at build time. Each campaign also
records problem and prompt hashes. Comparing runs with different fingerprints
must be an explicit experiment, never an accidental mixture.

### A frozen manifest must own the bytes

The first LR campaign hashed paths in the live run directory but did not copy
their contents. Later ledger and report updates changed six referenced files,
so a clean auditor could validate most certificate data but could not reproduce
the manifest as a whole. A digest of a mutable path is an assertion, not an
immutable boundary.

`freeze_candidate` now copies every artifact into
`frozen/<candidate-id>/artifacts/`, records both its source and snapshot path,
makes the copied bytes and manifest read-only, and revalidates an existing
snapshot before returning it idempotently. Verifiers consume only those owned
snapshot paths. Post-freeze notes must be new artifacts in a new freeze, never
mutations behind an old content ID.

### Structured output remains unfinished

Tool-input schemas do not constrain a worker's final prose. The batch tool
contains failures and preserves ordering, but a future solver-specific slice
should validate worker output against a domain schema before returning it to
the root. Failed validation should consume a recorded retry reserve, not cause
unbounded repair fan-out.

## What not to conclude

- More workers are not monotonically better.
- Recursion is not automatically superior to one long coherent run.
- Model agreement is not verification.
- Passing a compiler proves the encoded target, not historical statement
  alignment or novelty.
- Completion-pressure prompting can sustain search, but cannot be an
  acceptance gate.

The implementation evidence remains in the adjacent
`../nanocodex-rlm/THREAD_NOTES.md`; this document records only the lessons that
change the mathematics harness.
