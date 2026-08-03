import FormalConjectures.ErdosProblems.«700»

/-!
# Kernel-checked structural infrastructure for Erdős 700

This module isolates the reusable Lucas and gcd-assembly parts of the
prime-triple argument.  The three simultaneous-omission contradictions are
parameters of `gcd_sq_gt_of_pairwise_omission`; they are the remaining
problem-specific digit-arithmetic layer.
-/

namespace Erdos700.StructuralWork

/-- One Lucas step: nondivisibility forces both the low-digit inequality and
nondivisibility of the binomial formed from the quotients. -/
lemma lucas_step_not_dvd (P n k : ℕ) (hP : P.Prime)
    (h : ¬ P ∣ n.choose k) :
    k % P ≤ n % P ∧ ¬ P ∣ (n / P).choose (k / P) := by
  letI := Fact.mk hP
  have hmod : n.choose k ≡
      (n % P).choose (k % P) * (n / P).choose (k / P) [MOD P] :=
    Choose.choose_modEq_choose_mod_mul_choose_div_nat
  have hprod : ¬ P ∣
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

/-- The first two base-`P` digit inequalities, without introducing a digit
representation. -/
lemma lucas_two_digits_le (P n k : ℕ) (hP : P.Prime)
    (h : ¬ P ∣ n.choose k) :
    k % P ≤ n % P ∧ (k / P) % P ≤ (n / P) % P := by
  have h₁ := lucas_step_not_dvd P n k hP h
  have h₂ := lucas_step_not_dvd P (n / P) (k / P) hP h₁.2
  exact ⟨h₁.1, h₂.1⟩

/-- Iterated quotient nondivisibility, useful for accessing arbitrarily high
Lucas digits while keeping the proof representation-free. -/
lemma lucas_iterate_not_dvd (P n k j : ℕ) (hP : P.Prime)
    (h : ¬ P ∣ n.choose k) :
    ¬ P ∣ (n / P ^ j).choose (k / P ^ j) := by
  induction j generalizing n k with
  | zero =>
      simpa
  | succ j ih =>
      have hstep := (lucas_step_not_dvd P n k hP h).2
      have hrec := ih (n := n / P) (k := k / P) hstep
      simpa [pow_succ, Nat.div_div_eq_div_mul, Nat.mul_comm] using hrec

/-- Two distinct prime factors of `n` which are both absent from the binomial
must both divide the index, hence their product divides the index. -/
lemma pair_dvd_index_of_two_omissions
    (P Q n k : ℕ)
    (hP : P.Prime) (hQ : Q.Prime) (hPQ : P ≠ Q)
    (hPn : P ∣ n) (hQn : Q ∣ n)
    (hPC : ¬ P ∣ n.choose k) (hQC : ¬ Q ∣ n.choose k) :
    P * Q ∣ k := by
  have hPk := Erdos700.prime_dvd_of_not_dvd_choose P n k hP hPn hPC
  have hQk := Erdos700.prime_dvd_of_not_dvd_choose Q n k hQ hQn hQC
  exact ((Nat.coprime_primes hP hQ).2 hPQ).mul_dvd_of_dvd_of_dvd hPk hQk

/-- Cancelling a positive common pair from the half-range bound gives the
corresponding quotient bound. -/
lemma pair_quotient_le_half
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

/-- A shifted form of the two-digit Lucas interface for an upper argument
which visibly contains one factor of the prime. -/
lemma lucas_two_shift_bounds (P M k : ℕ) (hP : P.Prime)
    (h : ¬ P ∣ (P * M).choose k) :
    P ∣ k ∧
      (k / P) % P ≤ M % P ∧
      ((k / P) / P) % P ≤ (M / P) % P := by
  have hPk : P ∣ k :=
    Erdos700.prime_dvd_of_not_dvd_choose P (P * M) k hP ⟨M, rfl⟩ h
  have h₁ := lucas_step_not_dvd P (P * M) k hP h
  have hdiv : ¬ P ∣ M.choose (k / P) := by
    simpa [hP.ne_zero] using h₁.2
  exact ⟨hPk, (lucas_step_not_dvd P M (k / P) hP hdiv).1,
    (lucas_two_digits_le P M (k / P) hP hdiv).2⟩

/-- Quotient and remainder of a normalized two-digit expression. -/
lemma normalized_two_digits (P lo hi : ℕ) (hP : 0 < P) (hlo : lo < P) :
    (lo + P * hi) % P = lo ∧ (lo + P * hi) / P = hi := by
  constructor
  · simpa [Nat.mod_eq_of_lt hlo] using Nat.add_mul_mod_self_left lo P hi
  · simpa [Nat.div_eq_of_lt hlo] using Nat.add_mul_div_left lo hi hP

