# Verification ladder

Evidence should be compositional. No single rung establishes correctness,
statement alignment, novelty, and significance at once.

## Tier A: strong independent evidence

One or more of:

- kernel-checked formal proof with target and axiom audit;
- short exact witness independently recomputed;
- exact primal/dual or exhaustive certificate with a small trusted checker;
- rigorous interval certificate with pinned code and outward rounding;
- expert mathematical review plus reproducible primary artifacts.

Examples: CDC Lean repository, QAOA FGG, Jacobian finite witness, Grothendieck
mathlib merge, correlation-gap LP certificate.

## Tier B: strong mathematical candidate accepted by experts

A complete public proof has been checked by relevant mathematicians, but there
is no complete formal or compact executable certificate. Novelty may still need
continued literature review.

Examples: Gowers/Rajagopal sumsets, Erdős #119, Fisher log-convexity.

## Tier C: reproducible candidate

The proof or code is public and substantive, but independent expert or formal
validation is incomplete. Cross-model review does not raise it above this tier.

Examples: Knuth Exercise 210 and the current Erdős #421 claim.

## Tier D: unsupported claim

Only screenshots, summaries, model self-review, or operator confidence are
available. These are leads, not mathematical results.

## Four independent audits

### Correctness

Does every step follow and every computation check?

### Statement alignment

Does the proved proposition exactly match the intended problem and definitions?

### Novelty

Was the result already known, implicit, or an easy corollary of a stronger theorem?

### Attribution

Which mathematical ideas came from the model, operator, supplied papers,
public discussion, formal libraries, search results, and later reviewers?

Record all four. “Lean verified” answers mostly the first question and only for
the formal statement.

## Independent implementation

For finite certificates, prefer a second small checker written separately from
the search code. Re-running the same generated code under another coding model
can catch operational mistakes but is weaker than independent implementation.

## Evidence package minimum

- immutable target and normalized target;
- complete prompt and steering log;
- model/mode/effort, duration, and token accounting;
- web/search policy and retrieved sources;
- tools, versions, commands, seeds, and environments;
- candidate proof/construction and all dependencies;
- raw verifier/compiler/certificate outputs;
- formal statement fingerprint and axiom report if applicable;
- novelty report and exact citations;
- human interventions and independent reviewers;
- known gaps and precise status.
