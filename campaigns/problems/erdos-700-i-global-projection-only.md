# Erdős 700(i): global projection theorem only

The semantic factor tableau and the signed local borrow/count lemmas already
compile. Close exactly the remaining Lean theorem.

Inputs:

- `proof/PartIWork/FactorTableau.lean`
- `proof/PartIWork/ExplicitBorrow.lean`
- retained architecture and semantic-bridge reports from
  `math-1784923227-3523152`

Define the complete integer-typed selector/digit/borrow system `G(n,B)` from
the selected proposal, including a valid ordered supplied factorization,
one-hot exponent selectors, bounded prefix products, the common multiplier,
canonical digit reconstruction, terminal-zero borrow rows, and carry budgets.

Prove, without `sorry`, `admit`, local axioms, or weakened definitions:

```lean
theorem explicitG_iff_factorTableauFeasible
    (F : OrderedPrimeFactorization n r) (B : ℤ)
    (hB : 2 ≤ B ∧ B ≤ (n : ℤ)) :
    G F B ↔ FactorTableauFeasible n B.toNat
```

The exact spelling may change only for necessary dependent typing. Preserve
all inclusive endpoints. All signed arithmetic must be in `ℤ`; selectors and
borrows must be Boolean; digit bounds are integral. The reverse implication
must construct selectors, prefixes, digits, and borrows, not hide them in the
definition of `G`.

Return one self-contained Lean source artifact plus a concise list of imports
and the exact theorem name. Do not copy `.lake`, run `lake update`, download
Mathlib, or place build caches in the run. The operator will compile candidate
sources in the existing shared pinned environment.

If the theorem cannot be completed, return the smallest exact unproved Lean
lemma and all compiling source around it. Architectural prose alone is not an
acceptable result.