/-- Multiplication by a number just above the base, expressed through a small
correction.  This is the carry-normalization used in all three omission
arguments. -/
lemma above_base_mul_digits (P d t : ℕ) (hP : 0 < P) :
    ((P + d) * t) % P = (d * t) % P ∧
    ((P + d) * t) / P = t + (d * t) / P := by
  constructor
  · rw [add_mul]
    exact Nat.mul_add_mod_self_left P t (d * t)
  · rw [add_mul]
    exact Nat.mul_add_div hP t (d * t)

/-- Exact residue normalization for expressions congruent to `v - d*u`
modulo a nearby base.  This helper was harvested from the independent blind
architecture worker and checked here in the pinned integration project. -/
lemma near_base_dvd_forces_residue
    (P d u v : ℕ) (_hP : 0 < P) (hdu : d * u < P) (hv : v < P)
    (h : P ∣ (P - d) * u + v) (hdP : d ≤ P) :
    v = d * u := by
  obtain ⟨w, hw⟩ := h
  have hsub : P - d + d = P := Nat.sub_add_cancel hdP
  by_cases hu : u = 0
  · subst u
    simp only [mul_zero] at hw hdu ⊢
    have hw0 : w = 0 := by nlinarith
    simpa [hw0] using hw
  have hu0 : 0 < u := Nat.pos_of_ne_zero hu
  have hwu : w ≤ u := by
    by_contra hn
    have huw : u < w := by omega
    have hmul : P * (u + 1) ≤ P * w :=
      Nat.mul_le_mul_left P (by omega)
    rw [← hw] at hmul
    nlinarith
  have huw : u ≤ w := by
    by_contra hn
    have hwu' : w < u := by omega
    have hmul : P * (w + 1) ≤ P * u :=
      Nat.mul_le_mul_left P (by omega)
    have hmul' : P * w + P ≤ P * u := by
      simpa [Nat.mul_add] using hmul
    rw [← hw] at hmul'
    nlinarith [hsub]
  have hwu_eq : w = u := by omega
  subst w
  nlinarith [hsub]

/-- A prime divisor of both arguments divides their gcd; two coprime such
divisors may be multiplied. -/
lemma pair_mul_dvd_gcd {x y u v : ℕ} (huv : u.Coprime v)
    (hux : u ∣ x) (hvx : v ∣ x) (huy : u ∣ y) (hvy : v ∣ y) :
    u * v ∣ Nat.gcd x y := by
  exact Nat.dvd_gcd
    (huv.mul_dvd_of_dvd_of_dvd hux hvx)
    (huv.mul_dvd_of_dvd_of_dvd huy hvy)

/-- If no two of `p,q,r` can simultaneously be absent from `C`, and each
pair-product already has square greater than `n`, then the gcd has square
greater than `n`.

This packages the completely generic final case split, independently of the
Lucas digit arithmetic used to establish the three omission hypotheses.
-/
lemma gcd_sq_gt_of_pairwise_omission
    (n C p q r : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hn : 0 < n)
    (hpq : p ≠ q) (hpr : p ≠ r) (hqr : q ≠ r)
    (hpn : p ∣ n) (hqn : q ∣ n) (hrn : r ∣ n)
    (hnot_pq : ¬ (¬ p ∣ C ∧ ¬ q ∣ C))
    (hnot_pr : ¬ (¬ p ∣ C ∧ ¬ r ∣ C))
    (hnot_qr : ¬ (¬ q ∣ C ∧ ¬ r ∣ C))
    (hpq_sq : n < (p * q) ^ 2)
    (hpr_sq : n < (p * r) ^ 2)
    (hqr_sq : n < (q * r) ^ 2) :
    n < (Nat.gcd n C) ^ 2 := by
  have hpq_coprime : p.Coprime q := (Nat.coprime_primes hp hq).2 hpq
  have hpr_coprime : p.Coprime r := (Nat.coprime_primes hp hr).2 hpr
  have hqr_coprime : q.Coprime r := (Nat.coprime_primes hq hr).2 hqr
  have hgpos : 0 < Nat.gcd n C := Nat.gcd_pos_of_pos_left C hn
  by_cases hpC : p ∣ C
  · by_cases hqC : q ∣ C
    · have hd : p * q ∣ Nat.gcd n C :=
        pair_mul_dvd_gcd hpq_coprime hpn hqn hpC hqC
      have hle : p * q ≤ Nat.gcd n C := Nat.le_of_dvd hgpos hd
      exact hpq_sq.trans_le (Nat.pow_le_pow_left hle 2)
    · have hrC : r ∣ C := by
        by_contra h
        exact hnot_qr ⟨hqC, h⟩
      have hd : p * r ∣ Nat.gcd n C :=
        pair_mul_dvd_gcd hpr_coprime hpn hrn hpC hrC
      have hle : p * r ≤ Nat.gcd n C := Nat.le_of_dvd hgpos hd
      exact hpr_sq.trans_le (Nat.pow_le_pow_left hle 2)
  · have hqC : q ∣ C := by
      by_contra h
      exact hnot_pq ⟨hpC, h⟩
    have hrC : r ∣ C := by
      by_contra h
      exact hnot_pr ⟨hpC, h⟩
    have hd : q * r ∣ Nat.gcd n C :=
      pair_mul_dvd_gcd hqr_coprime hqn hrn hqC hrC
    have hle : q * r ≤ Nat.gcd n C := Nat.le_of_dvd hgpos hd
    exact hqr_sq.trans_le (Nat.pow_le_pow_left hle 2)

