import PrimeNumberTheoremAnd.Consequences

open Filter Real Asymptotics

namespace Erdos700PNT

/--
A coarse, quantitative consequence of the prime number theorem: for all sufficiently
large real `x`, the interval `(x, 2x]` contains at least `x / (10 log x)` primes.

The constants are deliberately wasteful.  This is intended as the analytic input to
the finite interval-packing argument for Erdős 700(ii).
-/
theorem eventually_primeCounting_double_interval :
    ∀ᶠ x : ℝ in atTop,
      x / (10 * log x) ≤
        (Nat.primeCounting ⌊2 * x⌋₊ : ℝ) - (Nat.primeCounting ⌊x⌋₊ : ℝ) := by
  obtain ⟨c, hc, hpi⟩ := pi_alt'.exists_eq_mul
  have htwo : Tendsto (fun x : ℝ ↦ 2 * x) atTop atTop :=
    (tendsto_const_mul_atTop_of_pos (r := (2 : ℝ)) (by norm_num)).2 tendsto_id
  have hc_lower :
      ∀ᶠ x : ℝ in atTop, (99 / 100 : ℝ) < c x :=
    (tendsto_order.1 hc).1 _ (by norm_num)
  have hc_upper :
      ∀ᶠ x : ℝ in atTop, c x < (101 / 100 : ℝ) :=
    (tendsto_order.1 hc).2 _ (by norm_num)
  have hc_lower_two :
      ∀ᶠ x : ℝ in atTop, (99 / 100 : ℝ) < c (2 * x) :=
    htwo.eventually hc_lower
  have hpi_two := htwo.eventually hpi
  filter_upwards [hc_lower, hc_upper, hc_lower_two, hpi, hpi_two,
      eventually_ge_atTop (Real.exp 10)] with
      x hcx_lower hcx_upper hc2x_lower hpix hpi2x hx
  have hxpos : 0 < x := (Real.exp_pos 10).trans_le hx
  have hlogx : 10 ≤ log x := by
    rw [← Real.exp_le_exp]
    simpa [Real.exp_log hxpos] using hx
  have hlogxpos : 0 < log x := by linarith
  have hlogtwo : Real.log 2 ≤ 1 := by
    nlinarith [Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)]
  have hlogtwox : log (2 * x) ≤ (11 / 10 : ℝ) * log x := by
    rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hxpos.ne']
    nlinarith
  have hlogtwoxpos : 0 < log (2 * x) :=
    Real.log_pos (by
      have hexp : 1 < Real.exp 10 := by
        simpa using Real.exp_lt_exp.mpr (by norm_num : (0 : ℝ) < 10)
      nlinarith)
  have hpi_two :
      (9 / 5 : ℝ) * (x / log x) ≤ (Nat.primeCounting ⌊2 * x⌋₊ : ℝ) := by
    rw [hpi2x]
    have hden :
        (10 / 11 : ℝ) / log x ≤ 1 / log (2 * x) := by
      rw [div_le_div_iff₀ hlogxpos hlogtwoxpos]
      nlinarith
    have hx_nonneg : 0 ≤ x := hxpos.le
    calc
      (9 / 5 : ℝ) * (x / log x)
          = (99 / 100 : ℝ) * (2 * x) * ((10 / 11 : ℝ) / log x) := by
              field_simp
              <;> ring
      _ ≤ (99 / 100 : ℝ) * (2 * x) * (1 / log (2 * x)) := by
            gcongr
      _ ≤ c (2 * x) * (2 * x) * (1 / log (2 * x)) := by
            gcongr
      _ = c (2 * x) * ((2 * x) / log (2 * x)) := by ring
  have hpi_one :
      (Nat.primeCounting ⌊x⌋₊ : ℝ) ≤ (101 / 100 : ℝ) * (x / log x) := by
    rw [hpix]
    calc
      c x * (x / log x)
          ≤ (101 / 100 : ℝ) * (x / log x) := by
            gcongr
      _ = (101 / 100 : ℝ) * (x / log x) := rfl
  have hxlog_nonneg : 0 ≤ x / log x := div_nonneg hxpos.le hlogxpos.le
  have htarget :
      x / (10 * log x) = (1 / 10 : ℝ) * (x / log x) := by
    field_simp
    <;> ring
  rw [htarget]
  nlinarith

