import FormalConjectures.ErdosProblems.«700»

/-!
# Order-theoretic assembly for Erdős 700(ii)

This file isolates the `sInf` bookkeeping from the Lucas arithmetic. Once a
prime-triple proof supplies a uniform lower bound for every relevant gcd and
one witness attaining it, the exact value of `Erdos700.f` follows.
-/

namespace Erdos700PNT

lemma f_eq_of_gcd_lower_and_witness
    (n d witness : ℕ)
    (hw1 : 1 < witness)
    (hw2 : witness ≤ n / 2)
    (hwgcd : Nat.gcd n (n.choose witness) = d)
    (hlower : ∀ k, 1 < k → k ≤ n / 2 → d ≤ Nat.gcd n (n.choose k)) :
    Erdos700.f n = d := by
  apply Nat.le_antisymm
  · simpa [hwgcd] using Erdos700.f_le n witness hw1 hw2
  · have hne : (Erdos700.fSet n).Nonempty :=
      ⟨Nat.gcd n (n.choose witness), Erdos700.f_mem n witness hw1 hw2⟩
    obtain ⟨k, hk1, hk2, hkeq⟩ := Nat.sInf_mem hne
    rw [Erdos700.f_eq, hkeq]
    exact hlower k hk1 hk2

lemma f_square_gt_of_all_gcd_square_gt
    (n witness : ℕ)
    (hw1 : 1 < witness)
    (hw2 : witness ≤ n / 2)
    (hlower : ∀ k, 1 < k → k ≤ n / 2 →
      n < (Nat.gcd n (n.choose k)) ^ 2) :
    n < (Erdos700.f n) ^ 2 := by
  have hne : (Erdos700.fSet n).Nonempty :=
    ⟨Nat.gcd n (n.choose witness), Erdos700.f_mem n witness hw1 hw2⟩
  obtain ⟨k, hk1, hk2, hkeq⟩ := Nat.sInf_mem hne
  rw [Erdos700.f_eq, hkeq]
  exact hlower k hk1 hk2

lemma product_le_gcd_of_two_prime_pairs
    (p q r C : ℕ) (hC : 0 < C) (hp : p ≤ q) (hqr : q ≤ r)
    (hpq : p * q ∣ C ∨ p * r ∣ C ∨ q * r ∣ C) :
    p * q ≤ C := by
  rcases hpq with hpq | hpr | hqr'
  · exact Nat.le_of_dvd hC hpq
  · have hpr_le : p * r ≤ C := Nat.le_of_dvd hC hpr
    exact (Nat.mul_le_mul_left p hqr).trans hpr_le
  · have hqr_le : q * r ≤ C := Nat.le_of_dvd hC hqr'
    exact (Nat.mul_le_mul hp hqr).trans hqr_le

lemma square_gt_of_f_eq
    (n p q : ℕ) (hf : Erdos700.f n = p * q) (h : n < (p * q) ^ 2) :
    n < (Erdos700.f n) ^ 2 := by
  simpa [hf] using h

