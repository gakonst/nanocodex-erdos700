# Breakthrough campaign runbook

The harness can maximize the probability of a new result; it cannot guarantee
one. A credible campaign precommits to a target family, verifier, budget, and
denominator before spending frontier-model compute.

## 1. Pick a tractable frontier

Rank targets before exposing any solution attempts to the model. Favor problems
with:

- active expert interest and a clear open-status source;
- an explicit finite witness, exact inequality, formal statement, or otherwise
  machine-checkable endpoint;
- several plausible representations rather than dependence on one famous hard
  conjecture;
- mature computational or formal libraries;
- an expert willing to review significance and statement alignment.

The best first domain is finite combinatorics or a probabilistic/optimization
conjecture reducible to LP, SAT/SMT, exhaustive search, or exact arithmetic.
Avoid a target whose only feedback is that a long informal proof “looks right.”

## 2. Write the verifier first

The verifier is human-approved and outside the model's editable run directory.
It receives the absolute path of a frozen-candidate JSON manifest as its only
argument. It must independently load the referenced artifacts, check the
original hypotheses and claimed failure/conclusion, and exit zero only on
acceptance.

The harness hashes the executable into `campaign.json`. The model may generate
search code, but it may not replace the verifier that judges that code.

## 3. Pre-register the campaign

Record:

- exact problem source, frozen statement, and completion predicate;
- model/reasoning configuration;
- `disabled`, `novelty-only`, or `full-research` web policy;
- call, retained-session, concurrency, child-deadline, exact-job, and verifier
  budgets;
- whether and when a closure-mode steering message will be injected;
- allowed human interventions;
- how expert review and novelty search will be conducted;
- the full denominator: targets screened, campaigns run, candidates, verified
  results, rediscoveries, and false candidates.

## 4. Run discovery

Example:

```sh
# Pin the transitive math closure against garbage collection for the duration.
nix build .#lr --out-link .nix-math-env
nix develop .#lr --command cargo run --release -- \
  --env-file ../nanocodex/.env \
  --workspace . \
  --web-policy novelty-only \
  --max-worker-calls 64 \
  --max-retained-workers 16 \
  --max-concurrent-workers 8 \
  --max-batch-size 12 \
  --max-exact-jobs 64 \
  --max-concurrent-exact-jobs 4 \
  --max-exact-artifact-bytes 4294967296 \
  --max-exact-jobs-per-worker 8 \
  --worker-timeout-seconds 0 \
  --worker-closure-after-seconds 720 \
  --verifier /absolute/path/to/preapproved-checker \
  --verifier-timeout-seconds 300 \
  --closure-after-seconds 14400 \
  --max-lead-turns 4 \
  --campaign-timeout-seconds 21600 \
  "[exact problem statement and completion criteria]"
```

The root chooses mathematical routes. `spawn_math_batch` executes independent
reasoning assignments under host-owned scheduling. `run_exact_job` executes
long solver, CAS, formal-compiler, and enumeration jobs through `/bin/bash -c`
with total, no-progress, and aggregate artifact-growth limits, full
process-group cleanup, periodic checkpoint/heartbeat detection, and retained
hashed logs. `artifact-limit` means the computation must be sharded or changed
to retain compact top-K/checkpoint state; it is not mathematical evidence.
Clean workers receive
the path-contained read-only `inspect_research_artifacts` tool plus this
capability-scoped computation broker—no web, ledger, candidate, verifier,
writable filesystem tool, or child-agent authority. Artifact reads do not
consume exact jobs, and per-worker job quotas beneath the global pool prevent
an early wave from starving queued routes. The broker is not an OS filesystem
sandbox; its Bash process inherits the harness permissions. Facts go into
`ledger.jsonl`;
candidate files are copied into a content-addressed read-only snapshot before
`verify_candidate` runs. A manifest that merely hashes mutable live paths is
not a freeze.

Create the `.nix-math-env` output link first, then launch the harness inside the
named math shell once. The link is a persistent GC root for the complete
transitive closure; without it, a garbage collection during an ephemeral
`nix develop` can remove tool paths already inherited by a live campaign. All
child Bash processes then inherit pinned, live tools. Never wrap individual
live-run shards in nested `nix develop`: for a path flake that can repeatedly
snapshot the growing campaign tree before the actual computation even starts.

Set the worker closure steer early enough to leave time for synthesis. It asks
a child to stop opening searches and return the strongest checkable report; it
does not treat provider silence as failure or restart the request. The hard
worker and campaign deadlines remain the declared cancellation boundaries.
For deliberately unbounded Pro workers, pass `--worker-timeout-seconds 0` and
use closure steering only as a synthesis nudge; the campaign deadline still
owns the outer stop.

Plan for real WebSocket rollover during long workers. A reconnect must send
complete typed history with every function/custom-tool call paired to all of
its outputs, including notifications delivered after a yielded exec was
resumed by `wait`. Treat an API `No tool output found` response as a replay
invariant failure, not a mathematical failure or a reason to restart the same
search unchanged.

If a lead turn ends without verifier acceptance, the host classifies that as a
provisional research failure and continues the retained lead. The next turn
receives exact verifier-attempt summaries, worker budgets, remaining wall time,
and a requirement to diagnose the failed route before changing representation.
The campaign stops only at verifier acceptance or a predeclared host budget.

## 5. Closure mode

The optional timed steer operationalizes the public “enough partial results”
pattern without requiring a success claim. It asks the active turn to:

1. stop opening new broad routes;
2. select the best surviving route;
3. produce one complete unconditional object;
4. freeze it and invoke the available verifier;
5. return `blocked` with the exact missing lemma if the gate cannot be met.

The steering event and its original text are retained in `events.jsonl`.

## 6. Independent audit

Under `novelty-only`, discovery has no web tool. After it ends, a fresh
GPT-5.6 Pro/Max agent receives web search and the frozen artifacts solely for
novelty and source comparison. Correctness, statement alignment, novelty, and
significance remain separate verdicts.

## 7. Promotion rule

A campaign result is:

- `verified` only after the pre-approved executable or formal kernel gate;
- `strong-candidate` when the argument is complete-looking but lacks that gate;
- `partial` for checked intermediate progress;
- `rediscovered` when prior literature resolves it;
- `blocked` when no route clears the gate.

Even a verifier-accepted candidate is not publicly called a breakthrough until
an appropriate domain expert confirms statement alignment, novelty, and
significance.
