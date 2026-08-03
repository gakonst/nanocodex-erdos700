import Mathlib.Combinatorics.Pigeonhole

/-!
# Packing a finite set into equal half-open intervals

This file separates the finite pigeonhole step from the analytic prime-counting
input.  No primality assumption is needed here.
-/

namespace Erdos700PNT.PackingWork

/-- A generic finite-set pigeonhole lemma with `B` explicitly numbered bins. -/
theorem exists_large_numbered_bin
    (s : Finset ℕ) (bin : ℕ → ℕ) (B K : ℕ)
    (hbin : ∀ n ∈ s, bin n < B)
    (hcard : B * K < s.card) :
    ∃ i < B, K < (s.filter fun n => bin n = i).card := by
  classical
  have hmaps : ∀ n ∈ s, bin n ∈ Finset.range B := by
    intro n hn
    exact Finset.mem_range.mpr (hbin n hn)
  simpa using
    (Finset.exists_lt_card_fiber_of_mul_lt_card_of_maps_to
      (s := s) (t := Finset.range B) (f := bin) hmaps (by simpa using hcard))

/-- If more than `B*K` points lie in `[N, N+B*T)`, one of its `B`
half-open subintervals of length `T` contains more than `K` points. -/
theorem exists_large_half_open_interval
    (s : Finset ℕ) (N T B K : ℕ)
    (hT : 0 < T)
    (hbounds : ∀ n ∈ s, N ≤ n ∧ n < N + B * T)
    (hcard : B * K < s.card) :
    ∃ i < B,
      K < (s.filter fun n => N + i * T ≤ n ∧ n < N + (i + 1) * T).card := by
  classical
  let bin : ℕ → ℕ := fun n => (n - N) / T
  have hbin : ∀ n ∈ s, bin n < B := by
    intro n hn
    have hn_bounds := hbounds n hn
    apply (Nat.div_lt_iff_lt_mul hT).mpr
    omega
  obtain ⟨i, hiB, hi⟩ :=
    exists_large_numbered_bin s bin B K hbin hcard
  have heq :
      (s.filter fun n => bin n = i) =
        (s.filter fun n => N + i * T ≤ n ∧ n < N + (i + 1) * T) := by
    ext n
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hns, hquot⟩
      have hn_bounds := hbounds n hns
      have hl0 : (n - N) / T * T ≤ n - N :=
        Nat.div_mul_le_self (n - N) T
      have hl : i * T ≤ n - N := by
        simpa [bin, hquot] using hl0
      have hu : n - N < (i + 1) * T := by
        apply (Nat.div_lt_iff_lt_mul hT).mp
        simp [bin, hquot]
      constructor <;> omega
    · rintro ⟨hns, hlo, hhi⟩
      have hNn : N ≤ n := by omega
      have hl : i * T ≤ n - N := by omega
      have hu : n - N < (i + 1) * T := by omega
      have hi_le : i ≤ (n - N) / T :=
        (Nat.le_div_iff_mul_le hT).mpr hl
      have hdiv_lt : (n - N) / T < i + 1 :=
        (Nat.div_lt_iff_lt_mul hT).mpr hu
      refine ⟨hns, ?_⟩
      simp only [bin]
      omega
  refine ⟨i, hiB, ?_⟩
  rwa [heq] at hi

#print axioms exists_large_numbered_bin
#print axioms exists_large_half_open_interval

end Erdos700PNT.PackingWork
