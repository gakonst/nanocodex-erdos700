import CoreHelpers

/-!
# The `p,r` simultaneous-omission contradiction

This is one of the three problem-specific Lucas digit arguments in the
prime-triple structural lemma for Erdős 700.
-/

namespace Erdos700PNT

set_option maxHeartbeats 1000000

private lemma normalized_two_digits (P lo hi : ℕ) (hP : 0 < P) (hlo : lo < P) :
    (lo + P * hi) % P = lo ∧ (lo + P * hi) / P = hi := by
  constructor
  · simpa [Nat.mod_eq_of_lt hlo] using Nat.add_mul_mod_self_left lo P hi
  · simpa [Nat.div_eq_of_lt hlo] using Nat.add_mul_div_left lo hi hP

private lemma pair_quotient_le_half
    (P Q R t : ℕ) (hP : 0 < P) (hQ : 0 < Q)
    (h : P * Q * t ≤ (P * Q * R) / 2) :
    t ≤ R / 2 := by
  have htwice : (P * Q * t) * 2 ≤ P * Q * R :=
    (Nat.le_div_iff_mul_le (by omega : 0 < 2)).1 h
  have hcancel : t * 2 ≤ R := by
    apply Nat.le_of_mul_le_mul_left (c := P * Q)
    · simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using htwice
    · exact Nat.mul_pos hP hQ
  exact (Nat.le_div_iff_mul_le (by omega : 0 < 2)).2 hcancel

private lemma below_base_mul_expansion
    (R d t : ℕ) (hdR : d ≤ R) (hdtR : d * t ≤ R) (ht : 1 ≤ t) :
    (R - d) * t = (R - d * t) + R * (t - 1) := by
  nlinarith [Nat.sub_add_cancel hdR, Nat.sub_add_cancel hdtR,
    Nat.sub_add_cancel ht]

private lemma pq_near_base_expansion
    (p a c : ℕ) (hcp : c ≤ p) :
    p * (p + a) = (a + c) * c + (p + a + c) * (p - c) := by
  nlinarith [Nat.sub_add_cancel hcp]

