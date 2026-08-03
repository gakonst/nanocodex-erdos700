# Web search and specialized tools

Web access, theorem retrieval, code execution, and proof assistance are distinct
experimental variables. “The model had tools” is not enough metadata to
reconstruct a result.

## What to record

For every run, record availability, actual use, queries or inputs, outputs used
in the argument, and the phase in which each capability was allowed.

| Capability | Typical role | What must be retained |
|---|---|---|
| General web search | Background, strategy discovery, exact-target search, novelty audit | Policy, query, result rank, URL, retrieved passage, downstream claim |
| Theorem-library search | Premise selection and API discovery | Query or proof state, library revision, declarations returned, selected declaration |
| Local corpus retrieval | Search supplied papers, notes, failed routes, or prior lemmas | Corpus manifest, query, chunks returned, content hashes |
| CAS | Simplification, exact identities, algebraic elimination | Source expression, assumptions, command, version, exact output |
| Numerical computation | Conjecture formation and witness search | Code, seed, precision, tolerances, environment, raw output |
| LP/MILP/SAT/SMT | Finite witnesses and certificates | Normalized instance, solver/version, status, primal and dual/certificate, exact replay |
| Interval arithmetic | Rigorous real-number bounds | Rounding mode, precision, enclosures, certified margin, code/version |
| Proof assistant | Goal-directed proof search and kernel checking | Exact statement, dependency lock, edits, compiler feedback, final proof, axioms |
| Domain verifier | Construction or record checking | Candidate, verifier source/hash, exact invocation, stdout/stderr |
| Subagent/model call | Independent idea generation or audit | Model/configuration, inherited context, prompt, result, lineage, cost |

## Web policies

Use an enforced policy, not a prose request that a worker can quietly ignore.

### Discovery blind

No network retrieval during problem selection or proof search. The immutable
problem package and a pinned local library are the entire environment. This is
the cleanest originality experiment but often the least useful practical
research setup.

### Background only

Allow definitions, standard theorem statements, software documentation, and
library/API lookup. Block the exact target, distinctive phrases from it, the
problem ID, and known authors. Log every query so leakage can be audited.

### Novelty only

Discovery is blind. After a candidate is content-addressed and frozen, a
separate worker gets unrestricted search to identify prior art, stronger known
results, and missing citations. This is the preferred policy when measuring
independent mathematical discovery.

### Full research

Unrestricted retrieval is available throughout. This is appropriate when the
goal is to resolve a question efficiently rather than measure originality. A
result found directly in the literature is useful, but must be labeled
`rediscovered` or `attention-bottleneck`, not a new theorem.

### Domain sources only

Permit a whitelist such as Mathlib, arXiv, zbMATH/MathSciNet, OEIS, or a
project-specific corpus. This gives better provenance and less irrelevant web
content, but does not by itself prevent exact-target leakage.

## What recent systems suggest

The public cases favor tight, typed feedback loops over unconstrained groups of
chat agents:

- AlphaProof Nexus starts from a Lean sketch, allows structured
  search-and-replace edits, compiles after changes, validates integrity, and
  optionally calls AlphaProof on focused subgoals. Its larger configuration
  adds a shared population of compiling sketches, P-UCB parent selection, and
  Elo ratings. The paper reports that the basic compiler-loop agent could also
  find the successful proofs, though sometimes at higher cost.
- AxProverBase combines a Lean compiler loop with Mathlib retrieval, optional
  web search, compact failure memory, and a reviewer that checks statement
  preservation and disallowed shortcuts.
- The strongest computational counterexample cases use a solver as the search
  environment and an independent exact checker as the acceptance environment.
  The model does not get to convert “solver found feasible” directly into
  “the conjecture is false.”
- Wang's July Erdős campaign used long Codex sessions and a disciplined prompt,
  but also reports Python experiments for some cases and Lean work for two.
  The public thread does not establish a uniform per-run web policy, so those
  cases remain `not-reported` for web use.

Primary methodology sources:
[AlphaProof Nexus](https://arxiv.org/html/2605.22763v1),
[AxProverBase paper](https://arxiv.org/html/2602.24273v3), and
[AxProverBase repository](https://github.com/Axiomatic-AI/ax-prover-base).

## Recommended Nanocodex policy

Treat tools as state transitions with typed evidence, not as convenient ways to
obtain more prose.

1. The host freezes a problem package and chooses a web policy.
2. Code Mode selects a domain loop from the target shape.
3. Retrieval tools return source objects; they never return an untraceable
   blended answer.
4. Search tools produce candidates. Separate checker tools produce verdicts.
5. Every important observation enters the append-only campaign ledger.
6. A candidate is frozen before blind audit and novelty search.
7. Only host-computed acceptance predicates can emit `verified`.

The first scaffold exposes `--web-search enabled|disabled` and records typed
events through `record_evidence`. Restricted and phase-separated web policies
require distinct tool runtimes or a policy-enforcing search gateway; prompt
instructions alone are not enforcement.
