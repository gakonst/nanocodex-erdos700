# Formal and verifier-driven platforms

## AlphaProof Nexus

The DeepMind prover agent begins with a Lean theorem containing an editable
proof hole. Gemini agents propose mathematical plans and Lean patches; every
candidate is compiled. An optional AlphaProof tool attacks selected subgoals.
A shared population database retains validated sketches, while rater agents,
Elo-style scores, and P-UCB select promising ancestors for further mutation.

The public paper does not establish general web search as a core capability.
Its specialized environment is the point: Lean compiler/kernel feedback, a
formal-prover subtool, validated-sketch memory, and immutable-target checks.

Important safety and validity mechanisms:

- ensure the target statement is unchanged;
- prohibit residual `sorry`;
- test the first terms of OEIS definitions before proving their conjectures;
- keep only compiler-validated population members;
- use independent raters for plausibility and novelty;
- compare the formal result with the intended mathematical statement.

It reported nine Erdős formal results and 44 OEIS results, but a later audit
showed that Erdős #846 was already implied by prior literature and that the
public repository does not reconstruct all 44 OEIS claims.

[Paper and prompts](https://arxiv.org/abs/2605.22763),
[results](https://github.com/google-deepmind/alphaproof-nexus-results),
[audit](https://hedegreenresearch.com/articles/nine-became-eight/index.html).

## EinsteinArena

EinsteinArena is a persistent shared optimization environment rather than a
proof chatbot. Agents read problem JSON, submit candidate constructions to
public Python verifiers, inspect exact scores, and share ideas or failures in a
discussion layer. Verification runs in E2B sandboxes. Sensitive problems use
30–80 significant-digit Decimal arithmetic or exact integer checks.

The paper does not require general web search. The relevant search surface is
the arena itself: current records, verifier behavior, candidate history, and
other agents' discussion. This is a useful distinction for our architecture:
domain-state access often matters more than unrestricted browsing.

A representative successful route for the 11-dimensional kissing number was:

1. inherit a 593-point AlphaEvolve construction;
2. Taylor-linearize the nonlinear loss;
3. use LSQR to obtain a nearly valid configuration;
4. observe inner products clustering near small integers;
5. snap to an exact integral structure;
6. generalize the shared backbone to a 604-point construction.

The 12 reported results are verifier-backed records, not twelve resolved
theorems.

[Paper](https://arxiv.org/abs/2606.10402),
[repository](https://github.com/vinid/einstein-arena),
[agent API](https://einsteinarena.com/skill.md).
