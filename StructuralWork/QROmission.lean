import CoreHelpers

/-! The `q,r` simultaneous-omission contradiction for Erdős 700. -/

namespace Erdos700PNT

set_option maxHeartbeats 1000000

private lemma norm2 (P lo hi : ℕ) (hP : 0 < P) (hlo : lo < P) :
    (lo + P * hi) % P = lo ∧ (lo + P * hi) / P = hi := by
  constructor
  · simpa [Nat.mod_eq_of_lt hlo] using Nat.add_mul_mod_self_left lo P hi
  · simpa [Nat.div_eq_of_lt hlo] using Nat.add_mul_div_left lo hi hP

private lemma quotient_half (P Q R t : ℕ) (hP : 0 < P) (hQ : 0 < Q)
    (h : P * Q * t ≤ (P * Q * R) / 2) : t ≤ R / 2 := by
  have h2 : (P * Q * t) * 2 ≤ P * Q * R :=
    (Nat.le_div_iff_mul_le (by omega : 0 < 2)).1 h
  have hc : t * 2 ≤ R := by
    apply Nat.le_of_mul_le_mul_left (c := P * Q)
    · simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using h2
    · exact Nat.mul_pos hP hQ
  exact (Nat.le_div_iff_mul_le (by omega : 0 < 2)).2 hc

private lemma below_mul (R d t : ℕ) (hdR : d ≤ R) (hdtR : d * t ≤ R)
    (ht : 1 ≤ t) :
    (R - d) * t = (R - d * t) + R * (t - 1) := by
  nlinarith [Nat.sub_add_cancel hdR, Nat.sub_add_cancel hdtR,
    Nat.sub_add_cancel ht]

private lemma pr_q_expansion (q a c : ℕ)
    (haq : a ≤ q) (hacq : a * c ≤ q) (hgap : a + 1 ≤ c) :
    (q - a) * (q + c) =
      (q - a * c) + q * ((c - a - 1) + q) := by
  have hqa : q - a + a = q := Nat.sub_add_cancel haq
  have hqac : q - a * c + a * c = q := Nat.sub_add_cancel hacq
  have hca : c - a + a = c := Nat.sub_add_cancel (by omega)
  have hca1 : c - a - 1 + 1 = c - a :=
    Nat.sub_add_cancel (by omega)
  nlinarith

private lemma pq_r_expansion (p a c : ℕ) (hcp : c ≤ p) :
    p * (p + a) = (a + c) * c + (p + a + c) * (p - c) := by
  nlinarith [Nat.sub_add_cancel hcp]

