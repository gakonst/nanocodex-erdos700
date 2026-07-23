import FormalConjectures.ErdosProblems.«700»
import PrimeNumberTheoremAnd.Consequences

/-!
# Kernel-checked helper lemmas for Erdős 700(ii)

These lemmas expose the exact one-step Lucas consequences used by the
structural part of the proof. They deliberately avoid a custom base-digit
representation.
-/

namespace Erdos700PNT

lemma lucas_step_not_dvd (P n k : ℕ) (hP : P.Prime)
    (h : ¬P ∣ n.choose k) :
    k % P ≤ n % P ∧ ¬P ∣ (n / P).choose (k / P) := by
  letI := Fact.mk hP
  have hmod : n.choose k ≡
      (n % P).choose (k % P) * (n / P).choose (k / P) [MOD P] :=
    Choose.choose_modEq_choose_mod_mul_choose_div_nat
  have hprod : ¬P ∣
      (n % P).choose (k % P) * (n / P).choose (k / P) := by
    intro hd
    apply h
    exact (Nat.modEq_zero_iff_dvd).1
      (hmod.trans ((Nat.modEq_zero_iff_dvd).2 hd))
  constructor
  · by_contra hle
    have hlt : n % P < k % P := Nat.lt_of_not_ge hle
    apply hprod
    rw [Nat.choose_eq_zero_of_lt hlt, zero_mul]
    exact dvd_zero P
  · intro hd
    exact hprod (dvd_mul_of_dvd_right hd _)

lemma lucas_two_digits_le (P n k : ℕ) (hP : P.Prime)
    (h : ¬P ∣ n.choose k) :
    k % P ≤ n % P ∧ (k / P) % P ≤ (n / P) % P := by
  have h₁ := lucas_step_not_dvd P n k hP h
  have h₂ := lucas_step_not_dvd P (n / P) (k / P) hP h₁.2
  exact ⟨h₁.1, h₂.1⟩

lemma near_base_dvd_forces_residue
    (s d u v : ℕ) (hdu : d * u < s) (hv : v < s)
    (hdiv : s ∣ (s - d) * u + v) (hds : d ≤ s) :
    v = d * u := by
  obtain ⟨w, hw⟩ := hdiv
  have hsd : s - d + d = s := Nat.sub_add_cancel hds
  by_cases hu : u = 0
  · subst u
    simp only [mul_zero, zero_add] at hw hdu ⊢
    have hw0 : w = 0 := by nlinarith
    simpa [hw0] using hw
  have hu0 : 0 < u := Nat.pos_of_ne_zero hu
  have hwle : w ≤ u := by
    by_contra hn
    have huw : u < w := by omega
    have hmul : s * (u + 1) ≤ s * w :=
      Nat.mul_le_mul_left s (by omega)
    rw [← hw] at hmul
    nlinarith [Nat.sub_add_cancel hds]
  have huw : u ≤ w := by
    by_contra hn
    have hwu : w < u := by omega
    have hsw_le : s * w ≤ s * (u - 1) :=
      Nat.mul_le_mul_left s (by omega)
    have hbase_le : (s - d) * u ≤ s * w := by
      rw [← hw]
      exact Nat.le_add_right _ _
    have hgap : s * (u - 1) < (s - d) * u := by
      nlinarith [Nat.sub_add_cancel (show 1 ≤ u by omega),
        Nat.sub_add_cancel hds]
    omega
  have hwu : w = u := Nat.le_antisymm hwle huw
  subst w
  nlinarith [Nat.sub_add_cancel hds]

end Erdos700PNT

#print axioms Erdos700PNT.lucas_step_not_dvd
#print axioms Erdos700PNT.lucas_two_digits_le
#print axioms Erdos700PNT.near_base_dvd_forces_residue
