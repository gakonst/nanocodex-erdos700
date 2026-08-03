# Erdős 700(i): modular refinement-tree reset

The monolithic proof of

```
G F B <-> FactorTableauFeasible n B.toNat
```

has repeatedly produced architecture without a kernel-checked theorem. Change
the proof-engineering tree while preserving the exact raw integer system.

Recover the reports and failures from:

- `math-1784923227-3523152`
- `math-1784925707-3532247`
- `math-1784928184-3622565`
- `math-1784930103-3681859`

Do not rebuild dependencies or write `.lake` caches into runs.

## Required refinement chain

Produce separate source modules and compile-order contracts for:

1. `OrderedPrimeFactorization` coverage and Finsupp round trip.
2. One-hot selector decoding and construction.
3. Selected big-M prefix decoding and inactive-gate construction.
4. Canonical base-p digit reconstruction.
5. Borrow-transducer existence, uniqueness, terminal zero, and exact equality
   to `residueCarryCount`.
6. Boundary/budget row equivalence to `BoundaryAt ∧ Realized`.
7. A short final theorem composing stages 1--6 into
   `G F B <-> FactorTableauFeasible n B.toNat`.

Each module must expose a small theorem usable by the next; workers must return
Lean source, not an architecture essay. A stage may use an equivalent
canonical certificate internally only after proving equivalence with the raw
one-hot/big-M/digit/borrow rows. Do not insert semantic
`FactorTableauFeasible` into the definition of `G`.

The lead must merge the strongest independently produced modules into one
source tree, explicitly mark the first uncompiling or unproved lemma, and
continue repair there. Success requires a no-hole final theorem and axiom
audit.
