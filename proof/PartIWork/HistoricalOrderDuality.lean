import PartIWork.HistoricalPrimePower

/-!
# Historical theorem by gcd/carry-weight order duality

This gives an independent proof of the original greatest-prime-power
formulation by reversing strict order through the exact product
`gcd(n, choose(n,k)) * residueCarryWeight(n,k) = n`.
-/

namespace Erdos700PartI

/-- Exact order reversal between a binomial gcd and its carry weight. -/
theorem gcd_lt_quotient_iff_baseline_lt_residueCarryWeight
    (n baseline k : ℕ)
    (hn : 0 < n)
    (hbaseline_pos : 0 < baseline)
    (hbaseline_dvd : baseline ∣ n)
    (hk : Admissible n k) :
    Nat.gcd n (n.choose k) < n / baseline ↔
      baseline < residueCarryWeight n k := by
  have hexact := (residueCarryWeight_exact n k hn hk).2
  have hcanonical : n / baseline * baseline = n :=
    Nat.div_mul_cancel hbaseline_dvd
  have hquotient_pos : 0 < n / baseline :=
    Nat.div_pos (Nat.le_of_dvd hn hbaseline_dvd) hbaseline_pos
  constructor
  · intro hgcd
    by_contra hweight
    have hwle : residueCarryWeight n k ≤ baseline :=
      Nat.le_of_not_gt hweight
    have hle :
        Nat.gcd n (n.choose k) * residueCarryWeight n k ≤
          Nat.gcd n (n.choose k) * baseline :=
      Nat.mul_le_mul_left _ hwle
    have hlt :
        Nat.gcd n (n.choose k) * baseline <
          n / baseline * baseline :=
      Nat.mul_lt_mul_of_pos_right hgcd hbaseline_pos
    have hnn : n < n := by
      simpa [hexact, hcanonical] using hle.trans_lt hlt
    exact (Nat.lt_irrefl n) hnn
  · intro hweight
    by_contra hgcd
    have hquotient_le :
        n / baseline ≤ Nat.gcd n (n.choose k) :=
      Nat.le_of_not_gt hgcd
    have hlt :
        n / baseline * baseline <
          n / baseline * residueCarryWeight n k :=
      Nat.mul_lt_mul_of_pos_left hweight hquotient_pos
    have hle :
        n / baseline * residueCarryWeight n k ≤
          Nat.gcd n (n.choose k) * residueCarryWeight n k :=
      Nat.mul_le_mul_right _ hquotient_le
    have hnn : n < n := by
      simpa [hexact, hcanonical] using hlt.trans_le hle
    exact (Nat.lt_irrefl n) hnn

/-- A historical boundary obstruction is exactly a strictly smaller gcd. -/
theorem not_historicalBoundarySafe_iff_exists_gcd_lt
    (n : ℕ) (hn : 1 < n) :
    ¬ Erdos700.HistoricalBoundarySafe n ↔
      ∃ k, Admissible n k ∧
        Nat.gcd n (n.choose k) < n / Erdos700.Q n := by
  have hnpos : 0 < n := by omega
  have hQpos : 0 < Erdos700.Q n := (Q_pos_dvd n hn).1
  have hQdvd : Erdos700.Q n ∣ n := (Q_pos_dvd n hn).2
  have hbridge :=
    carrySafe_iff_boundarySafeAt
      n (Erdos700.Q n) hnpos (one_lt_Q n hn)
  constructor
  · intro hnotSafe
    have hnotCarry :
        ¬ CarrySafe n (Erdos700.Q n) (residueCarryWeight n) := by
      intro hcarry
      exact hnotSafe (hbridge.mp hcarry)
    simp only [CarrySafe] at hnotCarry
    push_neg at hnotCarry
    obtain ⟨k, hk, hweight⟩ := hnotCarry
    exact ⟨k, hk,
      (gcd_lt_quotient_iff_baseline_lt_residueCarryWeight
        n (Erdos700.Q n) k hnpos hQpos hQdvd hk).2 hweight⟩
  · rintro ⟨k, hk, hgcd⟩ hsafe
    have hcarry :
        CarrySafe n (Erdos700.Q n) (residueCarryWeight n) :=
      hbridge.mpr hsafe
    have hweight :=
      (gcd_lt_quotient_iff_baseline_lt_residueCarryWeight
        n (Erdos700.Q n) k hnpos hQpos hQdvd hk).1 hgcd
    exact (not_lt_of_ge (hcarry k hk)) hweight

/-- Boundary safety is the direct lower-bound certificate for every gcd. -/
theorem historicalBoundarySafe_iff_gcdLowerBounds
    (n : ℕ) (hn : 1 < n) :
    Erdos700.HistoricalBoundarySafe n ↔
      ∀ k, Admissible n k →
        n / Erdos700.Q n ≤ Nat.gcd n (n.choose k) := by
  constructor
  · intro hsafe k hk
    by_contra hlower
    have hgcd :
        Nat.gcd n (n.choose k) < n / Erdos700.Q n :=
      Nat.lt_of_not_ge hlower
    have hnotSafe :=
      (not_historicalBoundarySafe_iff_exists_gcd_lt n hn).2
        ⟨k, hk, hgcd⟩
    exact hnotSafe hsafe
  · intro hlower
    by_contra hsafe
    obtain ⟨k, hk, hgcd⟩ :=
      (not_historicalBoundarySafe_iff_exists_gcd_lt n hn).1 hsafe
    exact (not_lt_of_ge (hlower k hk)) hgcd

/--
An alternate complete proof of the historical theorem, through gcd/weight
order duality rather than the prepackaged final equivalence.
-/
theorem erdos_700_i_historical_orderDual
    (n : ℕ) (hn : 1 < n) (hcomp : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.Q n ↔
      ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n := by
  constructor
  · intro hf
    have hnpp : ¬ IsPrimePow n := by
      intro hpp
      exact (f_ne_div_Q_of_isPrimePow n hcomp hpp) hf
    refine ⟨hnpp,
      (historicalBoundarySafe_iff_gcdLowerBounds n hn).2 ?_⟩
    intro k hk
    rw [← hf]
    exact Erdos700.f_le n k hk.1 hk.2
  · rintro ⟨hnpp, hsafe⟩
    apply f_eq_of_gcd_bounds_and_witness
      n (n / Erdos700.Q n) (Erdos700.Q n)
      (Q_admissible n hn hnpp)
      (Q_gcd_choose n hn)
    exact (historicalBoundarySafe_iff_gcdLowerBounds n hn).1 hsafe

end Erdos700PartI
