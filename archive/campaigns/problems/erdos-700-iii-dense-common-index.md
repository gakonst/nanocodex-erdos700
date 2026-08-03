# Erdős 700(iii): dense squarefree common-index closure

## Immutable target

For composite `n > 1`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= n/2} D_n(k).
```

Prove or disprove:

```text
for every real A > 0 there exists c_A > 0 such that
D(n) >= c_A (log n)^A
```

for every composite `n > 1`. Preserve the quantifier order and exact
prime-power components.

## Single campaign objective

Close the dense, mostly squarefree common-index gap left by run
`math-1784873765-3291519`. This is not another broad portfolio. Every worker
must attack the following residual statement or its exact negation:

> For every `epsilon > 0` there is `C_epsilon` such that whenever `x >= 2`,
> `n` is a composite divisor of `lcm(1,...,x)`, and
> `log n > C_epsilon x^epsilon`, there exists
> `2 <= k <= n/2` with `D_n(k) > x`.

The lead must first check the implication from this dense-escape statement to
the immutable target. Then launch exactly ten clean workers in one host-owned
batch, using all ten concurrency slots. Preserve at least twenty worker calls
for adversarial follow-ups and gap repair.

## Mandatory recovery

Use `inspect_research_artifacts`; never read any `events.jsonl`. Recover and
hash-inventory at least:

- `math-1784873765-3291519/report.md`
- `math-1784873765-3291519/research-note.md`
- `math-1784873765-3291519/verification.md`
- `math-1784873765-3291519/implication-graph.md`
- `math-1784873765-3291519/rational-cut-energy.md`
- `math-1784873765-3291519/binomial-row-staircase.md`
- `math-1784873765-3291519/prefix-lcm-profile.md`
- `math-1784873765-3291519/finite-rational-stencil-obstruction.md`
- `math-1784873765-3291519/novelty-audit.md`
- the ten first-wave worker reports and retained follow-up reports from that
  run when directly relevant to a delegated claim.

Also recover the compact boundary and squarefree syntheses:

- `math-1784861421-197355/first-pass-synthesis.md`
- `math-1784862756-235913/batch-2-synthesis.md`

Earlier artifacts are partial evidence only. Recheck every lemma used in a
closure chain.

## Proved regimes to factor out

The preceding campaign gives, subject to fresh audit,

```text
N_h(n) = product over v_p(n) >= h of p^(v_p(n)),
D(n) >= (log N_h(n) / (13h))^h.
```

It also handles prime powers, bounded/small `omega(n)`, and substantial
repeated-prime-power mass. Use this to reduce cleanly to a dense set of small,
mostly exponent-one components. Do not spend workers reproving those cases.

The exact local weight is

```text
W_n(k) = log D_n(k)
       = sum over p|n of
         [min(v_p(n),v_p(k)) - H_p(n,k)]_+ log p.
