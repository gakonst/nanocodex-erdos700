import PNTWork.PrimeInterval
import Mathlib.Analysis.SpecialFunctions.Log.Base

open Filter Real Asymptotics

namespace Erdos700PNT

/--
The elementary analytic estimate behind the packing argument.  The deliberately
loose constant is chosen so that the later comparison with `Nat.log 2 T` is
transparent.
-/
theorem eventually_log_square_dominated :
    ∀ᶠ x : ℝ in atTop, (120 / log 2) * log x ^ 2 < x := by
  have hlogtwo : 0 < log (2 : ℝ) := Real.log_pos (by norm_num)
  have hlittle :
      (fun x : ℝ ↦ (120 / log 2) * log x ^ 2) =o[atTop] id :=
    Real.isLittleO_pow_log_id_atTop.const_mul_left (120 / log 2)
  have hbound := hlittle.def (by norm_num : (0 : ℝ) < 1 / 2)
  filter_upwards [hbound, eventually_gt_atTop (0 : ℝ)] with x hx hxpos
  have hcoef : 0 ≤ 120 / log 2 := (div_pos (by norm_num) hlogtwo).le
  have hleft : 0 ≤ (120 / log 2) * log x ^ 2 :=
    mul_nonneg hcoef (sq_nonneg _)
  have hx' : (120 / log 2) * log x ^ 2 ≤ (1 / 2 : ℝ) * x := by
    simpa [Real.norm_eq_abs, abs_of_nonneg hleft, abs_of_pos hxpos,
      abs_of_pos hlogtwo] using hx
  linarith

