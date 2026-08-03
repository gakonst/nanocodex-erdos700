# Erdős 700(ii): full Lean proof through the formalized prime number theorem

This is the primary exact-target formalization campaign. A new elementary
analytic route may remove the unformalized Maynard dependency entirely.

## Pinned compatible repositories

Formal Conjectures:

- path: `/home/ubuntu/github/google-deepmind/formal-conjectures`
- commit: `e751934294a381afd2d5fc1124c5953c8e25f9fa`
- Lean: `v4.27.0`
- Mathlib: `a3a10db0e9d66acbebf76c5e6a135066525ac900`

PrimeNumberTheoremAnd:

- path: `/home/ubuntu/github/AlexKontorovich/PrimeNumberTheoremAnd`
- use commit: `00737ce40d3ba12a58e63d7eca65563fb9860f7c`
- Lean: `v4.27.0`
- Mathlib: `a3a10db0e9d66acbebf76c5e6a135066525ac900`
- available PNT theorem:
  `PrimeNumberTheoremAnd/Consequences.lean`, theorem `pi_alt'`

Verify every pin before using it. Create a small integration Lake project under
the assigned run directory with both packages pinned. Do not modify either
source checkout.

## Mathematical route to formalize

The independently audited structural lemma says:

If primes `p < q < r` have gaps `a=q-p`, `c=r-q` with `c>a>0`, put
`b=r-p=a+c`. If `4*b^3 < p`, then for `n=p*q*r`,
`Erdos700.f n = p*q`, hence `(Erdos700.f n)^2 > n`.

Use the ordinary prime number theorem, not Maynard, to produce infinitely many
such triples.

For large `N`, choose an interval length `L` with

- `L` of order `N^(1/3)` but small enough that `4*L^3 < N`;
- the interval `[N,2*N]` partitions into `O(N/L)` subintervals of length at
  most `L`.

PNT gives asymptotically `N/log N` primes in `[N,2*N]`. Therefore some
subinterval contains more than `log₂ L + 2` primes for all sufficiently large
`N`, since

`N/log N` dominates `(N/L) * log L` when `L` is of order `N^(1/3)`.

Combinatorial lemma: if

`x₀ < x₁ < ... < x_(m-1)`

lies in an interval of length `L` and there is no triple `i<j<k` with

`x_k - x_j > x_j - x_i`,

then `2^(m-2) <= L`. One proof uses the last point: absence of such a triple
gives

`x_last - x_(j+1) <= x_(j+1) - x_j`,

so the remaining tail lengths decrease by at least a factor of two.

Thus a sufficiently prime-rich short interval contains primes `p<q<r` with
`r-q>q-p`, while `r-p<=L` and `p>=N` imply `4*(r-p)^3<p`.

Choose the construction for unbounded `N`; the products `p*q*r` are unbounded,
so the target set is infinite.

You may replace floors/cube roots by a cleaner integer sequence, e.g. take
`N = T^3` and `L = T/2` for large even `T`, provided the packing and PNT
estimates remain easy to formalize.

## Required work

1. First prove and compile the finite combinatorial lemma independently.
2. Derive a convenient eventual lower bound on primes in `[N,2N]` from
   `pi_alt'`; search the PNT project for an existing corollary before proving
   a new one.
3. Formalize the interval packing/pigeonhole argument.
4. Import or reproduce the compiled structural theorem from the dedicated
   structural run.
5. Prove the exact target:

```lean
answer(True) ↔
  {n : ℕ | ¬ n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite
```

without `sorry`, `admit`, new axioms, or
`Erdos700.erdos_700.parts.ii`.
6. Run `#print axioms` and retain the complete output.
7. Compile in the integration project and then adapt the frozen verifier to
   the two pinned dependencies without weakening its exact-target or axiom
   checks.
8. Launch independent workers for: PNT API extraction, combinatorial lemma,
   asymptotic dominance, interval packing, infinitude mapping, and statement
   audit.

## Output contract

- `lakefile.toml`, `lean-toolchain`, and pinned `lake-manifest.json`
- `Solution.lean`
- `compile.log`
- `axioms.log`
- `dependency-audit.md`
- `statement-audit.md`
- `report.md`

Lean acceptance is necessary. No model-only verdict counts.
