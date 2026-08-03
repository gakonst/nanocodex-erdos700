# Erdős 700(iii): unconditional progress beyond the A=1 barrier

## Mission

Stop generating equivalent reformulations of the unknown simultaneous-row
problem. Prove a genuinely stronger unconditional bound than Erdős--Szekeres,
or produce a rigorous counterexample family to a named stronger bound.

For

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n) = max_{2 <= k <= n/2} D_n(k),
```

the published argument gives `D(n) >= c log n` for every composite `n`.

The primary success target is:

```text
there exist an explicit function L(x) -> infinity and c > 0 such that
D(n) >= c log(n) L(log n)
for every sufficiently large composite n.
```

Examples that count include `L(x)=log log x`, `log log log x`, or any explicit
unbounded function. The stronger fixed target

```text
D(n) >= c (log n)^2
```

also counts. A theorem covering only a restricted family does not count as the
main result, but may be retained if it is new and proved.

## Mandatory evidence

Work in the repository and read:

- `campaigns/problems/erdos-700-iii.md`;
- `docs/erdos700-iii-bottleneck-brief.md`;
- `runs/math-1785006659-4151481/erdos-szekeres-reconstruction.md`;
- the final reports under:
  - `runs/erdos700-iii-height-uniform-20260726/`;
  - `runs/erdos700-iii-short-packet-20260726/`;
  - `runs/erdos700-iii-square-subproduct-20260726/`;
  - `runs/erdos700-iii-exceptional-row-20260726/`;
  - `runs/erdos700-iii-robust-digit-box-20260725/`.

Do not read their trace JSONL. Treat their counterfamilies and kill
certificates as constraints. In particular:

- fixed bounded multiplier menus are false;
- separate per-prime witnesses do not combine;
- packet averaging cannot merely reproduce the best singleton;
- `ARSI`, `PWCC`, and `RWER` are not results and are not acceptable outputs;
- a new acronym or sufficient condition is not progress unless its hypotheses
  are proved for every relevant `n`.

## Required portfolio

Use one batch with four independent theorem-first attacks.

1. **Sublevel-set/extremal attack.** Assume `D(n) <= x`. Use
   `n | lcm(1,...,x)` together with the exact denominator identity
   `D_n(k)=k/gcd(k,binomial(n-1,k-1))`. Prove a bound
   `log n <= x/L(x)` for an explicit unbounded `L`, or construct an infinite
   sublevel family refuting the proposed bound. Do not assume monotonicity in
   the divisor lattice.

2. **All-divisor product attack.** Use literal rows `k=d` for divisors `d|n`
   and seek a product, determinant, resultant, or valuation identity forcing
   one denominator `D_n(d)` above `log n` by an unbounded factor. Every
   cancellation and row-legality condition must be proved. Separate rows may
   be combined only inside a valid max/product inequality.

3. **First-barrier fixed-exponent attack.** Concentrate on the exact uniform
   statement `D(n) >= c (log n)^2`. Partial prime-power layers and
   instance-adaptive unbounded multipliers are allowed. Either prove it, give
   an infinite counterfamily, or prove a weaker explicit
   `log n * L(log n)` theorem. Do not return a simultaneous-Lucas conjecture.

4. **Adversarial closer.** Try to prove that no currently retained local
   mechanism can beat `c log n`, then identify and execute a genuinely global
   alternative. Audit any proposed theorem against `n=30`, `n=29505`, the
   fixed-menu residual counterfamily, the one-escape digit boxes, and balanced
   prime squares. A finite example may falsify a lemma but cannot support an
   asymptotic claim.

Continue at most two workers, and only when they have a concrete inequality
with a proved nontrivial term. Adversarially audit the strongest survivor.

## Acceptance gate

The campaign output is classified as `PROGRESS` only if it contains at least
one of:

1. a complete proof of `D(n) >= c log(n) L(log n)` for all sufficiently large
   composite `n`, with explicit unbounded `L`;
2. a complete proof of the `A=2` bound;
3. an infinite counterexample family disproving one of those exact uniform
   statements;
4. a newly located primary-source theorem whose verified hypotheses directly
   imply one of 1--3.

Local identities, restricted-family theorems, finite computations,
counterexamples to auxiliary lemmas, and equivalent conditional reductions
must be classified `NO_PROGRESS`, even when correct.

Write under `runs/erdos700-iii-beyond-a1-reset-20260726/`:

- `report.md`;
- `proof-or-counterexample.md`;
- `source-audit.md`;
- `acceptance-audit.md`.

The first line of `report.md` must be exactly `STATUS: PROGRESS` or
`STATUS: NO_PROGRESS`. Do not start Lean unless a complete natural-language
proof passing the acceptance gate exists.