```

The row-staircase and prefix-lcm identities show that many layers occur
somewhere. They do not place those layers at one common `k`.

## Killed representations

Do not relaunch any of these without a new theorem that explicitly escapes its
retained counterexample:

- fixed endpoints, midpoint, or any preassigned finite rational stencil;
- multiplier one, divisor-only witnesses, or pairwise-to-joint gluing;
- inference of intersections from marginal density;
- bounded-density sequential bias or unsigned covariance heuristics;
- bounded-loss local transport and no-reset monotonicity;
- fixed-depth CRT prefixes without control of the cofactor;
- a counterexample family lacking an all-`k` upper bound.

Finite computation can falsify one named lemma but cannot establish the
asymptotic statement.

## Ten focused roles

Launch all ten immediately. Each report must return a quantified theorem and
proof, a realizable unbounded counterfamily with an all-`k` certificate, or
the first exact false implication with a proof-quality obstruction.

1. **Dense-escape proof architect.** Starting from `n|lcm(1,...,x)` and the
   boundary coverage theorem, build a complete proof of dense escape. You may
   introduce one new intermediate lemma only if it is strictly more explicit
   than the original conclusion and independently falsifiable.

2. **Rational-cut energy analyst.** Use the audited inequality

   ```text
   log D(n) >= log Q
     - (1/(d-1)) sum_{1<=j<d} Lambda_d(j)
   ```

   for proper unitary `n=dQ`. Prove that some data-dependent cut has a uniform
   energy deficit large enough to exceed `log x`. Exploit exact modular-rank
   orbit formulas; do not assume independence between bases.

3. **Row-layer concentration specialist.** Convert the exact staircase layer
   degrees and squarefree row-product identity into a one-index lower bound.
   Seek a high-moment, entropy, dependent-random-choice, or compression
   theorem whose hypotheses are verified by the arithmetic row rather than by
   an abstract incidence graph.

4. **Dense affine-shadow packet prover.** Prove the dense affine-shadow
   endpoint/packet lemma isolated by the boundary campaign, with a genuinely
   adaptive polynomial multiplier. It must handle changing bases, upper Lucas
   shadows, the half-range, and partial exponents.

5. **Changing-modulus large-sieve specialist.** Recode failed Lucas
   containment as residue-cylinder coverage and prove an averaged bound across
   the many varying prime moduli. Try large-sieve, character-sum, polynomial,
   or harmonic-analytic machinery, stating precisely what distribution input
   is actually available for divisors of `lcm(1,...,x)`.

6. **Adaptive multiplier/online selector.** Design a multiplier from a large
   candidate set after observing the component shadows. Prove an amortized
   potential or entropy increment that retains weight `>log x`; explicitly
   survive complete layer resets and the finite-stencil obstruction.

7. **Arithmetic hypergraph/container specialist.** Treat indices as
   hyperedges of surviving exact or partial layers. Prove a realizability-aware
   supersaturation/container theorem from the common integer `n`. Abstract
   marginal or pairwise density is insufficient.

8. **Proportional-depth CRT adversary.** Attempt the exact negative route:
   construct the unusually small proportional-depth CRT representative from
   the preceding conditional theorem, control every cofactor component, and
   prove a uniform upper bound for `D_n(k)` for every admissible `k`. Clearly
   distinguish refuting an intermediate lemma from refuting Part (iii).

9. **All-index duality specialist.** Seek a minimax, LP-duality,
   entropy-duality, or polynomial certificate converting the assumption
   `D_n(k)<=x` for every `k` into `log n=O_epsilon(x^epsilon)`. The certificate
   must aggregate constraints without pretending that an lcm or product over
   different indices is a maximum.

10. **Blind closer and quantifier referee.** Reconstruct the dense-escape
    target from the exact valuation identity without inheriting favored
    terminology. Attempt a complete proof or counterexample and audit every
    proposed chain from the other nine roles against the original
    `forall epsilon, exists C, forall n` order.

## Adaptive synthesis

After the first ten reports:

1. Construct an implication graph with proved, falsified, and open nodes.
2. Collapse equivalent common-index formulations; do not call renaming
   progress.
3. Select the route with the weakest remaining quantified lemma.
4. Use at least two retained follow-ups to try to prove it and two independent
   follow-ups to falsify precisely it.
5. If it fails, change representation materially and continue through the
   available lead-turn budget.
6. Regression-test every claimed implication on
   `30,35,42,60,72,132,210,252,858,1001,2310`, the interval-primorial
   family, `n=q(q+1)`, and the finite-rational-stencil construction.

## Completion gate

A complete candidate requires:

- a self-contained proof or counterexample with all constants and finite
  exceptions;
- independent correctness and quantifier audits;
- `candidate.json`, `research-note.md`, and `source-audit.md`;
- `solution.lean` proving the exact Formal Conjectures proposition, with no
  `sorry`, `admit`, local axioms, unsafe bypass, or import of the theorem;
- successful compilation, axiom audit, immutable freeze, and host-verifier
  acceptance.

No model consensus, finite experiment, or confident prose counts as success.
Keep pushing until the host budget is exhausted; if still blocked, preserve
the strongest unconditional theorem and one exact remaining lemma.
