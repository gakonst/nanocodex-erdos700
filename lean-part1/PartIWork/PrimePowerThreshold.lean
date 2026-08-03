import PartIWork.BaselineBoundary
import Mathlib.Data.Nat.Choose.Lucas
import Mathlib.Data.Nat.Factorization.PrimePow

/-!
# Prime-power threshold form of Erdős 700(i)

This module strengthens the largest-prime theorem: every proper prime-power
divisor `p ^ b` is an exact attainable baseline for the parameterized boundary
antichain theorem.
-/

namespace Erdos700PartI

theorem primePow_admissible
    (p b n : ℕ)
    (hp : p.Prime)
    (hb : 0 < b)
    (hpowdvd : p ^ b ∣ n)
    (hpowlt : p ^ b < n) :
    Admissible n (p ^ b) := by
  have hpowpos : 0 < p ^ b := pow_pos hp.pos _
  have hpowone : 1 < p ^ b :=
    hp.one_lt.trans_le
      (Nat.le_of_dvd hpowpos (dvd_pow_self p hb.ne'))
  obtain ⟨c, hc⟩ := hpowdvd
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hcne : c ≠ 1 := by
    intro hc1
    subst c
    simp at hc
    omega
  have hc2 : 2 ≤ c := by omega
  have htwo : 2 * p ^ b ≤ n := by
    calc
      2 * p ^ b ≤ c * p ^ b :=
        Nat.mul_le_mul_right _ hc2
      _ = n := by
        simpa [Nat.mul_comm] using hc.symm
  exact ⟨hpowone, by omega⟩

/-- Lucas applied repeatedly to the low base-`p` digits, all equal to `p-1`. -/
private theorem choose_pred_primePow_modEq_one'
    (p c a : ℕ)
    (hp : p.Prime)
    (hc : 0 < c) :
    (c * p ^ a - 1).choose (p ^ a - 1) ≡ 1 [MOD p] := by
  induction a with
  | zero =>
      simpa using (Nat.ModEq.refl 1 : 1 ≡ 1 [MOD p])
  | succ a ih =>
      have hpred : p - 1 < p := Nat.pred_lt hp.pos.ne'
      have hpa : 0 < p ^ a := pow_pos hp.pos _
      have hcpa : 0 < c * p ^ a := Nat.mul_pos hc hpa

      have pred_mul (x : ℕ) (hx : 0 < x) :
          p * x - 1 = (p - 1) + p * (x - 1) := by
        rw [Nat.mul_sub_left_distrib]
        simp only [Nat.mul_one]
        have hle : p ≤ p * x :=
          Nat.le_mul_of_pos_right p hx
        omega

      have hN :
          c * p ^ (a + 1) - 1 =
            (p - 1) + p * (c * p ^ a - 1) := by
        have hmul :
            c * p ^ (a + 1) = p * (c * p ^ a) := by
          rw [pow_succ]
          ac_rfl
        rw [hmul]
        exact pred_mul _ hcpa

      have hK :
          p ^ (a + 1) - 1 =
            (p - 1) + p * (p ^ a - 1) := by
        have hmul : p ^ (a + 1) = p * p ^ a := by
          rw [pow_succ]
          ac_rfl
        rw [hmul]
        exact pred_mul _ hpa

      letI : Fact p.Prime := ⟨hp⟩
      have hLucas :=
        Choose.choose_modEq_choose_mod_mul_choose_div_nat
          (p := p)
          (n := c * p ^ (a + 1) - 1)
          (k := p ^ (a + 1) - 1)

      have hstep :
          (c * p ^ (a + 1) - 1).choose
              (p ^ (a + 1) - 1) ≡
            (c * p ^ a - 1).choose (p ^ a - 1) [MOD p] := by
        simpa [hN, hK, Nat.add_mul_mod_self_left,
          Nat.add_mul_div_left _ _ hp.pos,
          Nat.mod_eq_of_lt hpred,
          Nat.div_eq_of_lt hpred] using hLucas

      exact hstep.trans ih

private theorem primePow_coprime_choose_pred'
    (p c a : ℕ)
    (hp : p.Prime)
    (hc : 0 < c) :
    (p ^ a).Coprime
      ((c * p ^ a - 1).choose (p ^ a - 1)) := by
  have hmod :=
    choose_pred_primePow_modEq_one' p c a hp hc
  have hpcop :
      p.Coprime ((c * p ^ a - 1).choose (p ^ a - 1)) :=
    (Nat.coprime_of_mul_modEq_one 1
      (by simpa using hmod)).symm
  exact hpcop.pow_left a

private theorem gcd_choose_primePow_mul'
    (p c a : ℕ)
    (hp : p.Prime)
    (hc : 0 < c) :
    Nat.gcd (c * p ^ a)
        ((c * p ^ a).choose (p ^ a)) = c := by
  have hq0 : p ^ a ≠ 0 :=
    pow_ne_zero _ hp.ne_zero
  have hchoose :
      (c * p ^ a).choose (p ^ a) =
        c * ((c * p ^ a - 1).choose (p ^ a - 1)) :=
    Nat.choose_mul_right hq0
  have hcop :=
    primePow_coprime_choose_pred' p c a hp hc
  calc
    Nat.gcd (c * p ^ a)
        ((c * p ^ a).choose (p ^ a)) =
      Nat.gcd (c * p ^ a)
        (c * ((c * p ^ a - 1).choose (p ^ a - 1))) := by
          rw [hchoose]
    _ = c * Nat.gcd (p ^ a)
        ((c * p ^ a - 1).choose (p ^ a - 1)) := by
          rw [Nat.gcd_mul_left]
    _ = c := by
          rw [hcop.gcd_eq_one, Nat.mul_one]

theorem primePow_gcd_choose
    (p b n : ℕ)
    (hp : p.Prime)
    (hn : 0 < n)
    (hpowdvd : p ^ b ∣ n) :
    Nat.gcd n (n.choose (p ^ b)) = n / p ^ b := by
  obtain ⟨c, hc⟩ := hpowdvd
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hn_mul : n = c * p ^ b := by
    simpa [Nat.mul_comm] using hc
  calc
    Nat.gcd n (n.choose (p ^ b)) =
        Nat.gcd (c * p ^ b)
          ((c * p ^ b).choose (p ^ b)) := by
      rw [hn_mul]
    _ = c :=
      gcd_choose_primePow_mul' p c b hp hcpos
    _ = n / p ^ b := by
      simp [hc, hp.ne_zero]

theorem residueCarryWeight_primePow
    (p b n : ℕ)
    (hp : p.Prime)
    (hb : 0 < b)
    (hpowdvd : p ^ b ∣ n)
    (hpowlt : p ^ b < n) :
    residueCarryWeight n (p ^ b) = p ^ b := by
  have hpowpos : 0 < p ^ b := pow_pos hp.pos _
  have hnpos : 0 < n := hpowpos.trans hpowlt
  have hadm :=
    primePow_admissible p b n hp hb hpowdvd hpowlt
  have hexact :=
    (residueCarryWeight_exact n (p ^ b) hnpos hadm).2
  rw [primePow_gcd_choose p b n hp hnpos hpowdvd] at hexact

  have hcanonical : n / p ^ b * p ^ b = n :=
    Nat.div_mul_cancel hpowdvd
  have hquotpos : 0 < n / p ^ b :=
    Nat.div_pos
      (Nat.le_of_dvd hnpos hpowdvd)
      hpowpos

  exact Nat.mul_left_cancel hquotpos
    (hexact.trans hcanonical.symm)

/-- Every proper prime-power divisor is an exact antichain threshold. -/
theorem f_eq_div_primePow_iff_boundarySafeAt
    (p b n : ℕ)
    (hp : p.Prime)
    (hb : 0 < b)
    (hpowdvd : p ^ b ∣ n)
    (hpowlt : p ^ b < n) :
    Erdos700.f n = n / p ^ b ↔
      BoundarySafeAt n (p ^ b) := by
  have hpowpos : 0 < p ^ b := pow_pos hp.pos _
  have hnpos : 0 < n := hpowpos.trans hpowlt
  have hpowone : 1 < p ^ b :=
    hp.one_lt.trans_le
      (Nat.le_of_dvd hpowpos (dvd_pow_self p hb.ne'))
  exact
    f_eq_div_iff_boundarySafeAt
      n (p ^ b) (p ^ b)
      hnpos hpowone hpowdvd
      (primePow_admissible p b n hp hb hpowdvd hpowlt)
      (residueCarryWeight_primePow p b n hp hb hpowdvd hpowlt)

#print axioms Erdos700PartI.primePow_gcd_choose
#print axioms Erdos700PartI.residueCarryWeight_primePow
#print axioms Erdos700PartI.f_eq_div_primePow_iff_boundarySafeAt

end Erdos700PartI
