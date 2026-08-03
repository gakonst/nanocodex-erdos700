# Tool contracts

Tools should return structured evidence, not prose-shaped success flags.

Subagents are not the default tool abstraction. Prefer a typed theorem search,
compiler, solver, exact checker, verifier, or artifact transition whenever one
can supply more objective feedback. See [tool-native
orchestration](tool-native-orchestration.md).

## Campaign ledger

`record_evidence` accepts one atomic record: route, evidence kind, claim,
concrete evidence, status, artifact paths, and source identifiers. The host adds
a monotonic sequence and timestamp and appends JSONL. Model prose may summarize
the ledger but must never replace it.

## Agent tools

```json
{
  "role": "counterexample-scout",
  "task": "Search n <= 12 and return exact witnesses or an invariant.",
  "isolation": "clean",
  "web_policy": "disabled",
  "artifact_directory": "routes/counterexample-01"
}
```

Result fields should include agent ID, lineage kind, status, report, artifacts,
sources, and resource usage.

Clean workers have no web-search capability. The lead performs live source
discovery and delegates audits with explicit URLs or retained source artifacts;
worker memory is never recorded as a completed literature search.

## Solver tools

An LP tool should return:

- normalized formulation hash;
- solver and version;
- numerical status and tolerances;
- primal vector/objective/residual;
- dual vector/bound/residual;
- rationalized candidate if requested;
- exact checker result;
- retained model and certificate paths.

Similar contracts apply to SAT/SMT, interval arithmetic, and exhaustive search.

## Lean tools

A Lean check result should return:

```json
{
  "exit_code": 0,
  "target_fingerprint_before": "sha256:...",
  "target_fingerprint_after": "sha256:...",
  "unfinished_steps": [],
  "axioms": ["propext", "Classical.choice", "Quot.sound"],
  "prohibited_tokens": [],
  "declarations_checked": ["Main.theorem"],
  "stdout_path": "verification/lean.stdout",
  "stderr_path": "verification/lean.stderr"
}
```

## Search tools

Search results must preserve:

- query;
- policy and worker role;
- result URL/identifier/title/date;
- retrieved excerpt or paper section;
- why it is relevant;
- whether it was used for discovery, proof, background, or novelty;
- content hash where licensing permits retention.

## Artifact tools

`inspect_research_artifacts` lists or reads bounded retained artifacts without
spending an exact-computation job. Paths are relative to the workspace's
`runs/` directory. Clean workers receive the current run prefix in their
immutable instructions and prepend it to current-run paths. Listing `.` returns
the available retained run directories when a delegated path is missing or
mistyped.

`freeze_candidate` should fail if the target is missing, artifacts are outside
the run directory, referenced files do not exist, or hashes cannot be computed.
The result is a new immutable version ID.

## Campaign verifier

`verify_candidate(candidate_id)` invokes only the executable supplied by the
operator before the run. The harness hashes that executable into the campaign
manifest, passes it the frozen manifest path without a shell, applies a
deadline, bounds captured output, and returns candidate/verifier hashes, exit
status, stdout, and stderr. Exit zero means the domain verifier accepted the
candidate; it does not by itself establish novelty or significance.
