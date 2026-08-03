# Nanocodex mathematics research agent

## Product thesis

The product should be an evidence-producing research runtime, not a chat UI that
occasionally emits proofs. Nanocodex supplies the model/session lifecycle,
persistent Responses WebSocket, typed history, Code Mode, tools, retries,
checkpoints, and application-owned child-agent capabilities. This application
owns mathematical campaign policy, artifact storage, verification, novelty
search, budgets, and publication gates.

## Why Nanocodex fits

- GPT‑5.6 Pro is selected with `ReasoningMode::Pro`; effort remains an
  independent `Thinking` setting.
- Code Mode lets the lead generate loops, conditions, data reductions, and
  adaptive follow-ups without a model round trip after every tool operation.
  The application-owned batch tool handles mechanical parallel fan-out.
- Fresh `Nanocodex` sessions produce clean workers without inherited
  conversation or ambient tools.
- `AgentHandle::fork()` preserves the latest safe context for intentional local
  branches.
- retained child handles support multi-turn compiler and verifier repair loops.
- `TurnResult` is a safe historical checkpoint for exact branching.
- one session retains history, tools, code runtime, shell sessions, cache key,
  and response chain across turns.
- shared immutable prefixes can deliberately share provider prompt-cache keys
  while conversations and tool runtimes remain independent.

## System layers

```text
problem intake
    │
    ▼
statement curator ───────► immutable problem package
    │
    ▼
lead research manager (GPT-5.6 Pro + Code Mode)
    │
    ├── clean discovery workers
    ├── contextual proof branches
    ├── retained formal/computational workers
    ├── literature and novelty workers
    └── blind adversarial auditors
    │
    ▼
host verification services
    ├── exact arithmetic / CAS
    ├── LP/MILP/SAT/SMT
    ├── interval arithmetic
    ├── Lean compiler and axiom audit
    ├── deterministic domain verifier
    └── source/literature graph
    │
    ▼
evidence store + acceptance gates + publication package
```

## State model

```text
INTAKE
  → NORMALIZED
  → ROUTES_PLANNED
  → EXPLORING
  → CANDIDATE_FROZEN
  → VERIFYING
  → NOVELTY_AUDIT
  → {VERIFIED, STRONG_CANDIDATE, PARTIAL, REFUTED, REDISCOVERED, BLOCKED}
```

Transitions are host-owned and recorded. The model may recommend a transition
but cannot mark itself verified without satisfying a typed acceptance predicate.

## Agent roles

### Statement curator

Clean agent with no discovery context. Produces a normalized statement,
quantifier table, examples, formalization sketch, and target fingerprint.

### Lead research manager

Owns portfolio design and synthesis. It may use clean or contextual children but
does not act as the final correctness judge.

### Discovery workers

Route-specific clean agents: counterexample search, extremal, probabilistic,
analytic, algebraic, geometric, computational, and theorem-composition.

### Formal workers

Retained agents attached to a compiler loop. Each owns bounded files or lemma
names to minimize conflicting edits.

### Auditors

Clean agents given only the immutable statement and frozen candidate. Separate
roles for mathematical correctness, statement alignment, computation,
formal-axiom policy, and novelty.

## Web and retrieval policy

Web use is campaign policy:

1. `no_web`: pure reasoning and local tools;
2. `background_only`: named theorems and ordinary background, but no exact
   target or benchmark-solution search;
3. `novelty_only`: discovery workers are blind; a separate post-candidate agent
   performs literature search;
4. `full_research`: retrieval is available throughout;
5. `domain_sources_only`: curated corpora such as arXiv, Mathlib, OEIS, or an
   internal theorem graph.

The preferred scientific protocol is often `novelty_only`: it separates
independent discovery from the question of whether the result already exists.
For practical problem resolution rather than originality measurement,
`full_research` may be preferable.

Every retrieved source must be logged with query, URL/identifier, timestamp,
worker, and the exact claim for which it was used.

## Tool architecture

Expose structured, bounded tools behind Code Mode:

The primary abstraction is an environment transition with deterministic or
independently checkable feedback. Child agents supply taste where the next
action is genuinely ambiguous; they do not impersonate theorem databases,
compilers, solvers, or acceptance gates. The detailed design is in
[tool-native orchestration](../harness/tool-native-orchestration.md).

