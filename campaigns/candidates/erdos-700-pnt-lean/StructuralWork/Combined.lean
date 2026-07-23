import Assembly
import StructuralWork.PROmission
import StructuralWork.PQOmission
import StructuralWork.QROmission

/-!
# Complete structural theorem for Erdős 700

The three independently checked Lucas digit arguments are assembled into the
uniform omission theorem and then into the exact `f(n)^2 > n` conclusion.
-/

namespace Erdos700PNT

theorem prime_triple_pairwise_not_omitted
    (p q r a c : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p) :
    ∀ k, 1 < k → k ≤ (p * q * r) / 2 →
      ¬(¬p ∣ (p * q * r).choose k ∧ ¬q ∣ (p * q * r).choose k) ∧
      ¬(¬p ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k) ∧
      ¬(¬q ∣ (p * q * r).choose k ∧ ¬r ∣ (p * q * r).choose k) := by
  intro k hk1 hk2
  exact ⟨
    not_p_and_q_omitted p q r a c k hp hq hr hqeq hreq ha hac hlarge hk1 hk2,
    not_p_and_r_omitted p q r a c k hp hq hr hqeq hreq ha hac hlarge hk1 hk2,
    not_q_and_r_omitted p q r a c k hp hq hr hqeq hreq ha hac hlarge hk1 hk2⟩

theorem prime_triple_f_square_gt
    (p q r a c : ℕ)
    (hp : p.Prime) (hq : q.Prime) (hr : r.Prime)
    (hqeq : q = p + a) (hreq : r = q + c)
    (ha : 0 < a) (hac : a < c)
    (hlarge : 4 * (a + c) ^ 3 < p) :
    p * q * r < (Erdos700.f (p * q * r)) ^ 2 := by
  exact prime_triple_f_square_gt_of_pairwise_not_omitted
    p q r a c hp hq hr hqeq hreq ha hac hlarge
    (prime_triple_pairwise_not_omitted p q r a c hp hq hr
      hqeq hreq ha hac hlarge)

#print axioms Erdos700PNT.prime_triple_pairwise_not_omitted
#print axioms Erdos700PNT.prime_triple_f_square_gt

end Erdos700PNT
