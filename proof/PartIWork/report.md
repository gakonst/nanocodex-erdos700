# Part (i): complete checked equality-case solution

This directory proves exact finite characterizations of the equality cases
for both the maintained largest-prime target and the original 1978
greatest-prime-power target.

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
- `PrimePowerThreshold.lean` extends the exact witness and boundary theorem to
  every proper prime-power divisor.
- `HistoricalPrimePower.lean` specializes that machinery to the greatest
  exact prime-power component used in 1978 and handles prime powers.
- `HistoricalOrderDuality.lean` reproves the historical theorem through the
  exact strict-order duality between gcd and carry weight.
- `HistoricalExtremal.lean` reproves it through the finite maximum
  admissible carry weight.
- `FullDigitShadow.lean`, `CanonicalObstruction.lean`,
  `CofactorObstruction.lean`, and `DivisorPosetObstruction.lean` give
  increasingly explicit finite criteria for the maintained target.

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

## Historical theorem

For `Q(n)`, the greatest exact prime-power component, the checked theorem is

```lean
theorem Erdos700PartI.erdos_700_i_historical
    (n : ℕ) (hn : 1 < n) (hcomp : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.Q n ↔
      ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n
```

## Claim boundary

The theorems are complete finite carry/factorization characterizations. They
are stronger than restating the original equalities: the right sides contain
no `f`, gcd, or binomial coefficient and reduce failures to explicit finite
factorization/digit constraints. They are not a closed factorization-family
enumeration; such an enumeration would be an optional strengthening rather
than a missing part of the stated characterization problem. The complete
release evidence is indexed in `../../docs/part-i-release/README.md`, and
the complete run chronology is in
`../../docs/part-i-run-coverage-audit.md`.