### Agent lifecycle

- `spawn_math_agent(role, task, policy)`
- `fork_math_agent(role, task)`
- `prompt_math_agent(agent_id, task)`
- future: `cancel_math_agent`, `agent_status`, `release_math_agent`

### Research artifacts

- `read_problem_package`
- `append_ledger`
- `freeze_candidate`
- `record_dependency`
- `emit_run_report`

The executable implements `record_evidence` as an append-only, host-owned JSONL
transition, content-addressed candidate freezing, and an optional pre-approved
verifier gate. Domain-specific formal and solver services remain later slices.

### Computation

- `run_python` in a pinned environment;
- `run_sage`;
- `solve_lp` returning primal, dual, residual, and rationalization data;
- `solve_sat` / `solve_smt`;
- `interval_check`;
- `verify_candidate` with problem-specific deterministic checker.

### Formal proof

- `lean_check`, `lean_goal`, `lean_declarations`;
- `lean_print_axioms`, `lean_scan_shortcuts`;
- `lean_target_fingerprint`;
- isolated patch submission and integration.

### Literature

- `search_primary_sources` with query log;
- `fetch_paper_metadata`;
- `citation_neighborhood`;
- `compare_statement`;
- `record_prior_art`.

## Orchestration policy

The lead should write the topology dynamically inside Code Mode. The host
supplies upper bounds rather than a fixed DAG:

- maximum live children;
- maximum total model calls/tokens/wall time;
- per-tool deadlines and output limits;
- maximum repair rounds;
- campaign-level cancellation;
- allowed web/search policy;
- allowed files and subprocesses.

Nanocodex core should remain unaware of these domain policies. They belong in
this application and its tools.

Trace-driven constraints from the adjacent recursive-harness experiment are
documented in [RLM orchestration lessons](../harness/rlm-orchestration-lessons.md).
In particular, the host—not model-generated JavaScript—owns batch fan-out,
active concurrency, per-child deadlines, cancellation, ordered failure
results, and complete event draining. Clean workers receive no ambient tools;
the root owns the programmable environment.

## Evidence acceptance predicates

Examples:

```text
formal_proof = target_fingerprint_unchanged
            && compiler_exit_zero
            && no_unfinished_steps
            && axioms ⊆ allowed_axioms
            && statement_alignment_accepted

finite_counterexample = exact_hypotheses_check
                     && exact_conclusion_failure
                     && independent_checker_exit_zero

interval_inequality = retained_source
                   && pinned_environment
                   && outward_rounding
                   && certified_margin > 0

novel_result = correctness_gate
            && novelty_search_complete
            && no_prior_result_found
```

The host computes these booleans from artifacts; model prose cannot substitute.

## Memory

Maintain three distinct memories:

- **conversation memory:** private per-agent Nanocodex history;
- **campaign memory:** append-only route ledger, candidates, failures, sources;
- **cross-campaign memory:** normalized reusable lemmas, tactics, failed prompt
  patterns, verifier behaviors, and literature implications.

Only validated facts graduate to cross-campaign memory. Failed attempts are
valuable but remain explicitly labeled.

## Executable vertical slice

`src/main.rs` implements the first verifier-first vertical slice:

- Pro/Max lead configuration;
- persistent session and shared immutable-prefix cache;
- standard Nanocodex Code Mode tools;
- clean spawn, bounded batch fan-out, contextual fork, and retained follow-up
  tools;
- separate worker-call, retained-session, and active-concurrency budgets;
- per-worker deadlines, explicit cancellation, and complete event draining;
- immutable problem and campaign manifests bound to the exact Nanocodex source;
- append-only evidence, content-addressed candidate freezing, and an optional
  hashed verifier executable;
- disabled, novelty-only, and full-research web policies;
- typed lifecycle events retained as attributed JSONL;
- optional evidence-qualified closure steering.

It intentionally does not yet provide domain-specific Lean, CAS, SAT/SMT, or
interval-arithmetic services, nor can it make a mathematical-breakthrough
guarantee. Those are the next slices in [the roadmap](../ROADMAP.md).
