import PackingWork.AsymmetricGap
import PackingWork.IntervalPacking

/-!
# Dense finite sets contain asymmetric triples

This composes sorting, the exponential suffix-gap lemma, and equal-interval
packing.  The final theorem is specialized to the exact interval
`[8*T^3, 16*T^3)` used in the PNT proof of Erdős 700(ii).
-/

namespace Erdos700PNT.PackingWork

/-- More than `K+2` points in a half-open interval of length `T`, together with
`T < 2^(K+1)`, force an asymmetric triple. -/
theorem dense_finset_has_asymmetric_triple
    (s : Finset ℕ) (A T K : ℕ)
    (hbounds : ∀ n ∈ s, A ≤ n ∧ n < A + T)
    (hcard : K + 2 < s.card)
    (hpow : T < 2 ^ (K + 1)) :
    ∃ p ∈ s, ∃ q ∈ s, ∃ r ∈ s,
      p < q ∧ q < r ∧ r - q > q - p ∧ r - p < T := by
  classical
  let l : List ℕ := s.sort
  have hlen : K + 2 < l.length := by
    simpa [l] using hcard
  cases hl : l with
  | nil =>
      simp [hl] at hlen
  | cons x tail =>
      have htail : tail ≠ [] := by
        intro hnil
        rw [hnil] at hl
        simp [hl] at hlen
      let z : ℕ := tail.getLast htail
      let xs : List ℕ := tail.dropLast
      have hdecomp : l = x :: xs ++ [z] := by
        rw [hl]
        simp only [xs, z]
        simp only [List.cons_append]
        rw [List.dropLast_append_getLast htail]
      have hinc : (x :: xs ++ [z]).Pairwise (· < ·) := by
        rw [← hdecomp]
        exact (Finset.sortedLT_sort s).pairwise
      have hx_l : x ∈ l := by
        rw [hdecomp]
        simp
      have hz_l : z ∈ l := by
        rw [hdecomp]
        simp
      have hx_s : x ∈ s := by
        simpa [l] using hx_l
      have hz_s : z ∈ s := by
        simpa [l] using hz_l
      have hxs_len : K < xs.length := by
        have hlen_eq : l.length = xs.length + 2 := by
          rw [hdecomp]
          simp
        omega
      have hx_bounds := hbounds x hx_s
      have hz_bounds := hbounds z hz_s
      have hzxT : z - x < T := by omega
      have hpow_mono : 2 ^ (K + 1) ≤ 2 ^ xs.length :=
        Nat.pow_le_pow_right (by decide) (by omega)
      have hspan : z - x < 2 ^ xs.length :=
        hzxT.trans (hpow.trans_le hpow_mono)
      obtain ⟨p, hp, q, hq, hpq, hqz, hasym⟩ :=
        exists_asymmetric_triple_with_last z x xs hinc hspan
      have hp_l : p ∈ l := by
        rw [hdecomp]
        exact List.mem_append_left [z] hp
      have hq_l : q ∈ l := by
        rw [hdecomp]
        exact List.mem_append_left [z] hq
      have hp_s : p ∈ s := by
        simpa [l] using hp_l
      have hq_s : q ∈ s := by
        simpa [l] using hq_l
      have hp_bounds := hbounds p hp_s
      have hzpT : z - p < T := by omega
      exact ⟨p, hp_s, q, hq_s, z, hz_s, hpq, hqz, hasym, hzpT⟩

