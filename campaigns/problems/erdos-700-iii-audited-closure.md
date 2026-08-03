# Erdős 700(iii): audited unconditional closure

## Immutable objective

For every composite integer \(n>1\), define

\[
D_n(k)=\frac{n}{\gcd(n,\binom nk)},\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

Prove or disprove

\[
\forall A>0\ \exists c_A>0\ \forall n>1\text{ composite},\qquad
D(n)\ge c_A(\log n)^A.
\]

A proof must preserve this quantifier order and produce one literal legal row.
A disproof must give one fixed \(A>0\), an unbounded explicit family, and a
proved all-row upper bound. Density-one, selected-family, finite, marginal,
multi-row, or conditional statements do not settle the problem.

## Mandatory audited starting state

Before choosing a lemma, read completely:

- `docs/part-iii-exploration-map.md`;
- `docs/part-iii-run-coverage-audit.md`;
- `docs/part-iii-session-coverage-audit.md`;
- `docs/erdos700-iii-bottleneck-brief.md`;
- `campaigns/problems/erdos-700-iii.md`.

Never inspect any `events.jsonl`. The exploration map is the canonical
do-not-retry ledger. Every route marked killed, false, insufficient, or
conditional remains unavailable unless the new argument supplies the exact
revival input recorded there. In particular, do not return:

- a renamed same-row compatibility conjecture;
- products of marginal probabilities or separate witnesses;
- a fixed multiplier menu, bounded-prefix CRT construction, or phase-free
  set-cover argument;
- a fixed cubic Carmichael bridge, divisor monotonicity, or quotient
  iteration;
- unsigned Fourier/energy estimates after discarding the actual edge phases;
- a method counterexample presented as a target counterexample;
- another route list or status synthesis.

The audit already covers 97 retained run directories, both root rollouts and
all 28 mathematical descendants of the continuation, and the six identified
Brave/ChatGPT threads. Treat their proved partial lemmas and finite falsifiers
as available evidence, not as results to rediscover.

## Research protocol

Work from first principles at the first genuinely unproved implication. For
each proposed bridge:

1. State it with complete quantifiers and constants.
2. Derive line by line how it gives the original theorem, a genuine
   counterfamily, or a uniform quantitative improvement.
3. Falsify it first against the exact retained certificates and small
   factored examples.
4. If it survives, prove it without silently changing the ambient cofactor,
   legal row, cutoff, component height, or common multiplier.
5. Audit the proof backwards from the original target.

Use independent proof and falsification workers when useful. A worker must
receive the exact lemma and the relevant killed-route constraints, not a vague
request to brainstorm. Continue a worker only when it has a concrete
inequality with a proved nontrivial term.

The lead must seek a materially new global mechanism. It may use any exact
identity retained in the map, but it must retain the one-row arithmetic
coupling. The strongest intermediate acceptance target is an unconditional
uniform bound

\[
D(n)\gg \log n\,L(\log n)
\]

for an explicit \(L(x)\to\infty\), with the uniform \(A=2\) bound preferred.
Such a theorem is genuine progress and must be fed into the next round; it is
not permission to stop the outer loop before the full objective is decided.

## Completion gate

The loop succeeds only with one of:

1. a complete unconditional proof of the immutable objective;
2. a complete unconditional counterexample family with an all-row bound.

A child campaign may additionally promote a proof-quality uniform advance
beyond \(D(n)\gg\log n\), but every other identity, restricted theorem,
conditional reduction, finite certificate, or auxiliary counterexample is
research evidence only.

For a claimed closure, write the full natural-language argument, statement
and quantifier audit, dependency/source audit, exact regression checks,
`candidate.json`, and a `solution.lean` matching the Formal Conjectures
statement. Use no `sorry`, `admit`, local axiom, unsafe bypass, or import of the
open theorem. Run the supplied verifier and report its exact result. Do not
upgrade a claim merely because a model or social-media source calls it solved.

If a campaign remains partial, its report must end with exactly one first
unproved quantified implication and the strongest proved obstruction or
advance. The outer manager must use that evidence to select a genuinely
different next campaign and keep going.
