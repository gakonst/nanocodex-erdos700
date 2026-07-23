# Methods taxonomy

The [stretched Littlewood–Richardson search](stretched-lr-search.md) records
the verifier contract, exact filters, bounded evaluator, search distributions,
and live negative evidence from the flagship campaign.

The successful systems do not share one universal workflow. They repeatedly
combine a small set of search and verification patterns.

## Discovery modes

### Direct long reasoning

A precise problem is given in one turn and the model independently chooses its
mathematics and tools. Examples: correlation gap, BH FDR, Gaussian
counterexamples. This mode is cheap to start and surprisingly effective when a
small explicit witness or elementary overlooked proof exists.

### Portfolio research management

The lead maintains multiple routes, delegates independent workers, records
failed assumptions, and assigns adversarial audits. Examples: CDC and
zeroth-order optimization. This is preferable when the space of plausible
theories is large and premature convergence is dangerous.

### Human framework, model gap closure

A researcher supplies a paper, construction, formal infrastructure, or precise
missing lemma. The model searches locally around that frontier. Examples:
Rajagopal sumsets, Talagrand coupling, QAOA FGG. This often yields the highest
signal per token because the problem-selection and representation work is done.

### Computational witness search

The model turns a conjecture into LP, SAT/SMT, nonlinear optimization,
enumeration, or simulation, then extracts structure from the best candidates.
Floating-point success is followed by rationalization or rigorous bounds.

### Proof-assisted search

The target is encoded in Lean or another proof assistant. The model alternates
between decomposing the theorem, editing proof code, compiling, reading open
goals, and repairing. See [proof-assisted solving](proof-assisted-solving.md).

### Persistent verifier arena

Agents optimize against public deterministic verifiers and retain shared
history across attempts. This is effective for construction and record problems
where the score is a useful dense signal. EinsteinArena is the main example.

### Literature-attention resolution

Search locates a theorem, construction, or implication that resolves a problem
whose public status was stale. This is a real research service but should be
labeled rediscovery or attention-bottleneck resolution unless a new theorem is
also proved.

## Cross-cutting control loops

1. **Generator–critic:** independent construction followed by blind audit.
2. **Search–rationalize:** numerical witness followed by exact object recovery.
3. **Propose–compile–repair:** proof-assistant feedback becomes the search state.
4. **Population evolution:** retain validated candidates and mutate selected ancestors.
5. **Experiment–conjecture–prove:** computation suggests an invariant or formula.
6. **Proof–novelty split:** correctness and literature novelty are audited independently.
7. **Checkpoint–branch:** fork the conversation at a safe mathematical boundary to preserve incompatible routes.

## Tool choice by problem shape

| Problem shape | Discovery tools | Final evidence |
|---|---|---|
| Small explicit counterexample | Python/Sage/Mathematica, random search, enumeration | Exact arithmetic or short symbolic certificate |
| Linear constraints over distributions | LP/MILP, primal and dual solvers | Rational primal witness and dual certificate |
| Transcendental/numerical inequality | Arbitrary precision, interval arithmetic | Outward-rounded interval proof with versioned code |
| Finite combinatorial construction | SAT/SMT/CP-SAT, local search, graph tools | Exhaustive checker or independently implemented verifier |
| Algebraic identity | CAS exploration | Human-readable derivation plus exact symbolic check |
| Long theorem with mature library | Lean/Coq/Isabelle | Kernel-checked proof, axiom scan, statement audit |
| Optimization record | Public deterministic scoring harness | Reproducible candidate and verifier output |
| Novelty/status question | Web search, MathSciNet/arXiv/reference graphs | Exact citations and implication argument |

## Web search is a policy, not a boolean capability

Record four states:

- `disabled`: no external retrieval available;
- `restricted`: background search allowed but exact-target solution search forbidden;
- `enabled`: unrestricted research/literature search was part of the run;
- `not-reported`: public evidence does not establish the setting.

Also record what search contributed. Background theorem lookup, novelty audit,
retrieving an existing proof, and discovering a counterexample in literature
are materially different AI roles.

See [web search and specialized tools](web-search-and-specialized-tools.md) for
the full execution-policy matrix and recommended logging contract.