/-- The gap hypotheses put the three pair-product squares strictly above
`p*q*r`. -/
lemma pair_product_squares
    (p q r a c : ℕ)
    (hp : p.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p) :
    p * q * r < (p * q) ^ 2 ∧
    p * q * r < (p * r) ^ 2 ∧
    p * q * r < (q * r) ^ 2 := by
  have hp0 : 0 < p := hp.pos
  have hc : 0 < c := ha.trans hac
  subst q
  subst r
  have hb : 0 < a + c := by omega
  have hbcube : a + c ≤ (a + c) ^ 3 :=
    Nat.le_self_pow (by omega : 3 ≠ 0) (a + c)
  have hcubelt : (a + c) ^ 3 < 4 * (a + c) ^ 3 := by
    nlinarith [pow_pos hb 3]
  have hcp : c < p := calc
    c ≤ a + c := Nat.le_add_left c a
    _ ≤ (a + c) ^ 3 := hbcube
    _ < 4 * (a + c) ^ 3 := hcubelt
    _ < p := hlarge
  have hp2 : 2 ≤ p := hp.two_le
  have hr_lt_pq : p + a + c < p * (p + a) := by nlinarith
  have hq_lt_pr : p + a < p * (p + a + c) := by nlinarith
  have hp_lt_qr : p < (p + a) * (p + a + c) := by nlinarith
  constructor
  · rw [pow_two]
    nlinarith [Nat.mul_lt_mul_left (Nat.mul_pos hp0 (by omega : 0 < p + a)) |>.2
      hr_lt_pq]
  · constructor
    · rw [pow_two]
      nlinarith [Nat.mul_lt_mul_left
        (Nat.mul_pos hp0 (by omega : 0 < p + a + c)) |>.2 hq_lt_pr]
    · rw [pow_two]
      nlinarith [Nat.mul_lt_mul_left
        (Nat.mul_pos (by omega : 0 < p + a) (by omega : 0 < p + a + c)) |>.2
        hp_lt_qr]

/-- Final gcd-square theorem reduced exactly to the three simultaneous
omission contradictions. -/
lemma prime_triple_gcd_sq
    (p q r a c k : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (hnot_pq :
      ¬ (¬ p ∣ (p * q * r).choose k ∧ ¬ q ∣ (p * q * r).choose k))
    (hnot_pr :
      ¬ (¬ p ∣ (p * q * r).choose k ∧ ¬ r ∣ (p * q * r).choose k))
    (hnot_qr :
      ¬ (¬ q ∣ (p * q * r).choose k ∧ ¬ r ∣ (p * q * r).choose k)) :
    p * q * r < (Nat.gcd (p * q * r) ((p * q * r).choose k)) ^ 2 := by
  have hpq : p ≠ q := by omega
  have hpr : p ≠ r := by omega
  have hqr : q ≠ r := by omega
  obtain ⟨hpq_sq, hpr_sq, hqr_sq⟩ :=
    pair_product_squares p q r a c hp hqeq hreq ha hac hlarge
  apply gcd_sq_gt_of_pairwise_omission
    (n := p * q * r) (C := (p * q * r).choose k)
    (p := p) (q := q) (r := r)
    hp hq hr (Nat.mul_pos (Nat.mul_pos hp.pos hq.pos) hr.pos) hpq hpr hqr
  · exact ⟨q * r, by ring⟩
  · exact ⟨p * r, by ring⟩
  · exact ⟨p * q, by ring⟩
  · exact hnot_pq
  · exact hnot_pr
  · exact hnot_qr
  · exact hpq_sq
  · exact hpr_sq
  · exact hqr_sq

#print axioms Erdos700.StructuralWork.lucas_step_not_dvd
#print axioms Erdos700.StructuralWork.lucas_iterate_not_dvd
#print axioms Erdos700.StructuralWork.pair_dvd_index_of_two_omissions
#print axioms Erdos700.StructuralWork.pair_quotient_le_half
#print axioms Erdos700.StructuralWork.lucas_two_shift_bounds
#print axioms Erdos700.StructuralWork.normalized_two_digits
#print axioms Erdos700.StructuralWork.above_base_mul_digits
#print axioms Erdos700.StructuralWork.near_base_dvd_forces_residue
#print axioms Erdos700.StructuralWork.gcd_sq_gt_of_pairwise_omission
#print axioms Erdos700.StructuralWork.pair_product_squares
#print axioms Erdos700.StructuralWork.prime_triple_gcd_sq

end Erdos700.StructuralWork
