import CoreHelpers

/-! The `p,q` simultaneous-omission contradiction for Erdős 700. -/

namespace Erdos700PNT

set_option maxHeartbeats 1000000

private lemma norm2pq (P lo hi : ℕ) (hP : 0 < P) (hlo : lo < P) :
    (lo + P * hi) % P = lo ∧ (lo + P * hi) / P = hi := by
  constructor
  · simpa [Nat.mod_eq_of_lt hlo] using Nat.add_mul_mod_self_left lo P hi
  · simpa [Nat.div_eq_of_lt hlo] using Nat.add_mul_div_left lo hi hP

private lemma quotient_half_pq (P Q R t : ℕ) (hP : 0 < P) (hQ : 0 < Q)
    (h : P * Q * t ≤ (P * Q * R) / 2) : t ≤ R / 2 := by
  have h2 : (P * Q * t) * 2 ≤ P * Q * R :=
    (Nat.le_div_iff_mul_le (by omega : 0 < 2)).1 h
  have hc : t * 2 ≤ R := by
    apply Nat.le_of_mul_le_mul_left (c := P * Q)
    · simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using h2
    · exact Nat.mul_pos hP hQ
  exact (Nat.le_div_iff_mul_le (by omega : 0 < 2)).2 hc

private lemma below_mul_pq (R d t : ℕ) (hdR : d ≤ R) (hdtR : d * t ≤ R)
    (ht : 1 ≤ t) :
    (R - d) * t = (R - d * t) + R * (t - 1) := by
  nlinarith [Nat.sub_add_cancel hdR, Nat.sub_add_cancel hdtR,
    Nat.sub_add_cancel ht]

private lemma pr_q_expansion_pq (q a c : ℕ)
    (haq : a ≤ q) (hacq : a * c ≤ q) (hgap : a + 1 ≤ c) :
    (q - a) * (q + c) =
      (q - a * c) + q * ((c - a - 1) + q) := by
  have hqa : q - a + a = q := Nat.sub_add_cancel haq
  have hqac : q - a * c + a * c = q := Nat.sub_add_cancel hacq
  have hca : c - a + a = c := Nat.sub_add_cancel (by omega)
  have hca1 : c - a - 1 + 1 = c - a := Nat.sub_add_cancel (by omega)
  nlinarith

