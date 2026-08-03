import FormalConjectures.ErdosProblems.«700»

/-!
# Exact value of `f` for a suitable prime triple

The structural argument gives a uniform lower bound `p*q` for every relevant
gcd.  The witness `k = r` attains that bound exactly.
-/

namespace Erdos700PNT

lemma gcd_choose_r_eq_pq
    (p q r : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hpq : p < q) (hqr : q < r) :
    Nat.gcd (p * q * r) ((p * q * r).choose r) = p * q := by
  letI := Fact.mk hr
  have hpC : p ∣ (p * q * r).choose r := by
    by_contra h
    have hpr : p ∣ r :=
      Erdos700.prime_dvd_of_not_dvd_choose p (p * q * r) r hp
        ⟨q * r, by ring⟩ h
    have : p = r := (Nat.prime_dvd_prime_iff_eq hp hr).1 hpr
    omega
  have hqC : q ∣ (p * q * r).choose r := by
    by_contra h
    have hqr' : q ∣ r :=
      Erdos700.prime_dvd_of_not_dvd_choose q (p * q * r) r hq
        ⟨p * r, by ring⟩ h
    have : q = r := (Nat.prime_dvd_prime_iff_eq hq hr).1 hqr'
    omega
  have hrC : ¬r ∣ (p * q * r).choose r := by
    have hmod : (p * q * r).choose r ≡
        ((p * q * r) % r).choose (r % r) *
          ((p * q * r) / r).choose (r / r) [MOD r] :=
      Choose.choose_modEq_choose_mod_mul_choose_div_nat
    rw [Nat.mul_mod_left, Nat.mod_self, Nat.choose_zero_right,
      Nat.mul_div_cancel _ hr.pos, Nat.div_self hr.pos,
      Nat.choose_one_right, one_mul] at hmod
    intro hd
    have h0 : (p * q * r).choose r ≡ 0 [MOD r] :=
      (Nat.modEq_zero_iff_dvd).2 hd
    have hrpq : r ∣ p * q :=
      (Nat.modEq_zero_iff_dvd).1 (hmod.symm.trans h0)
    rcases hr.dvd_mul.1 hrpq with hrp | hrq
    · have : r = p := (Nat.prime_dvd_prime_iff_eq hr hp).1 hrp
      omega
    · have : r = q := (Nat.prime_dvd_prime_iff_eq hr hq).1 hrq
      omega
  have hpqC : p * q ∣ (p * q * r).choose r :=
    Nat.Coprime.mul_dvd_of_dvd_of_dvd
      ((Nat.coprime_primes hp hq).2 (by omega)) hpC hqC
  have hpqg : p * q ∣ Nat.gcd (p * q * r) ((p * q * r).choose r) :=
    Nat.dvd_gcd ⟨r, rfl⟩ hpqC
  obtain ⟨e, he⟩ := hpqg
  have hgdvd :
      Nat.gcd (p * q * r) ((p * q * r).choose r) ∣ p * q * r :=
    Nat.gcd_dvd_left _ _
  rw [he] at hgdvd
  have hedvd : e ∣ r :=
    (Nat.mul_dvd_mul_iff_left (Nat.mul_pos hp.pos hq.pos)).1 hgdvd
  rcases hr.eq_one_or_self_of_dvd e hedvd with he1 | her
  · rw [he, he1, mul_one]
  · exfalso
    apply hrC
    have : r ∣ Nat.gcd (p * q * r) ((p * q * r).choose r) := by
      rw [he, her]
      exact ⟨p * q, by ring⟩
    exact this.trans (Nat.gcd_dvd_right _ _)

theorem f_eq_pqr_of_gcd_lower
    (p q r : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hpq : p < q) (hqr : q < r)
    (hLower : ∀ k, 1 < k → k ≤ (p * q * r) / 2 →
      p * q ≤ Nat.gcd (p * q * r) ((p * q * r).choose k)) :
    Erdos700.f (p * q * r) = p * q := by
  have hpq2 : 2 ≤ p * q := by
    exact hp.two_le.trans (by simpa using Nat.mul_le_mul_left p hq.one_lt.le)
  have hrhalf : r ≤ (p * q * r) / 2 := by
    have : 2 * r ≤ p * q * r := by
      simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
        Nat.mul_le_mul_right r hpq2
    omega
  have hgcd := gcd_choose_r_eq_pq p q r hp hq hr hpq hqr
  have hle : Erdos700.f (p * q * r) ≤ p * q := by
    have h := Erdos700.f_le (p * q * r) r hr.one_lt hrhalf
    rwa [hgcd] at h
  have hne : (Erdos700.fSet (p * q * r)).Nonempty :=
    ⟨_, Erdos700.f_mem (p * q * r) r hr.one_lt hrhalf⟩
  obtain ⟨k, hk1, hk2, hkeq⟩ := Nat.sInf_mem hne
  have hge : p * q ≤ Erdos700.f (p * q * r) := by
    rw [Erdos700.f_eq, hkeq]
    exact hLower k hk1 hk2
  exact Nat.le_antisymm hle hge

end Erdos700PNT

#print axioms Erdos700PNT.gcd_choose_r_eq_pq
#print axioms Erdos700PNT.f_eq_pqr_of_gcd_lower
