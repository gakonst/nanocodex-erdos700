import PackingWork.PrimeBoxes
import Reduction
import StructuralWork.Combined

/-!
# Complete formal solution of Erdős 700(ii)

The PNT packing theorem supplies unbounded asymmetric prime triples.  Their
gap geometry implies the cubic largeness hypothesis, the structural Lucas
theorem supplies the binomial-coefficient divisibility property, and the
order-theoretic reduction proves the exact solved-side infinitude statement.
-/

open Filter

namespace Erdos700PNT

theorem unbounded_structured_prime_triples :
    ∀ B : ℕ, ∃ p q r a c : ℕ,
      p.Prime ∧ q.Prime ∧ r.Prime ∧
      q = p + a ∧ r = q + c ∧
      0 < a ∧ a < c ∧
      4 * (a + c) ^ 3 < p ∧
      B < p * q * r := by
  intro B
  obtain ⟨T₀, hT₀⟩ :=
    (eventually_atTop.1 PackingWork.eventually_exists_asymmetric_prime_triple)
  let T := max (B + 1) (max T₀ 1)
  have hT₀T : T₀ ≤ T := by simp [T]
  obtain ⟨p, q, r, hp, hq, hr, hNp, hpq, hqr, hasym, hspan⟩ :=
    hT₀ T hT₀T
  let a := q - p
  let c := r - q
  have hTpos : 0 < T := by simp [T]
  have hBT : B < T := by
    dsimp [T]
    omega
  have hqa : q = p + a := by
    dsimp [a]
    omega
  have hrc : r = q + c := by
    dsimp [c]
    omega
  have ha : 0 < a := by
    dsimp [a]
    omega
  have hac : a < c := by
    dsimp [a, c]
    exact hasym
  have hgap : a + c = r - p := by
    dsimp [a, c]
    omega
  have hbT : a + c < T := by
    rw [hgap]
    exact hspan
  have hpow : (a + c) ^ 3 < T ^ 3 := by
    gcongr
  have hTcube : 0 < T ^ 3 := pow_pos hTpos 3
  have hlarge : 4 * (a + c) ^ 3 < p := by
    have h4 : 4 * (a + c) ^ 3 < 8 * T ^ 3 := by
      nlinarith
    exact h4.trans_le hNp
  have hT_le_cube : T ≤ T ^ 3 := Nat.le_self_pow (by omega) T
  have hBp : B < p := by
    have hT_le_N : T ≤ 8 * T ^ 3 := by nlinarith
    exact hBT.trans_le (hT_le_N.trans hNp)
  have hnpos : 0 < p * q * r :=
    Nat.mul_pos (Nat.mul_pos hp.pos hq.pos) hr.pos
  have hpdiv : p ∣ p * q * r := ⟨q * r, by ring⟩
  have hBprod : B < p * q * r :=
    hBp.trans_le (Nat.le_of_dvd hnpos hpdiv)
  exact ⟨p, q, r, a, c, hp, hq, hr, hqa, hrc, ha, hac, hlarge, hBprod⟩

/-- The solved mathematical side of Formal Conjectures' Erdős 700(ii). -/
theorem erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite := by
  apply exact_erdos_700_ii_of_unbounded_prime_triples
  intro B
  obtain ⟨p, q, r, a, c, hp, hq, hr, hqeq, hreq, ha, hac, hlarge, hB⟩ :=
    unbounded_structured_prime_triples B
  exact ⟨p, q, r, a, c, hp, hq, hr, hqeq, hreq, ha, hac, hlarge, hB,
    prime_triple_pairwise_not_omitted p q r a c hp hq hr
      hqeq hreq ha hac hlarge⟩

#print axioms unbounded_structured_prime_triples
#print axioms erdos_700_ii

end Erdos700PNT
