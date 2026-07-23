# Tool-native orchestration

Subagents are expensive stochastic functions. They are useful for independent
mathematical taste, incompatible proof routes, and blind review. They are a poor
replacement for a compiler, solver, database, or state machine.

## Prefer an environment loop

The most productive control loop is usually:

```text
formal state → bounded action → deterministic feedback → updated state
```

Examples are Lean goal to patch to compiler error, LP model to candidate to
exact residuals, or finite construction to mutation to verifier score. These
loops give the model dense information and make the host—not another model—the
judge of progress.

## Tool families

### State and evidence

- `read_problem_package()` returns the immutable statement and fingerprints.
- `record_evidence(...)` appends an atomic typed event to the campaign ledger.
- `freeze_candidate(paths, dependencies)` hashes a candidate and closes it to
  further edits.
- `route_status(route_id)` returns checked facts, blockers, cost, and next
  admissible actions without replaying an entire transcript.
- `evaluate_gate(candidate_id, gate)` computes an acceptance predicate from
  retained artifacts.

### Formal proof state

- `lean_goals(declaration)` returns structured goals and local context.
- `lean_apply_patch(patch)` applies a bounded edit and immediately compiles.
- `lean_search(goal, filters)` retrieves declarations from the pinned library.
- `lean_verify(declaration)` checks target integrity, unfinished steps, axioms,
  unsafe constructs, and the dependency closure.
- `prove_subgoal(goal)` calls a specialized prover and returns proof, disproof,
  or failure rather than free-form advice.

### Computational search

- `define_search_space(schema)` creates a versioned finite or parametric space.
- `evaluate_candidates(ids)` batches cheap tests.
- `solve_lp`, `solve_smt`, `solve_sat`, and `solve_milp` return certificates and
  residuals as structured values.
- `rationalize(candidate)` turns a numerical object into an exact candidate.
- `exact_check(candidate)` uses a separate implementation and trust boundary.
- `minimize_counterexample(candidate)` finds the simplest witness preserving
  the exact failure.

### Retrieval and novelty

- `search_theorems(goal)` searches a pinned theorem library.
- `search_sources(query, purpose)` returns ranked source records with excerpts.
- `citation_neighborhood(source_id)` expands references and citations.
- `compare_statements(candidate, source)` checks hypotheses and conclusions
  explicitly; embedding similarity is not a novelty verdict.
- `record_prior_art(...)` links the exact dependency or overlap claim.

### Portfolio control

- `create_route(hypothesis, falsifier, budget, tool_plan)` creates a first-class
  route object.
- `score_route(route_id)` uses checked progress, novelty, and remaining risk.
- `branch_candidate(candidate_id, mutation)` explores a content-addressed
  object, not merely a chat history.
- `stop_route(route_id, reason)` enforces kill conditions.

Only after these tools are insufficient should Code Mode call
`spawn_math_agent` or `fork_math_agent`.

For several independent assignments known in advance, prefer
`spawn_math_batch`. It preserves the model's semantic route choices while
moving semaphore management, deadlines, cancellation, and indexed result
collection into host code. This is a direct consequence of the
[RLM experiment](rlm-orchestration-lessons.md), where model-authored scheduling
and child tails caused avoidable failures.

## Example: counterexample pipeline

```js
const route = await tools.create_route({
  hypothesis: "A smallest counterexample exists with support <= 8",
  falsifier: "Exhaust all supports <= 8 with an independently checked bound",
  budget: { solver_calls: 40 },
  tool_plan: ["solve_lp", "rationalize", "exact_check"]
});

for (let size = 2; size <= 8; size++) {
  const numeric = await tools.solve_lp({ route_id: route.id, size });
  if (numeric.status !== "feasible") continue;
  const exact = await tools.rationalize({ candidate: numeric.primal });
  const verdict = await tools.exact_check({ candidate: exact });
  await tools.record_evidence({
    route: route.id,
    kind: verdict.valid ? "refutation" : "failure",
    claim: `exact witness at size ${size}`,
    evidence: JSON.stringify(verdict),
    status: verdict.valid ? "verified" : "refuted",
    artifacts: verdict.artifacts
  });
  if (verdict.valid) break;
}
```

## Example: formal proof pipeline

```js
for (let round = 0; round < 50; round++) {
  const state = await tools.lean_goals({ declaration: "Main.target" });
  if (state.goals.length === 0) {
    const audit = await tools.lean_verify({ declaration: "Main.target" });
    if (audit.accepted) break;
  }

  const premises = await tools.lean_search({
    goal: state.goals[0],
    filters: { library_revision: state.library_revision }
  });
  const patch = await tools.fork_math_agent({
    role: "formal-step-proposer",
    task: `Propose one bounded patch for this goal and premises:\n${JSON.stringify({state, premises})}`
  });
  await tools.lean_apply_patch({ patch: patch.report });
}
```

Here the child supplies mathematical judgment, but Lean owns feedback and the
host owns acceptance.

## Implementation order

1. Campaign ledger and explicit web toggle.
2. Content-addressed candidate freeze and route objects.
3. One solver/checker pair for a narrow finite problem family.
4. Lean goal/edit/verify tools with target fingerprinting.
5. Source retrieval behind enforceable phase policy.
6. Population search only after simple loops have a measured baseline.
