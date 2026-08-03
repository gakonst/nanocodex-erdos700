import PartIWork.HistoricalPrimePower

/-!
# Historical theorem through a finite carry maximum

This gives an independent proof of the original greatest-prime-power
formulation by identifying the maximum admissible residue-carry weight with
`Q(n)`.
-/

namespace Erdos700PartI

/--
The finite extremal invariant for the historical problem: the largest
residue-carry weight among indices in the half interval.  The conditional
makes the finite supremum total without choosing a maximizing index.
-/
noncomputable def admissibleCarryMaximum (n : ℕ) : ℕ := by
  classical
  exact
    (Finset.range (n + 1)).sup
      (fun k =>
        if Admissible n k then residueCarryWeight n k else 0)

/-- Every admissible carry weight is bounded by the finite extremum. -/
theorem residueCarryWeight_le_admissibleCarryMaximum
    (n k : ℕ) (hk : Admissible n k) :
    residueCarryWeight n k ≤ admissibleCarryMaximum n := by
  classical
  have hk_le_n : k ≤ n := by
    exact hk.2.trans (Nat.div_le_self n 2)
  have hk_range : k ∈ Finset.range (n + 1) := by
    simp only [Finset.mem_range]
    omega
  unfold admissibleCarryMaximum
  have hle :=
    Finset.le_sup
      (s := Finset.range (n + 1))
      (f := fun j =>
        if Admissible n j then residueCarryWeight n j else 0)
      hk_range
  simpa [hk] using hle

/--
The extremum is at most the baseline exactly when every admissible carry
weight is at most the baseline.
-/
theorem admissibleCarryMaximum_le_iff
    (n baseline : ℕ) :
    admissibleCarryMaximum n ≤ baseline ↔
      ∀ k, Admissible n k →
        residueCarryWeight n k ≤ baseline := by
  classical
  constructor
  · intro hmax k hk
    exact
      (residueCarryWeight_le_admissibleCarryMaximum n k hk).trans hmax
  · intro hall
    unfold admissibleCarryMaximum
    apply Finset.sup_le
    intro k hk_range
    by_cases hk : Admissible n k
    · simpa [hk] using hall k hk
    · simp [hk]

/-- Carry safety is the upper-bound statement for the finite extremum. -/
theorem carrySafe_iff_admissibleCarryMaximum_le
    (n baseline : ℕ) :
    CarrySafe n baseline (residueCarryWeight n) ↔
      admissibleCarryMaximum n ≤ baseline := by
  simpa [CarrySafe] using
    (admissibleCarryMaximum_le_iff n baseline).symm

/--
Off prime powers, the historical component itself occurs among the admissible
weights, so it is a lower bound for their maximum.
-/
theorem Q_le_admissibleCarryMaximum
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    Erdos700.Q n ≤ admissibleCarryMaximum n := by
  rw [← Q_weight_witness n hn hnpp]
  exact residueCarryWeight_le_admissibleCarryMaximum
    n (Erdos700.Q n) (Q_admissible n hn hnpp)

/--
Because Q(n) is attained, carry safety is equivalent to exact maximum
attainment at Q(n), not merely to an upper bound.
-/
theorem carrySafe_iff_admissibleCarryMaximum_eq_Q
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    CarrySafe n (Erdos700.Q n) (residueCarryWeight n) ↔
      admissibleCarryMaximum n = Erdos700.Q n := by
  have hlower := Q_le_admissibleCarryMaximum n hn hnpp
  constructor
  · intro hsafe
    apply Nat.le_antisymm
    · exact
        (carrySafe_iff_admissibleCarryMaximum_le
          n (Erdos700.Q n)).mp hsafe
    · exact hlower
  · intro hmax
    apply
      (carrySafe_iff_admissibleCarryMaximum_le
        n (Erdos700.Q n)).mpr
    exact hmax.le

/-- Historical boundary safety is exactly maximum attainment at Q(n). -/
theorem admissibleCarryMaximum_eq_Q_iff_historicalBoundarySafe
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    admissibleCarryMaximum n = Erdos700.Q n ↔
      Erdos700.HistoricalBoundarySafe n := by
  exact
    (carrySafe_iff_admissibleCarryMaximum_eq_Q n hn hnpp).symm.trans
      (carrySafe_iff_boundarySafeAt
        n (Erdos700.Q n) (by omega) (one_lt_Q n hn))

/-- The binomial-gcd minimum equals n/Q(n) exactly when Q(n) is the maximum. -/
theorem f_eq_div_Q_iff_admissibleCarryMaximum_eq_Q
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    Erdos700.f n = n / Erdos700.Q n ↔
      admissibleCarryMaximum n = Erdos700.Q n := by
  exact
    (f_eq_div_iff_carrySafe
      n (Erdos700.Q n) (Erdos700.Q n)
      (residueCarryWeight n)
      (by omega)
      (Q_pos_dvd n hn).1
      (Q_pos_dvd n hn).2
      (exactCarryWeight_residueCarryWeight n (by omega))
      (Q_admissible n hn hnpp)
      (Q_weight_witness n hn hnpp)).trans
      (carrySafe_iff_admissibleCarryMaximum_eq_Q n hn hnpp)

/--
A complete extremal proof of historical Erdos 700(i).  The proof factors
through the maximum admissible carry weight and does not invoke either the
prepackaged historical theorem or the order-duality theorem.
-/
theorem erdos_700_i_historical_extremal
    (n : ℕ) (hn : 1 < n) (hcomp : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.Q n ↔
      ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n := by
  constructor
  · intro hf
    have hnpp : ¬ IsPrimePow n := by
      intro hpp
      exact (f_ne_div_Q_of_isPrimePow n hcomp hpp) hf
    have hmax :=
      (f_eq_div_Q_iff_admissibleCarryMaximum_eq_Q
        n hn hnpp).mp hf
    exact ⟨hnpp,
      (admissibleCarryMaximum_eq_Q_iff_historicalBoundarySafe
        n hn hnpp).mp hmax⟩
  · rintro ⟨hnpp, hsafe⟩
    apply
      (f_eq_div_Q_iff_admissibleCarryMaximum_eq_Q
        n hn hnpp).mpr
    exact
      (admissibleCarryMaximum_eq_Q_iff_historicalBoundarySafe
        n hn hnpp).mpr hsafe

end Erdos700PartI