lemma gcd_square_of_pairwise_not_omitted
    (p q r a c C : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (not_pq : ¬(¬p ∣ C ∧ ¬q ∣ C))
    (not_pr : ¬(¬p ∣ C ∧ ¬r ∣ C))
    (not_qr : ¬(¬q ∣ C ∧ ¬r ∣ C)) :
    p * q * r < (Nat.gcd (p * q * r) C) ^ 2 := by
  have hpq : p < q := by omega
  have hqr : q < r := by omega
  have hnpos : 0 < p * q * r :=
    Nat.mul_pos (Nat.mul_pos hp.pos hq.pos) hr.pos
  have hgpos : 0 < Nat.gcd (p * q * r) C :=
    Nat.gcd_pos_of_pos_left C hnpos
  have hgle : p * q ≤ Nat.gcd (p * q * r) C := by
    by_cases hpC : p ∣ C
    · by_cases hqC : q ∣ C
      · have hpqC : p * q ∣ C :=
          Nat.Coprime.mul_dvd_of_dvd_of_dvd
            ((Nat.coprime_primes hp hq).2 (by omega)) hpC hqC
        exact Nat.le_of_dvd hgpos (Nat.dvd_gcd ⟨r, rfl⟩ hpqC)
      · have hrC : r ∣ C := by
          by_contra hrC
          exact not_qr ⟨hqC, hrC⟩
        have hprC : p * r ∣ C :=
          Nat.Coprime.mul_dvd_of_dvd_of_dvd
            ((Nat.coprime_primes hp hr).2 (by omega)) hpC hrC
        have hprg : p * r ∣ Nat.gcd (p * q * r) C :=
          Nat.dvd_gcd ⟨q, by ring⟩ hprC
        exact (Nat.mul_le_mul_left p hqr.le).trans (Nat.le_of_dvd hgpos hprg)
    · have hqC : q ∣ C := by
        by_contra hqC
        exact not_pq ⟨hpC, hqC⟩
      have hrC : r ∣ C := by
        by_contra hrC
        exact not_pr ⟨hpC, hrC⟩
      have hqrC : q * r ∣ C :=
        Nat.Coprime.mul_dvd_of_dvd_of_dvd
          ((Nat.coprime_primes hq hr).2 (by omega)) hqC hrC
      have hqrg : q * r ∣ Nat.gcd (p * q * r) C :=
        Nat.dvd_gcd ⟨p, by ring⟩ hqrC
      exact (Nat.mul_le_mul hpq.le hqr.le).trans (Nat.le_of_dvd hgpos hqrg)
  have hbpos : 0 < a + c := by omega
  have hb_lt_p : a + c < p := by
    have hb_le_cube : a + c ≤ (a + c) ^ 3 := Nat.le_self_pow (by omega) _
    omega
  have hr_lt_p2 : r < p * 2 := by omega
  have hp2_le_pq : p * 2 ≤ p * q := Nat.mul_le_mul_left p hq.two_le
  have hr_lt_pq : r < p * q := hr_lt_p2.trans_le hp2_le_pq
  have hsmall : p * q * r < (p * q) ^ 2 := by
    rw [pow_two]
    exact (Nat.mul_lt_mul_left (Nat.mul_pos hp.pos hq.pos)).2 hr_lt_pq
  have hsquares : (p * q) ^ 2 ≤ (Nat.gcd (p * q * r) C) ^ 2 := by
    simpa [pow_two] using Nat.mul_le_mul hgle hgle
  exact hsmall.trans_le hsquares

lemma prime_triple_f_square_gt_of_pairwise_not_omitted
    (p q r a c : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p)
    (homission : ∀ k, 1 < k → k ≤ (p * q * r) / 2 →
      ¬(¬p ∣ (p * q * r).choose k ∧ ¬q ∣ (p * q * r).choose k) ∧
      ¬(¬p ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k) ∧
      ¬(¬q ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k)) :
    p * q * r < (Erdos700.f (p * q * r)) ^ 2 := by
  have hr1 : 1 < r := hr.one_lt
  have hpq2 : 2 ≤ p * q := by
    have hp2 := hp.two_le
    have hq1 := hq.one_lt
    nlinarith
  have hrhalf : r ≤ (p * q * r) / 2 := by
    have htwor : 2 * r ≤ p * q * r := by
      calc
        2 * r ≤ (p * q) * r := Nat.mul_le_mul_right r hpq2
        _ = p * q * r := rfl
    omega
  apply f_square_gt_of_all_gcd_square_gt (p * q * r) r hr1 hrhalf
  intro k hk1 hk2
  obtain ⟨hpq, hpr, hqr⟩ := homission k hk1 hk2
  exact gcd_square_of_pairwise_not_omitted
    p q r a c ((p * q * r).choose k) hp hq hr hqeq hreq ha hac hlarge hpq hpr hqr

end Erdos700PNT

#print axioms Erdos700PNT.f_eq_of_gcd_lower_and_witness
#print axioms Erdos700PNT.f_square_gt_of_all_gcd_square_gt
#print axioms Erdos700PNT.product_le_gcd_of_two_prime_pairs
#print axioms Erdos700PNT.square_gt_of_f_eq
#print axioms Erdos700PNT.gcd_square_of_pairwise_not_omitted
#print axioms Erdos700PNT.prime_triple_f_square_gt_of_pairwise_not_omitted