/-- Under the prime-triple gap hypotheses, `p` and `r` cannot both be absent
from the binomial coefficient in the defining half-range. -/
theorem not_p_and_r_omitted
    (p q r a c k : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (hk1 : 1 < k) (hk2 : k ≤ (p * q * r) / 2) :
    ¬ (¬ p ∣ (p * q * r).choose k ∧ ¬ r ∣ (p * q * r).choose k) := by
  rintro ⟨hpC, hrC⟩
  have hpq : p < q := by omega
  have hqr : q < r := by omega
  have hpr : p ≠ r := by omega
  have hpk : p ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose p (p * q * r) k hp
      ⟨q * r, by ring⟩ hpC
  have hrk : r ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose r (p * q * r) k hr
      ⟨p * q, by ring⟩ hrC
  have hprk : p * r ∣ k :=
    ((Nat.coprime_primes hp hr).2 hpr).mul_dvd_of_dvd_of_dvd hpk hrk
  obtain ⟨t, hkt⟩ := hprk
  have ht : 0 < t := by
    by_contra ht0
    have : t = 0 := by omega
    subst t
    simp at hkt
    omega
  have hkt' : k = p * r * t := hkt
  have htq : t ≤ q / 2 := by
    apply pair_quotient_le_half p r q t hp.pos hr.pos
    simpa [hkt', Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using hk2

  have hb : 0 < a + c := by omega
  have hb_le_cube : a + c ≤ (a + c) ^ 3 :=
    Nat.le_self_pow (by omega : 3 ≠ 0) (a + c)
  have hb_lt_p : a + c < p := by
    have hcubelt : (a + c) ^ 3 < 4 * (a + c) ^ 3 := by
      nlinarith [pow_pos hb 3]
    exact hb_le_cube.trans_lt (hcubelt.trans hlarge)
  have hc_lt_p : c < p := by omega
  have ha_lt_p : a < p := by omega
  have ht_lt_p : t < p := by
    rw [hqeq] at htq
    omega

  -- Lucas in base p compares `r*t` against `q*r`.
  have hpDivK : k / p = r * t := by
    rw [hkt']
    simpa [Nat.mul_assoc] using Nat.mul_div_cancel_left (r * t) hp.pos
  have hpDivN : (p * q * r) / p = q * r := by
    simpa [Nat.mul_assoc] using Nat.mul_div_cancel_left (q * r) hp.pos
  have hpDigits :
      (r * t) % p ≤ (q * r) % p ∧
      ((r * t) / p) % p ≤ ((q * r) / p) % p := by
    have hdiv :=
      (lucas_step_not_dvd p (p * q * r) k hp hpC).2
    simpa [hpDivK, hpDivN] using
      (lucas_two_digits_le p ((p * q * r) / p) (k / p) hp hdiv)

  let u := (a + c) * t / p
  let v := (a + c) * t % p
  have hvp : v < p := Nat.mod_lt _ hp.pos
  have hat_lt : (a + c) * t < (a + c) * p :=
    Nat.mul_lt_mul_of_pos_left ht_lt_p hb
  have hu_lt : u < a + c := by
    exact (Nat.div_lt_iff_lt_mul hp.pos).2 (by
      simpa [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using hat_lt)
  have ht_u_lt_p : t + u < p := by
    have hu_le : u ≤ a + c - 1 := by omega
    rw [hqeq] at htq
    have hsmall : a + 2 * (a + c) < p := by
      have : 3 * (a + c) < p := by
        have hb3 : 3 * (a + c) ≤ 4 * (a + c) ^ 3 := by
          nlinarith [hb_le_cube]
        exact hb3.trans_lt hlarge
      omega
    omega

  have hbt : (a + c) * t = p * u + v := by
    dsimp [u, v]
    exact (Nat.div_add_mod ((a + c) * t) p).symm
  have hrt : r * t = v + p * (t + u) := by
    rw [hreq, hqeq]
    nlinarith [hbt]

  have hab_lt_p : a * (a + c) < p := by
    have haa : a ≤ a + c := by omega
    have hprod : a * (a + c) ≤ (a + c) * (a + c) :=
      Nat.mul_le_mul_right (a + c) haa
    have hsquare : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
      Nat.pow_le_pow_right hb (by omega)
    have hcubep : (a + c) ^ 3 < p :=
      lt_trans (by nlinarith [pow_pos hb 3]) hlarge
    have hprod' : a * (a + c) ≤ (a + c) ^ 2 := by
      simpa [pow_two] using hprod
    exact hprod'.trans_lt (hsquare.trans_lt hcubep)
  have habmid_lt_p : a + (a + c) < p := by
    have : 2 * (a + c) < p := by
      have h2 : 2 * (a + c) ≤ 4 * (a + c) ^ 3 := by
        nlinarith [hb_le_cube]
      exact h2.trans_lt hlarge
    omega
  have hqrExpansion :
      q * r = a * (a + c) + p * ((a + (a + c)) + p) := by
    rw [hqeq, hreq, hqeq]
    ring
  have hqrMod : (q * r) % p = a * (a + c) := by
    rw [hqrExpansion]
    exact (normalized_two_digits p (a * (a + c)) ((a + (a + c)) + p)
      hp.pos hab_lt_p).1
  have hqrDiv :
      (q * r) / p = (a + (a + c)) + p := by
    rw [hqrExpansion]
    exact (normalized_two_digits p (a * (a + c)) ((a + (a + c)) + p)
      hp.pos hab_lt_p).2
  have hqrSecond : ((q * r) / p) % p = a + (a + c) := by
    rw [hqrDiv]
    simpa [Nat.mod_eq_of_lt habmid_lt_p] using
      Nat.add_mod_right (a + (a + c)) p

  have hrtMod : (r * t) % p = v := by
    rw [hrt]
    exact (normalized_two_digits p v (t + u) hp.pos hvp).1
  have hrtDiv : (r * t) / p = t + u := by
    rw [hrt]
    exact (normalized_two_digits p v (t + u) hp.pos hvp).2
  have htu : t + u ≤ a + (a + c) := by
    have := hpDigits.2
    rw [hrtDiv, Nat.mod_eq_of_lt ht_u_lt_p, hqrSecond] at this
    exact this
  have ht_small : t ≤ a + (a + c) :=
    (Nat.le_add_right t u).trans htu
  have hbt_lt_p : (a + c) * t < p := by
    have hmul : (a + c) * t ≤ (a + c) * (a + (a + c)) :=
      Nat.mul_le_mul_left (a + c) ht_small
    have hbound : (a + c) * (a + (a + c)) < p := by
      have : (a + c) * (a + (a + c)) ≤ 2 * (a + c) ^ 2 := by
        nlinarith
      have : 2 * (a + c) ^ 2 < 4 * (a + c) ^ 3 := by
        nlinarith [hb]
      omega
    exact hmul.trans_lt hbound
  have hu0 : u = 0 := by
    dsimp [u]
    exact Nat.div_eq_of_lt hbt_lt_p
  have hvEq : v = (a + c) * t := by
    dsimp [v]
    exact Nat.mod_eq_of_lt hbt_lt_p
  have hvle : v ≤ a * (a + c) := by
    have := hpDigits.1
    rw [hrtMod, hqrMod] at this
    exact this
  have ht_le_a : t ≤ a := by
    rw [hvEq] at hvle
    apply Nat.le_of_mul_le_mul_left (c := a + c)
    · simpa [Nat.mul_comm] using hvle
    · exact hb

  -- Lucas in base r compares `p*t` against `p*q`.
  have hrDivK : k / r = p * t := by
    rw [hkt']
    simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using
      Nat.mul_div_cancel_left (p * t) hr.pos
  have hrDivN : (p * q * r) / r = p * q := by
    exact Nat.mul_div_cancel (p * q) hr.pos
  have hrLow :
      (p * t) % r ≤ (p * q) % r := by
    have h := (lucas_two_digits_le r (p * q * r) k hr hrC).2
    simpa [hrDivK, hrDivN] using h

  have hbt_lt_r : (a + c) * t < r := by
    rw [hreq, hqeq]
    have hle : (a + c) * t ≤ (a + c) * a :=
      Nat.mul_le_mul_left (a + c) ht_le_a
    have hle' : (a + c) * t ≤ a * (a + c) := by
      simpa [Nat.mul_comm] using hle
    exact hle'.trans_lt (hab_lt_p.trans (by omega))
  have hp_as_sub : p = r - (a + c) := by omega
  have hptExpansion :
      p * t = (r - (a + c) * t) + r * (t - 1) := by
    rw [hp_as_sub]
    exact below_base_mul_expansion r (a + c) t
      (by omega) hbt_lt_r.le (by omega)
  have hptMod : (p * t) % r = r - (a + c) * t := by
    rw [hptExpansion]
    exact (normalized_two_digits r (r - (a + c) * t) (t - 1) hr.pos
      (Nat.sub_lt (by omega) (Nat.mul_pos hb ht))).1

  have hbc_lt_r : (a + c) * c < r := by
    rw [hreq, hqeq]
    have hc_le : c ≤ a + c := by omega
    have hbc_sq : (a + c) * c ≤ (a + c) ^ 2 := by
      simpa [pow_two] using Nat.mul_le_mul_left (a + c) hc_le
    have hsq_cube : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
      Nat.pow_le_pow_right hb (by omega)
    have hcube_four : (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
      have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 1 ≤ 4)
      simpa [Nat.mul_comm] using this
    have hsqp : (a + c) ^ 2 < p :=
      hsq_cube.trans_lt (hcube_four.trans_lt hlarge)
    exact hbc_sq.trans_lt (hsqp.trans (by omega))
  have hpqcExpansion :
      p * q = (a + c) * c + r * (p - c) := by
    rw [hqeq, hreq, hqeq]
    exact pq_near_base_expansion p a c hc_lt_p.le
  have hpqMod : (p * q) % r = (a + c) * c := by
    rw [hpqcExpansion]
    exact (normalized_two_digits r ((a + c) * c) (p - c) hr.pos hbc_lt_r).1

  rw [hptMod, hpqMod] at hrLow
  have hrUpper : r ≤ (a + c) * t + (a + c) * c := by
    omega
  have hsmallUpper :
      (a + c) * t + (a + c) * c ≤ (a + c) ^ 2 := by
    calc
      (a + c) * t + (a + c) * c = (a + c) * (t + c) := by ring
      _ ≤ (a + c) * (a + c) :=
        Nat.mul_le_mul_left (a + c) (Nat.add_le_add_right ht_le_a c)
      _ = (a + c) ^ 2 := by ring
  have hrLarge : (a + c) ^ 2 < r := by
    have hsq_cube : (a + c) ^ 2 ≤ (a + c) ^ 3 :=
      Nat.pow_le_pow_right hb (by omega)
    have hcube_four : (a + c) ^ 3 ≤ 4 * (a + c) ^ 3 := by
      have := Nat.mul_le_mul_right ((a + c) ^ 3) (by omega : 1 ≤ 4)
      simpa [Nat.mul_comm] using this
    exact hsq_cube.trans_lt (hcube_four.trans_lt (hlarge.trans (by omega)))
  omega

#print axioms Erdos700PNT.not_p_and_r_omitted

end Erdos700PNT