/--
The specialization used by the proposed Erdős 700 packing argument.  It keeps
the prime counts at exact natural endpoints, while expressing the lower bound
in `ℝ` so downstream estimates do not have to fight truncated division.
-/
theorem eventually_primeCounting_eight_cube_interval :
    ∀ᶠ T : ℕ in atTop,
      ((8 * T ^ 3 : ℕ) : ℝ) /
          (10 * log (((8 * T ^ 3 : ℕ) : ℝ))) ≤
        (Nat.primeCounting (16 * T ^ 3) : ℝ) -
          (Nat.primeCounting (8 * T ^ 3) : ℝ) := by
  have hscale :
      Tendsto (fun T : ℕ ↦ (8 : ℝ) * (T : ℝ) ^ 3) atTop atTop := by
    exact (tendsto_const_mul_pow_atTop (by norm_num : (3 : ℕ) ≠ 0)
      (by norm_num : (0 : ℝ) < 8)).comp tendsto_natCast_atTop_atTop
  have h := hscale.eventually eventually_primeCounting_double_interval
  filter_upwards [h] with T hT
  have h8 : (8 : ℝ) * (T : ℝ) ^ 3 = ((8 * T ^ 3 : ℕ) : ℝ) := by
    norm_num [Nat.cast_mul, Nat.cast_pow]
  have h16 : (2 : ℝ) * ((8 * T ^ 3 : ℕ) : ℝ) = ((16 * T ^ 3 : ℕ) : ℝ) := by
    norm_num [Nat.cast_mul, Nat.cast_pow]
    <;> ring
  have hfloor8 : ⌊(8 : ℝ) * (T : ℝ) ^ 3⌋₊ = 8 * T ^ 3 := by
    exact (congrArg (fun z : ℝ ↦ ⌊z⌋₊) h8).trans (Nat.floor_natCast _)
  have hfloor16 : ⌊(2 : ℝ) * ((8 : ℝ) * (T : ℝ) ^ 3)⌋₊ = 16 * T ^ 3 := by
    have hreal :
        (2 : ℝ) * ((8 : ℝ) * (T : ℝ) ^ 3) = ((16 * T ^ 3 : ℕ) : ℝ) :=
      (congrArg (fun z : ℝ ↦ (2 : ℝ) * z) h8).trans h16
    exact (congrArg (fun z : ℝ ↦ ⌊z⌋₊) hreal).trans (Nat.floor_natCast _)
  rw [hfloor8, hfloor16] at hT
  simpa [Nat.cast_mul, Nat.cast_pow] using hT

/--
The same exact-endpoint estimate with the interval's cardinality represented by
natural subtraction, ready for finite-set cardinality and pigeonhole lemmas.
-/
theorem eventually_primeCounting_eight_cube_interval_nat_sub :
    ∀ᶠ T : ℕ in atTop,
      ((8 * T ^ 3 : ℕ) : ℝ) /
          (10 * log (((8 * T ^ 3 : ℕ) : ℝ))) ≤
        ((Nat.primeCounting (16 * T ^ 3) -
          Nat.primeCounting (8 * T ^ 3) : ℕ) : ℝ) := by
  filter_upwards [eventually_primeCounting_eight_cube_interval] with T hT
  have hendpoints : 8 * T ^ 3 ≤ 16 * T ^ 3 := by omega
  have hcounts :
      Nat.primeCounting (8 * T ^ 3) ≤ Nat.primeCounting (16 * T ^ 3) :=
    Nat.monotone_primeCounting hendpoints
  rwa [Nat.cast_sub hcounts]

#print axioms eventually_primeCounting_double_interval
#print axioms eventually_primeCounting_eight_cube_interval
#print axioms eventually_primeCounting_eight_cube_interval_nat_sub

end Erdos700PNT
