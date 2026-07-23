import Assembly
import Target

/-!
# Exact reduction of Erdős 700(ii) to unbounded structured prime triples

This theorem packages the final quantifiers.  The remaining proof-producing
modules only need to supply unbounded triples and the three simultaneous
Lucas-omission contradictions.
-/

namespace Erdos700PNT

theorem exact_erdos_700_ii_of_unbounded_prime_triples
    (htriples : ∀ B : ℕ, ∃ p q r a c : ℕ,
      p.Prime ∧ q.Prime ∧ r.Prime ∧
      q = p + a ∧ r = q + c ∧
      0 < a ∧ a < c ∧
      4 * (a + c) ^ 3 < p ∧
      B < p * q * r ∧
      ∀ k, 1 < k → k ≤ (p * q * r) / 2 →
        ¬(¬p ∣ (p * q * r).choose k ∧ ¬q ∣ (p * q * r).choose k) ∧
        ¬(¬p ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k) ∧
        ¬(¬q ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k)) :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite := by
  apply exact_erdos_700_ii_target_of_unbounded
  intro B
  obtain ⟨p, q, r, a, c, hp, hq, hr, hqeq, hreq, ha, hac, hlarge,
    hB, homission⟩ := htriples B
  have hnprime : ¬(p * q * r).Prime := by
    intro hn
    have hpdiv : p ∣ p * q * r := ⟨q * r, by ring⟩
    have heq : p = p * q * r :=
      (Nat.prime_dvd_prime_iff_eq hp hn).1 hpdiv
    have hq2 := hq.two_le
    have hr2 := hr.two_le
    have heq' : p * 1 = p * (q * r) := by
      simpa [Nat.mul_assoc] using heq
    have hqr1 : 1 = q * r := Nat.mul_left_cancel hp.pos heq'
    have hfour : 4 ≤ q * r := by
      simpa using Nat.mul_le_mul hq2 hr2
    omega
  have hn1 : 1 < p * q * r := by
    have hnpos : 0 < p * q * r :=
      Nat.mul_pos (Nat.mul_pos hp.pos hq.pos) hr.pos
    have hpdiv : p ∣ p * q * r := ⟨q * r, by ring⟩
    exact hp.one_lt.trans_le (Nat.le_of_dvd hnpos hpdiv)
  have hsquare :=
    prime_triple_f_square_gt_of_pairwise_not_omitted
      p q r a c hp hq hr hqeq hreq ha hac hlarge homission
  exact ⟨p * q * r, hnprime, hn1, hsquare, hB⟩

end Erdos700PNT

#print axioms Erdos700PNT.exact_erdos_700_ii_of_unbounded_prime_triples
