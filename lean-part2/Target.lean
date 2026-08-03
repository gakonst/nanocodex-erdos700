import FormalConjectures.ErdosProblems.«700»

/-!
# Exact solved-side target for Erdős 700(ii)

The upstream conjecture wraps the mathematical assertion in an unspecified
answer placeholder.  A solution should prove the right-hand set infinite
directly; it must not use the open equivalence theorem.
-/

namespace Erdos700PNT

def target : Set ℕ :=
  {n : ℕ | ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}

theorem target_infinite_of_unbounded
    (h : ∀ B : ℕ, ∃ n : ℕ, n ∈ target ∧ B < n) :
    target.Infinite := by
  exact Set.infinite_of_forall_exists_gt h

theorem exact_erdos_700_ii_target_of_unbounded
    (h : ∀ B : ℕ, ∃ n : ℕ,
      ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n ∧ B < n) :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite := by
  apply target_infinite_of_unbounded
  intro B
  obtain ⟨n, hnprime, hn1, hnf, hBn⟩ := h B
  exact ⟨n, ⟨hnprime, hn1, hnf⟩, hBn⟩

end Erdos700PNT

#print axioms Erdos700PNT.target_infinite_of_unbounded
#print axioms Erdos700PNT.exact_erdos_700_ii_target_of_unbounded
