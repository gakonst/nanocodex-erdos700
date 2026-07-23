# Dominance work

`Dominance.lean` closes the elementary asymptotic gap between the PNT interval
estimate and the finite packing argument.

It proves:

1. `(120 / log 2) * (log x)^2 < x` eventually, using
   `Real.isLittleO_pow_log_id_atTop`.
2. `10 * log (8*T^3) * (Nat.log 2 T + 2) < T` eventually.  The discrete
   logarithm is controlled by `Real.natLog_le_logb`.
3. The exact real comparison between the number of boxes times the allowed
   occupancy and the previously formalized PNT lower bound.
4. The directly consumable natural inequality

   ```lean
   ∀ᶠ T : ℕ in atTop,
     8 * T ^ 2 * (Nat.log 2 T + 2) <
       Nat.primeCounting (16 * T ^ 3) -
         Nat.primeCounting (8 * T ^ 3)
   ```

The file was compiled on `ubuntu@dev-georgios` with the campaign's pinned Lean
4.27.0 / Mathlib / PrimeNumberTheoremAnd environment:

```text
lake env lean DominanceWork/Dominance.lean
```

All four declarations have axiom footprint
`[propext, Classical.choice, Quot.sound]`; none depends on `sorryAx`.

The integration proof can consume the last theorem by importing:

```lean
import DominanceWork.Dominance
```