theorem not_q_and_r_omitted
    (p q r a c k : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (hk1 : 1 < k) (hk2 : k ≤ (p * q * r) / 2) :
    ¬ (¬ q ∣ (p * q * r).choose k ∧ ¬ r ∣ (p * q * r).choose k) := by
  rintro ⟨hqC, hrC⟩
  have hpq : p < q := by omega
  have hqr : q < r := by omega
  have hqrne : q ≠ r := by omega
  have hqk : q ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose q (p * q * r) k hq
      ⟨p * r, by ring⟩ hqC
  have hrk : r ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose r (p * q * r) k hr
      ⟨p * q, by ring⟩ hrC
  have hqrk : q * r ∣ k :=
    ((Nat.coprime_primes hq hr).2 hqrne).mul_dvd_of_dvd_of_dvd hqk hrk
  obtain ⟨t, hkt⟩ := hqrk
  have ht : 0 < t := by
    by_contra h
    have : t = 0 := by omega
    subst t
    simp at hkt
    omega
  have hkt' : k = q * r * t := hkt
  have htp : t ≤ p / 2 := by
    apply quotient_half q r p t hq.pos hr.pos
    simpa [hkt', Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using hk2

  have hb : 0 < a + c := by omega
  have hb_le_cube : a + c ≤ (a + c) ^ 3 :=
    Nat.le_self_pow (by omega : 3 ≠ 0) _
  have hb_lt_p : a + c < p := by
    have hcube4 : (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
      have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 1 ≤ 4)
      simpa [Nat.mul_comm] using this
    exact hb_le_cube.trans_lt (hcube4.trans_lt hlarge)
  have ht_lt_q : t < q := by omega
  have hcq : c < q := by omega
  have haq : a < q := by omega

  have hqDivK : k / q = r * t := by
    rw [hkt']
    simpa [Nat.mul_assoc] using Nat.mul_div_cancel_left (r * t) hq.pos
  have hqDivN : (p * q * r) / q = p * r := by
    simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
      Nat.mul_div_cancel_left (p * r) hq.pos
  have hqStep := (lucas_step_not_dvd q (p * q * r) k hq hqC).2
  have hqDigits :
      (r * t) % q ≤ (p * r) % q ∧
      ((r * t) / q) % q ≤ ((p * r) / q) % q := by
    simpa [hqDivK, hqDivN] using
      lucas_two_digits_le q ((p * q * r) / q) (k / q) hq hqStep

  let u := c * t / q
  let v := c * t % q
  have hvq : v < q := Nat.mod_lt _ hq.pos
  have hct_lt_cq : c * t < c * q :=
    Nat.mul_lt_mul_of_pos_left ht_lt_q (by omega)
  have hu_lt_c : u < c :=
    (Nat.div_lt_iff_lt_mul hq.pos).2 (by
      simpa [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using hct_lt_cq)
  have ht_u_lt_q : t + u < q := by
    have hu : u ≤ c - 1 := by omega
    have : p / 2 + c < q := by rw [hqeq]; omega
    omega
  have hct : c * t = q * u + v := by
    dsimp [u, v]
    exact (Nat.div_add_mod (c * t) q).symm
  have hrt : r * t = v + q * (t + u) := by
    rw [hreq]
    nlinarith [hct]

  have hac_le_sq : a * c ≤ (a + c) ^ 2 := by
    have ha' : a ≤ a + c := by omega
    have hc' : c ≤ a + c := by omega
    simpa [pow_two] using Nat.mul_le_mul ha' hc'
  have hsq_cube : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
    Nat.pow_le_pow_right hb (by omega)
  have hcube4 : (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
    have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 1 ≤ 4)
    simpa [Nat.mul_comm] using this
  have hac_lt_q : a * c < q :=
    hac_le_sq.trans_lt
      ((hsq_cube.trans_lt (hcube4.trans_lt hlarge)).trans hpq)
  have hgap : a + 1 ≤ c := by omega
  have hp_as_sub : p = q - a := by omega
  have hprNorm :
      p * r = (q - a * c) + q * ((c - a - 1) + q) := by
    rw [hp_as_sub, hreq]
    exact pr_q_expansion q a c haq.le hac_lt_q.le hgap
  have hloq : q - a * c < q := Nat.sub_lt hq.pos (Nat.mul_pos ha (by omega))
  have hprMod : (p * r) % q = q - a * c := by
    rw [hprNorm]
    exact (norm2 q (q - a * c) ((c - a - 1) + q) hq.pos hloq).1
  have hprDiv : (p * r) / q = (c - a - 1) + q := by
    rw [hprNorm]
    exact (norm2 q (q - a * c) ((c - a - 1) + q) hq.pos hloq).2
  have hprSecond : ((p * r) / q) % q = c - a - 1 := by
    rw [hprDiv]
    have hmid : c - a - 1 < q := by omega
    simpa [Nat.mod_eq_of_lt hmid] using Nat.add_mod_right (c - a - 1) q
  have hrtMod : (r * t) % q = v := by
    rw [hrt]
    exact (norm2 q v (t + u) hq.pos hvq).1
  have hrtDiv : (r * t) / q = t + u := by
    rw [hrt]
    exact (norm2 q v (t + u) hq.pos hvq).2
  have htu : t + u ≤ c - a - 1 := by
    have h := hqDigits.2
    rw [hrtDiv, Nat.mod_eq_of_lt ht_u_lt_q, hprSecond] at h
    exact h
  have htgap : t ≤ c - a - 1 := (Nat.le_add_right t u).trans htu
  have ht_le_c : t ≤ c := by omega

  have hrDivK : k / r = q * t := by
    rw [hkt']
    simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
      Nat.mul_div_cancel_left (q * t) hr.pos
  have hrDivN : (p * q * r) / r = p * q := Nat.mul_div_cancel (p * q) hr.pos
  have hrLow : (q * t) % r ≤ (p * q) % r := by
    have hstep := (lucas_step_not_dvd r (p * q * r) k hr hrC).2
    have h := (lucas_two_digits_le r ((p * q * r) / r) (k / r) hr hstep).1
    simpa [hrDivK, hrDivN] using h

  have hsq_r : (a + c) ^ 2 < r :=
    (hsq_cube.trans_lt (hcube4.trans_lt hlarge)).trans (by omega)
  have hct_lt_r : c * t < r := by
    have hle : c * t ≤ c * c := Nat.mul_le_mul_left c ht_le_c
    have hcc : c * c ≤ (a + c) ^ 2 := by
      have := Nat.mul_le_mul (by omega : c ≤ a + c) (by omega : c ≤ a + c)
      simpa [pow_two] using this
    exact hle.trans_lt (hcc.trans_lt hsq_r)
  have hq_as_sub : q = r - c := by omega
  have hqtNorm : q * t = (r - c * t) + r * (t - 1) := by
    rw [hq_as_sub]
    exact below_mul r c t (by omega) hct_lt_r.le (by omega)
  have hqtMod : (q * t) % r = r - c * t := by
    rw [hqtNorm]
    exact (norm2 r (r - c * t) (t - 1) hr.pos
      (Nat.sub_lt (by omega) (Nat.mul_pos (by omega) ht))).1

  have hcp : c < p := by omega
  have hbc_sq : (a + c) * c ≤ (a + c) ^ 2 := by
    simpa [pow_two] using Nat.mul_le_mul_left (a + c) (by omega : c ≤ a + c)
  have hbc_lt_r : (a + c) * c < r :=
    hbc_sq.trans_lt hsq_r
  have hpqNorm : p * q = (a + c) * c + r * (p - c) := by
    rw [hqeq, hreq, hqeq]
    exact pq_r_expansion p a c hcp.le
  have hpqMod : (p * q) % r = (a + c) * c := by
    rw [hpqNorm]
    exact (norm2 r ((a + c) * c) (p - c) hr.pos hbc_lt_r).1
  rw [hqtMod, hpqMod] at hrLow
  have hrUpper : r ≤ c * t + (a + c) * c := by omega
  have hupper : c * t + (a + c) * c ≤ 2 * (a + c) ^ 2 := by
    have hctsq : c * t ≤ (a + c) ^ 2 := by
      have hm := Nat.mul_le_mul (by omega : c ≤ a + c) (by omega : t ≤ a + c)
      simpa [pow_two] using hm
    have := Nat.add_le_add hctsq hbc_sq
    simpa [two_mul] using this
  have h2sq_lt_r : 2 * (a + c) ^ 2 < r := by
    have h2cube : 2 * (a + c) ^ 2 ≤ 4 * (a + c) ^ 3 := by
      have hpow : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
        Nat.pow_le_pow_right hb (by omega)
      have htwice := Nat.mul_le_mul_left 2 hpow
      have hdouble : 2 * (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
        have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 2 ≤ 4)
        simpa [Nat.mul_comm] using this
      exact htwice.trans hdouble
    exact h2cube.trans_lt (hlarge.trans (by omega))
  omega

#print axioms Erdos700PNT.not_q_and_r_omitted

end Erdos700PNT