theorem not_p_and_q_omitted
    (p q r a c k : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (hk1 : 1 < k) (hk2 : k ≤ (p * q * r) / 2) :
    ¬ (¬ p ∣ (p * q * r).choose k ∧ ¬ q ∣ (p * q * r).choose k) := by
  rintro ⟨hpC, hqC⟩
  have hpq : p < q := by omega
  have hqr : q < r := by omega
  have hpqne : p ≠ q := by omega
  have hpk : p ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose p (p * q * r) k hp
      ⟨q * r, by ring⟩ hpC
  have hqk : q ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose q (p * q * r) k hq
      ⟨p * r, by ring⟩ hqC
  have hpqk : p * q ∣ k :=
    ((Nat.coprime_primes hp hq).2 hpqne).mul_dvd_of_dvd_of_dvd hpk hqk
  obtain ⟨t, hkt⟩ := hpqk
  have ht : 0 < t := by
    by_contra h
    have : t = 0 := by omega
    subst t
    simp at hkt
    omega
  have hkt' : k = p * q * t := hkt
  have htr : t ≤ r / 2 := by
    apply quotient_half_pq p q r t hp.pos hq.pos
    simpa [hkt'] using hk2

  have hb : 0 < a + c := by omega
  have hb_le_cube : a + c ≤ (a + c) ^ 3 :=
    Nat.le_self_pow (by omega : 3 ≠ 0) _
  have hcube4 : (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
    have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 1 ≤ 4)
    simpa [Nat.mul_comm] using this
  have hb_lt_p : a + c < p :=
    hb_le_cube.trans_lt (hcube4.trans_lt hlarge)
  have ht_lt_p : t < p := by
    rw [hreq, hqeq] at htr
    omega

  have hpDivK : k / p = q * t := by
    rw [hkt']
    simpa [Nat.mul_assoc] using Nat.mul_div_cancel_left (q * t) hp.pos
  have hpDivN : (p * q * r) / p = q * r := by
    simpa [Nat.mul_assoc] using Nat.mul_div_cancel_left (q * r) hp.pos
  have hpStep := (lucas_step_not_dvd p (p * q * r) k hp hpC).2
  have hpDigits :
      (q * t) % p ≤ (q * r) % p ∧
      ((q * t) / p) % p ≤ ((q * r) / p) % p := by
    simpa [hpDivK, hpDivN] using
      lucas_two_digits_le p ((p * q * r) / p) (k / p) hp hpStep

  let u := a * t / p
  let v := a * t % p
  have hvp : v < p := Nat.mod_lt _ hp.pos
  have hat_ap : a * t < a * p :=
    Nat.mul_lt_mul_of_pos_left ht_lt_p ha
  have hu_lt_a : u < a :=
    (Nat.div_lt_iff_lt_mul hp.pos).2 (by
      simpa [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using hat_ap)
  have ht_u_lt_p : t + u < p := by
    have hu : u ≤ a - 1 := by omega
    rw [hreq, hqeq] at htr
    have h3b : 3 * (a + c) < p :=
      (by
        have hle : 3 * (a + c) ≤ 4 * (a + c) ^ 3 := by
          have h1 : 3 * (a + c) ≤ 3 * (a + c) ^ 3 :=
            Nat.mul_le_mul_left 3 hb_le_cube
          have h2 : 3 * (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
            have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 3 ≤ 4)
            simpa [Nat.mul_comm] using this
          exact h1.trans h2
        exact hle.trans_lt hlarge)
    omega
  have hat : a * t = p * u + v := by
    dsimp [u, v]
    exact (Nat.div_add_mod (a * t) p).symm
  have hqt : q * t = v + p * (t + u) := by
    rw [hqeq]
    nlinarith [hat]

  have hab_sq : a * (a + c) ≤ (a + c) ^ 2 := by
    have hm := Nat.mul_le_mul (by omega : a ≤ a + c) (by omega : a + c ≤ a + c)
    simpa [pow_two] using hm
  have hsq_cube : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
    Nat.pow_le_pow_right hb (by omega)
  have hab_lt_p : a * (a + c) < p :=
    hab_sq.trans_lt (hsq_cube.trans_lt (hcube4.trans_lt hlarge))
  have hmid_lt_p : a + (a + c) < p := by
    have h2b : 2 * (a + c) ≤ 4 * (a + c) ^ 3 := by
      have h1 : 2 * (a + c) ≤ 2 * (a + c) ^ 3 :=
        Nat.mul_le_mul_left 2 hb_le_cube
      have h2 : 2 * (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
        have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 2 ≤ 4)
        simpa [Nat.mul_comm] using this
      exact h1.trans h2
    omega
  have hqrNorm :
      q * r = a * (a + c) + p * ((a + (a + c)) + p) := by
    rw [hqeq, hreq, hqeq]
    ring
  have hqrMod : (q * r) % p = a * (a + c) := by
    rw [hqrNorm]
    exact (norm2pq p (a * (a + c)) ((a + (a + c)) + p)
      hp.pos hab_lt_p).1
  have hqrDiv : (q * r) / p = (a + (a + c)) + p := by
    rw [hqrNorm]
    exact (norm2pq p (a * (a + c)) ((a + (a + c)) + p)
      hp.pos hab_lt_p).2
  have hqrSecond : ((q * r) / p) % p = a + (a + c) := by
    rw [hqrDiv]
    simpa [Nat.mod_eq_of_lt hmid_lt_p] using Nat.add_mod_right (a + (a + c)) p
  have hqtMod : (q * t) % p = v := by
    rw [hqt]
    exact (norm2pq p v (t + u) hp.pos hvp).1
  have hqtDiv : (q * t) / p = t + u := by
    rw [hqt]
    exact (norm2pq p v (t + u) hp.pos hvp).2
  have htu : t + u ≤ a + (a + c) := by
    have h := hpDigits.2
    rw [hqtDiv, Nat.mod_eq_of_lt ht_u_lt_p, hqrSecond] at h
    exact h
  have ht_mid : t ≤ a + (a + c) := (Nat.le_add_right t u).trans htu
  have hat_lt_p : a * t < p := by
    have hle : a * t ≤ a * (a + (a + c)) :=
      Nat.mul_le_mul_left a ht_mid
    have hbound : a * (a + (a + c)) ≤ 2 * (a + c) ^ 2 := by
      have h1 : a ≤ a + c := by omega
      have h2 : a + (a + c) ≤ 2 * (a + c) := by omega
      have hm := Nat.mul_le_mul h1 h2
      nlinarith
    have h2sq : 2 * (a + c) ^ 2 ≤ 4 * (a + c) ^ 3 := by
      have hpw := Nat.mul_le_mul_left 2 hsq_cube
      have hd : 2 * (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
        have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 2 ≤ 4)
        simpa [Nat.mul_comm] using this
      exact hpw.trans hd
    exact (hle.trans hbound).trans_lt (h2sq.trans_lt hlarge)
  have hvEq : v = a * t := by
    dsimp [v]
    exact Nat.mod_eq_of_lt hat_lt_p
  have hvle : v ≤ a * (a + c) := by
    have h := hpDigits.1
    rw [hqtMod, hqrMod] at h
    exact h
  have ht_le_b : t ≤ a + c := by
    rw [hvEq] at hvle
    exact Nat.le_of_mul_le_mul_left hvle ha

  have hqDivK : k / q = p * t := by
    rw [hkt']
    simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
      Nat.mul_div_cancel_left (p * t) hq.pos
  have hqDivN : (p * q * r) / q = p * r := by
    simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
      Nat.mul_div_cancel_left (p * r) hq.pos
  have hqStep := (lucas_step_not_dvd q (p * q * r) k hq hqC).2
  have hqDigits :
      (p * t) % q ≤ (p * r) % q ∧
      ((p * t) / q) % q ≤ ((p * r) / q) % q := by
    simpa [hqDivK, hqDivN] using
      lucas_two_digits_le q ((p * q * r) / q) (k / q) hq hqStep

  have hat_lt_q : a * t < q := hat_lt_p.trans hpq
  have hp_as_sub : p = q - a := by omega
  have hptNorm : p * t = (q - a * t) + q * (t - 1) := by
    rw [hp_as_sub]
    exact below_mul_pq q a t (by omega) hat_lt_q.le (by omega)
  have hptMod : (p * t) % q = q - a * t := by
    rw [hptNorm]
    exact (norm2pq q (q - a * t) (t - 1) hq.pos
      (Nat.sub_lt (by omega) (Nat.mul_pos ha ht))).1
  have hptDiv : (p * t) / q = t - 1 := by
    rw [hptNorm]
    exact (norm2pq q (q - a * t) (t - 1) hq.pos
      (Nat.sub_lt (by omega) (Nat.mul_pos ha ht))).2

  have hac_lt_q : a * c < q := by
    have hle : a * c ≤ a * (a + c) :=
      Nat.mul_le_mul_left a (by omega)
    exact (hle.trans_lt hab_lt_p).trans hpq
  have hgap : a + 1 ≤ c := by omega
  have hprNorm :
      p * r = (q - a * c) + q * ((c - a - 1) + q) := by
    rw [hp_as_sub, hreq]
    exact pr_q_expansion_pq q a c (by omega) hac_lt_q.le hgap
  have hlo : q - a * c < q :=
    Nat.sub_lt hq.pos (Nat.mul_pos ha (by omega))
  have hprMod : (p * r) % q = q - a * c := by
    rw [hprNorm]
    exact (norm2pq q (q - a * c) ((c - a - 1) + q) hq.pos hlo).1
  have hprDiv : (p * r) / q = (c - a - 1) + q := by
    rw [hprNorm]
    exact (norm2pq q (q - a * c) ((c - a - 1) + q) hq.pos hlo).2
  have hprSecond : ((p * r) / q) % q = c - a - 1 := by
    rw [hprDiv]
    have hm : c - a - 1 < q := by omega
    simpa [Nat.mod_eq_of_lt hm] using Nat.add_mod_right (c - a - 1) q
  have hlow := hqDigits.1
  rw [hptMod, hprMod] at hlow
  have hhigh := hqDigits.2
  rw [hptDiv, Nat.mod_eq_of_lt (by omega : t - 1 < q), hprSecond] at hhigh
  have hct : c ≤ t := by
    have hatac : a * c ≤ a * t := by omega
    exact Nat.le_of_mul_le_mul_left hatac ha
  omega

#print axioms Erdos700PNT.not_p_and_q_omitted

end Erdos700PNT