/--
For large natural `T`, the exact logarithmic expression needed after cancelling
`8*T^2` from the PNT lower bound is strictly smaller than `T`.
-/
theorem eventually_log_budget_lt :
    ∀ᶠ T : ℕ in atTop,
      10 * log (((8 * T ^ 3 : ℕ) : ℝ)) *
          (((Nat.log 2 T : ℕ) : ℝ) + 2) < (T : ℝ) := by
  have hdom :
      ∀ᶠ T : ℕ in atTop,
        (120 / log 2) * log (T : ℝ) ^ 2 < (T : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually eventually_log_square_dominated
  filter_upwards [hdom, eventually_ge_atTop (8 : ℕ)] with T hdomT hT
  have hTpos_nat : 0 < T := by omega
  have hTpos : 0 < (T : ℝ) := by positivity
  have hlogtwo : 0 < log (2 : ℝ) := Real.log_pos (by norm_num)
  have hlogT : 0 < log (T : ℝ) := Real.log_pos (by
    exact_mod_cast (show 1 < T by omega))
  have hlog8_le : log (8 : ℝ) ≤ log (T : ℝ) := by
    exact Real.strictMonoOn_log.monotoneOn
      (by norm_num : (8 : ℝ) ∈ Set.Ioi 0)
      (show 0 < (T : ℝ) from hTpos)
      (by exact_mod_cast hT)
  have hlog_cube :
      log (((8 * T ^ 3 : ℕ) : ℝ)) =
        log (8 : ℝ) + 3 * log (T : ℝ) := by
    rw [Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow, Real.log_mul
      (by norm_num : (8 : ℝ) ≠ 0) (pow_ne_zero 3 hTpos.ne')]
    rw [Real.log_pow]
    norm_num
  have hlogN_le :
      log (((8 * T ^ 3 : ℕ) : ℝ)) ≤ 4 * log (T : ℝ) := by
    rw [hlog_cube]
    linarith
  have hnatlog :
      ((Nat.log 2 T : ℕ) : ℝ) ≤ log (T : ℝ) / log 2 := by
    simpa [Real.logb] using Real.natLog_le_logb T 2
  have hlogtwo_le_logT : log (2 : ℝ) ≤ log (T : ℝ) := by
    exact Real.strictMonoOn_log.monotoneOn
      (by norm_num : (2 : ℝ) ∈ Set.Ioi 0)
      (show 0 < (T : ℝ) from hTpos)
      (by exact_mod_cast (show 2 ≤ T by omega))
  have htwo_le : (2 : ℝ) ≤ 2 * (log (T : ℝ) / log 2) := by
    have hratio : (1 : ℝ) ≤ log (T : ℝ) / log 2 := by
      exact (le_div_iff₀ hlogtwo).2 (by simpa using hlogtwo_le_logT)
    linarith
  have hlogcount :
      ((Nat.log 2 T : ℕ) : ℝ) + 2 ≤
        (3 / log 2) * log (T : ℝ) := by
    have hsum :
        ((Nat.log 2 T : ℕ) : ℝ) + 2 ≤
          3 * (log (T : ℝ) / log 2) := by
      linarith
    calc
      ((Nat.log 2 T : ℕ) : ℝ) + 2
          ≤ 3 * (log (T : ℝ) / log 2) := hsum
      _ = (3 / log 2) * log (T : ℝ) := by ring
  have hlogNpos : 0 < log (((8 * T ^ 3 : ℕ) : ℝ)) := by
    rw [hlog_cube]
    positivity
  have hcount_nonneg : 0 ≤ ((Nat.log 2 T : ℕ) : ℝ) + 2 := by positivity
  calc
    10 * log (((8 * T ^ 3 : ℕ) : ℝ)) *
          (((Nat.log 2 T : ℕ) : ℝ) + 2)
        ≤ 10 * (4 * log (T : ℝ)) *
            ((3 / log 2) * log (T : ℝ)) := by
              gcongr
    _ = (120 / log 2) * log (T : ℝ) ^ 2 := by ring
    _ < (T : ℝ) := hdomT

/--
The exact real inequality needed to combine the PNT interval lower bound with
the finite pigeonhole argument.
-/
theorem eventually_packing_threshold_lt_pnt_lower_bound :
    ∀ᶠ T : ℕ in atTop,
      ((8 * T ^ 2 * (Nat.log 2 T + 2) : ℕ) : ℝ) <
        ((8 * T ^ 3 : ℕ) : ℝ) /
          (10 * log (((8 * T ^ 3 : ℕ) : ℝ))) := by
  filter_upwards [eventually_log_budget_lt, eventually_ge_atTop (8 : ℕ)] with
      T hbudget hT
  have hTpos_nat : 0 < T := by omega
  have hTpos : 0 < (T : ℝ) := by positivity
  have hlogNpos : 0 < log (((8 * T ^ 3 : ℕ) : ℝ)) := by
    have hNgt : (1 : ℝ) < ((8 * T ^ 3 : ℕ) : ℝ) := by
      have hcube : 1 ≤ T ^ 3 :=
        Nat.one_le_iff_ne_zero.mpr (pow_ne_zero 3 hTpos_nat.ne')
      exact_mod_cast (show 1 < 8 * T ^ 3 by omega)
    exact Real.log_pos hNgt
  have hdenpos :
      0 < 10 * log (((8 * T ^ 3 : ℕ) : ℝ)) := mul_pos (by norm_num) hlogNpos
  have hscale : 0 < (8 : ℝ) * (T : ℝ) ^ 2 := by positivity
  have hscaled :
      ((8 : ℝ) * (T : ℝ) ^ 2) *
          (10 * log (((8 * T ^ 3 : ℕ) : ℝ)) *
            (((Nat.log 2 T : ℕ) : ℝ) + 2)) <
        ((8 : ℝ) * (T : ℝ) ^ 2) * (T : ℝ) :=
    mul_lt_mul_of_pos_left hbudget hscale
  rw [lt_div_iff₀ hdenpos]
  norm_num [Nat.cast_mul, Nat.cast_add, Nat.cast_pow] at hscaled ⊢
  nlinarith

/--
Consequently, the actual natural prime-count difference is eventually strictly
larger than the number of boxes times the allowed occupancy.
-/
theorem eventually_packing_threshold_lt_prime_count :
    ∀ᶠ T : ℕ in atTop,
      8 * T ^ 2 * (Nat.log 2 T + 2) <
        Nat.primeCounting (16 * T ^ 3) -
          Nat.primeCounting (8 * T ^ 3) := by
  filter_upwards
    [eventually_packing_threshold_lt_pnt_lower_bound,
      eventually_primeCounting_eight_cube_interval_nat_sub] with T hthreshold hpnt
  exact_mod_cast hthreshold.trans_le hpnt

#print axioms eventually_log_square_dominated
#print axioms eventually_log_budget_lt
#print axioms eventually_packing_threshold_lt_pnt_lower_bound
#print axioms eventually_packing_threshold_lt_prime_count

end Erdos700PNT