/-- Equal-interval packing followed by the dense-interval asymmetric-gap
argument. -/
theorem packed_finset_has_asymmetric_triple
    (s : Finset ℕ) (N T B K : ℕ)
    (hT : 0 < T)
    (hbounds : ∀ n ∈ s, N ≤ n ∧ n < N + B * T)
    (hcard : B * (K + 2) < s.card)
    (hpow : T < 2 ^ (K + 1)) :
    ∃ p ∈ s, ∃ q ∈ s, ∃ r ∈ s,
      N ≤ p ∧ p < q ∧ q < r ∧
        r - q > q - p ∧ r - p < T := by
  classical
  obtain ⟨i, hiB, hi⟩ :=
    exists_large_half_open_interval s N T B (K + 2) hT hbounds hcard
  let box : Finset ℕ :=
    s.filter fun n => N + i * T ≤ n ∧ n < N + (i + 1) * T
  have hbox_bounds :
      ∀ n ∈ box, N + i * T ≤ n ∧ n < N + i * T + T := by
    intro n hn
    simp only [box, Finset.mem_filter] at hn
    constructor
    · exact hn.2.1
    · convert hn.2.2 using 1 <;> ring
  have hbox_card : K + 2 < box.card := by
    simpa [box] using hi
  obtain ⟨p, hp, q, hq, r, hr, hpq, hqr, hasym, hrpT⟩ :=
    dense_finset_has_asymmetric_triple box (N + i * T) T K
      hbox_bounds hbox_card hpow
  have hp' : p ∈ s := (Finset.mem_filter.mp hp).1
  have hq' : q ∈ s := (Finset.mem_filter.mp hq).1
  have hr' : r ∈ s := (Finset.mem_filter.mp hr).1
  have hNp : N ≤ p := by
    have := (hbox_bounds p hp).1
    omega
  exact ⟨p, hp', q, hq', r, hr', hNp, hpq, hqr, hasym, hrpT⟩

/-- The exact `8*T^3` packing geometry used by the PNT route. -/
theorem eight_cube_interval_has_asymmetric_triple
    (s : Finset ℕ) (T K : ℕ)
    (hT : 0 < T)
    (hbounds : ∀ n ∈ s, 8 * T ^ 3 ≤ n ∧ n < 16 * T ^ 3)
    (hcard : (8 * T ^ 2) * (K + 2) < s.card)
    (hpow : T < 2 ^ (K + 1)) :
    ∃ p ∈ s, ∃ q ∈ s, ∃ r ∈ s,
      8 * T ^ 3 ≤ p ∧ p < q ∧ q < r ∧
        r - q > q - p ∧ r - p < T := by
  have hbounds' :
      ∀ n ∈ s, 8 * T ^ 3 ≤ n ∧
        n < 8 * T ^ 3 + (8 * T ^ 2) * T := by
    intro n hn
    have h := hbounds n hn
    exact ⟨h.1, h.2.trans_le (by ring_nf; exact le_rfl)⟩
  exact packed_finset_has_asymmetric_triple
    s (8 * T ^ 3) T (8 * T ^ 2) K hT hbounds' hcard hpow

/-- Closed-right version matching
`primeCounting (16*T^3) - primeCounting (8*T^3)`, which counts primes in
`(8*T^3, 16*T^3]`.  Adding one to both half-open endpoints removes the
off-by-one issue without changing either the number or the length of boxes. -/
theorem eight_cube_right_closed_interval_has_asymmetric_triple
    (s : Finset ℕ) (T K : ℕ)
    (hT : 0 < T)
    (hbounds : ∀ n ∈ s, 8 * T ^ 3 < n ∧ n ≤ 16 * T ^ 3)
    (hcard : (8 * T ^ 2) * (K + 2) < s.card)
    (hpow : T < 2 ^ (K + 1)) :
    ∃ p ∈ s, ∃ q ∈ s, ∃ r ∈ s,
      8 * T ^ 3 ≤ p ∧ p < q ∧ q < r ∧
        r - q > q - p ∧ r - p < T := by
  have hbounds' :
      ∀ n ∈ s, 8 * T ^ 3 + 1 ≤ n ∧
        n < (8 * T ^ 3 + 1) + (8 * T ^ 2) * T := by
    intro n hn
    have h := hbounds n hn
    constructor
    · omega
    · have hgeom :
          (8 * T ^ 3 + 1) + (8 * T ^ 2) * T =
            16 * T ^ 3 + 1 := by
          ring_nf
      rw [hgeom]
      omega
  obtain ⟨p, hp, q, hq, r, hr, hNp, hpq, hqr, hasym, hrpT⟩ :=
    packed_finset_has_asymmetric_triple
      s (8 * T ^ 3 + 1) T (8 * T ^ 2) K hT hbounds' hcard hpow
  exact ⟨p, hp, q, hq, r, hr, by omega, hpq, hqr, hasym, hrpT⟩

#print axioms dense_finset_has_asymmetric_triple
#print axioms packed_finset_has_asymmetric_triple
#print axioms eight_cube_interval_has_asymmetric_triple
#print axioms eight_cube_right_closed_interval_has_asymmetric_triple

end Erdos700PNT.PackingWork
