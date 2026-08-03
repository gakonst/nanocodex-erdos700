import Mathlib

/-!
# A finite asymmetric-gap lemma

The proof is the elementary "exponentially growing suffix gaps" argument used
in the PNT route to Erdős 700(ii).  If

`x₀ < x₁ < ... < xₙ < z`

and no adjacent pair `xᵢ < xᵢ₊₁ < z` satisfies

`z - xᵢ₊₁ > xᵢ₊₁ - xᵢ`,

then every suffix distance is at least twice the next one.  Consequently
`z - x₀ ≥ 2ⁿ`.
-/

namespace Erdos700PNT.PackingWork

/-- An adjacent pair in `xs` forms an asymmetric triple with the final point
`z`.  The decomposition records adjacency without introducing list indices. -/
def HasAsymmetricAdjacentPair (z : ℕ) (xs : List ℕ) : Prop :=
  ∃ pre x y post,
    xs = pre ++ x :: y :: post ∧
      z - y > y - x

/-- The exponential suffix-gap bound, stated contrapositively in a form that is
convenient for induction. -/
theorem pow_two_le_span_of_no_asymmetric_adjacent
    (z x : ℕ) (xs : List ℕ)
    (hinc : (x :: xs ++ [z]).Pairwise (· < ·))
    (hno : ¬ HasAsymmetricAdjacentPair z (x :: xs)) :
    2 ^ xs.length ≤ z - x := by
  induction xs generalizing x with
  | nil =>
      have hxz : x < z := List.rel_of_pairwise_cons hinc (by simp)
      simp only [List.length_nil, pow_zero]
      omega
  | cons y ys ih =>
      have hxy : x < y := List.rel_of_pairwise_cons hinc (by simp)
      have htail : (y :: ys ++ [z]).Pairwise (· < ·) := by
        exact hinc.of_cons
      have hyz : y < z := List.rel_of_pairwise_cons htail (by simp)
      have hno_head : ¬ z - y > y - x := by
        intro h
        apply hno
        refine ⟨[], x, y, ys, ?_, h⟩
        simp
      have hno_tail : ¬ HasAsymmetricAdjacentPair z (y :: ys) := by
        intro h
        rcases h with ⟨pre, a, b, post, hdecomp, hab⟩
        apply hno
        refine ⟨x :: pre, a, b, post, ?_, hab⟩
        simp [hdecomp]
      have hpow : 2 ^ ys.length ≤ z - y :=
        ih y htail hno_tail
      have hdouble : 2 * (z - y) ≤ z - x := by
        have hle : z - y ≤ y - x := by omega
        omega
      rw [List.length_cons, pow_succ]
      omega

/-- If an increasing finite chain is too long for its span, one of its
adjacent pairs forms the desired asymmetric triple with the final point. -/
theorem exists_asymmetric_adjacent_of_span_lt_pow_two
    (z x : ℕ) (xs : List ℕ)
    (hinc : (x :: xs ++ [z]).Pairwise (· < ·))
    (hspan : z - x < 2 ^ xs.length) :
    HasAsymmetricAdjacentPair z (x :: xs) := by
  by_contra hno
  exact (Nat.not_le.mpr hspan)
    (pow_two_le_span_of_no_asymmetric_adjacent z x xs hinc hno)

/-- Membership-oriented version: a sufficiently dense increasing list contains
three entries `p < q < r` with `r - q > q - p`.  Here `r` is the final point,
which is enough for the interval-packing application. -/
theorem exists_asymmetric_triple_with_last
    (z x : ℕ) (xs : List ℕ)
    (hinc : (x :: xs ++ [z]).Pairwise (· < ·))
    (hspan : z - x < 2 ^ xs.length) :
    ∃ p ∈ x :: xs, ∃ q ∈ x :: xs,
      p < q ∧ q < z ∧ z - q > q - p := by
  rcases exists_asymmetric_adjacent_of_span_lt_pow_two z x xs hinc hspan with
    ⟨pre, p, q, post, hdecomp, hasym⟩
  have hinc' : (pre ++ p :: q :: post ++ [z]).Pairwise (· < ·) := by
    rw [← hdecomp]
    simpa only [List.cons_append] using hinc
  have hsuffix : (p :: q :: post ++ [z]).Pairwise (· < ·) := by
    simpa using List.Pairwise.drop (i := pre.length) hinc'
  have hpq : p < q := by
    exact List.rel_of_pairwise_cons hsuffix (by simp)
  have hqz : q < z := by
    exact List.rel_of_pairwise_cons hsuffix.of_cons (by simp)
  refine ⟨p, ?_, q, ?_, hpq, hqz, hasym⟩ <;>
    simp [hdecomp]

#print axioms pow_two_le_span_of_no_asymmetric_adjacent
#print axioms exists_asymmetric_adjacent_of_span_lt_pow_two
#print axioms exists_asymmetric_triple_with_last

end Erdos700PNT.PackingWork
