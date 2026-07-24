import PartIWork.CarryBridge
import Mathlib.Data.Nat.Choose.Factorization

/-!
# A concrete residue-carry weight for Erdős 700(i)

Mathlib's Kummer theorem counts the base-`p` carries in `k + (n-k)` by
residue inequalities.  We package exactly that finite count and the
complementary prime-power product.  The remaining product-reconstruction
lemma is stated as the `ExactCarryWeight` interface used below, rather than
introduced as a new logical assumption.
-/

namespace Erdos700PartI

/--
The number of base-`p` carries in `k + (n-k) = n`.

`Nat.log p n + 1` is a strict upper bound in Mathlib's Kummer theorem.  Thus
the definition is finite without choosing a separate large cutoff.
-/
def residueCarryCount (n k p : ℕ) : ℕ :=
  ((Finset.Ico 1 (Nat.log p n + 1)).filter fun i =>
    p ^ i ≤ k % p ^ i + (n - k) % p ^ i).card

/-- The concrete Kummer identity already supplied by Mathlib. -/
theorem residueCarryCount_eq_factorization_choose
    (n k p : ℕ) (hp : p.Prime) (hkn : k ≤ n) :
    residueCarryCount n k p = (n.choose k).factorization p := by
  symm
  exact Nat.factorization_choose hp hkn (Nat.lt_succ_self (Nat.log p n))

/--
The product of the prime-power layers of `n` not consumed by carries.

For each `p ∣ n`, the exponent in the gcd is
`min (v_p n) (v_p (n.choose k))`; consequently the complementary exponent is
`v_p n - v_p (n.choose k)`.  Truncated subtraction makes the displayed
formula valid even when the binomial valuation exceeds `v_p n`.
-/
noncomputable def residueCarryWeight (n k : ℕ) : ℕ :=
  ∏ p ∈ n.primeFactors,
    p ^ (n.factorization p - residueCarryCount n k p)

/-- The explicit finite residue-carry predicate proposed for part (i). -/
def ResidueCarrySafe (n : ℕ) : Prop :=
  CarrySafe n (Erdos700.P n) (residueCarryWeight n)

/--
Once the complementary-product reconstruction has been established, the
residue predicate is equivalent to the exact `f` equality.
-/
theorem f_eq_div_iff_residueCarrySafe
    (n witness : ℕ)
    (hn : 0 < n)
    (hP : 0 < Erdos700.P n)
    (hPdvd : Erdos700.P n ∣ n)
    (hexact : ExactCarryWeight n (residueCarryWeight n))
    (hwitness : Admissible n witness)
    (hwitnessWeight : residueCarryWeight n witness = Erdos700.P n) :
    Erdos700.f n = n / Erdos700.P n ↔ ResidueCarrySafe n := by
  exact f_eq_div_iff_carrySafe n (Erdos700.P n) witness
    (residueCarryWeight n) hn hP hPdvd hexact hwitness hwitnessWeight

end Erdos700PartI

#print axioms Erdos700PartI.residueCarryCount_eq_factorization_choose
#print axioms Erdos700PartI.f_eq_div_iff_residueCarrySafe
