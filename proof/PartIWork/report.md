# Part (i): checked boundary-antichain characterization

This directory proves an exact characterization of the composite integers
for which `Erdos700.f n = n / Erdos700.P n`.

## Kernel-checked chain

- `CarryBridge.lean` proves the order-theoretic minimum/weight bridge.
- `ResidueCarry.lean` defines the finite residue-carry count and complementary
  prime-power weight.
- `ExactWeight.lean` proves
  `gcd n (n.choose k) * residueCarryWeight n k = n`.
- `LargestPrime.lean` proves the complete largest-prime witness for every
  composite `n > 1`, removing the earlier provisional assumptions.
- `BoundaryAntichain.lean` proves that an overweight carry weight exists
  exactly when a divisibility-minimal divisor above `P(n)` is realized by an
  admissible multiple.

The final theorem is

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

It does not invoke `Erdos700.erdos_700.parts.i`.

## Verification

Run:

```sh
./scripts/verify-part-i.sh
```

The script builds the `PartIWork` root, rejects local proof placeholders,
runs `PartIVerify.lean`, rejects `sorryAx`, and checks that the final theorem
depends only on

```text
[propext, Classical.choice, Quot.sound]
```

See `boundary-antichain.md` for the complete prose proof and
`boundary-audit.md` for the adversarial regression cases.

## Claim boundary

The theorem is a complete finite carry/factorization characterization. It is
stronger than restating the original equality: the right side contains no
`f`, gcd, or binomial coefficient and reduces failures to a factorization
antichain. It is not a closed factorization-only taxonomy; realization still
contains genuine simultaneous digit/carry conditions over a bounded
multiplier range. External mathematical review should decide whether the
historical word “characterise” demands that stronger kind of taxonomy.
