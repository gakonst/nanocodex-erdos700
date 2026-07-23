# PNT density bridge

## Status

`PrimeInterval.lean` compiles with the pinned Lean 4.27.0 integration project.
It proves three reusable, `sorry`-free consequences of `pi_alt'`.

```lean
theorem eventually_primeCounting_double_interval :
    ∀ᶠ x : ℝ in atTop,
      x / (10 * Real.log x) ≤
        (Nat.primeCounting ⌊2 * x⌋₊ : ℝ) -
          (Nat.primeCounting ⌊x⌋₊ : ℝ)
```

```lean
theorem eventually_primeCounting_eight_cube_interval :
    ∀ᶠ T : ℕ in atTop,
      ((8 * T ^ 3 : ℕ) : ℝ) /
          (10 * Real.log (((8 * T ^ 3 : ℕ) : ℝ))) ≤
        (Nat.primeCounting (16 * T ^ 3) : ℝ) -
          (Nat.primeCounting (8 * T ^ 3) : ℝ)
```

The third theorem,
`eventually_primeCounting_eight_cube_interval_nat_sub`, gives the same bound
with the right side written as

```lean
((Nat.primeCounting (16 * T ^ 3) -
  Nat.primeCounting (8 * T ^ 3) : ℕ) : ℝ)
```

so it can feed finite-cardinality and pigeonhole arguments directly.

The proof uses `pi_alt'` directly.  Its `IsEquivalent.exists_eq_mul`
factorization supplies a multiplicative factor tending to `1`; eventually that
factor lies between `99/100` and `101/100` at both `x` and `2x`.  For
`x ≥ exp 10`, elementary logarithm estimates give
`log (2x) ≤ (11/10) log x`.  These imply the deliberately coarse lower bound
`x / (10 log x)`.

## Axiom audit

Lean reports for all three theorems:

```text
[propext, Classical.choice, Quot.sound]
```

There is no `sorryAx`.  Thus the unrelated `sorry` declarations elsewhere in
the PNT repository do not contaminate this dependency path.

## Remaining analytic lemma

This work intentionally leaves the final elementary dominance estimate

```text
8 T^3 / (10 log (8 T^3)) >
  8 T^2 (Nat.log 2 T + 2)
```

for all sufficiently large `T` as a separate lemma.  The PNT API boundary is
now fully discharged; the remaining statement only concerns growth of the real
logarithm versus the natural base-two logarithm.

## Reproduction

Run from the integration project:

```sh
/home/ubuntu/.elan/toolchains/leanprover--lean4---v4.27.0/bin/lake env lean \
  PNTWork/PrimeInterval.lean
```
