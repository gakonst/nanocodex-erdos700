import DominanceWork.Dominance
import PackingWork.DenseInterval

/-!
# From the PNT count to asymmetric prime triples

The prime-counting difference `π(16*T^3) - π(8*T^3)` is exactly the cardinality
of the primes in the closed-right interval `(8*T^3, 16*T^3]`.  This file feeds
that finite set to the packing theorem.
-/

open Filter

namespace Erdos700PNT.PackingWork

/-- The finite set of primes in `(a,b]`. -/
def primesIoc (a b : ℕ) : Finset ℕ :=
  (Finset.Ioc a b).filter Nat.Prime

theorem card_primesIoc (a b : ℕ) (hab : a ≤ b) :
    (primesIoc a b).card =
      Nat.primeCounting b - Nat.primeCounting a := by
  classical
  have heq :
      primesIoc a b =
        (Finset.range (b + 1)).filter Nat.Prime \
          (Finset.range (a + 1)).filter Nat.Prime := by
    ext p
    simp only [primesIoc, Finset.mem_filter, Finset.mem_Ioc,
      Finset.mem_sdiff, Finset.mem_range]
    by_cases hp : p.Prime <;> simp [hp] <;> omega
  have hsub :
      (Finset.range (a + 1)).filter Nat.Prime ⊆
        (Finset.range (b + 1)).filter Nat.Prime := by
    intro p hp
    simp only [Finset.mem_filter, Finset.mem_range] at hp ⊢
    exact ⟨by omega, hp.2⟩
  rw [heq, Finset.card_sdiff_of_subset hsub]
  simp only [Nat.primeCounting, Nat.primeCounting',
    Nat.count_eq_card_filter_range]

/-- The PNT lower bound and finite packing produce the exact asymmetric prime
triple needed by the structural Erdős-700 argument, for all sufficiently large
`T`. -/
theorem eventually_exists_asymmetric_prime_triple :
    ∀ᶠ T : ℕ in atTop,
      ∃ p q r : ℕ,
        p.Prime ∧ q.Prime ∧ r.Prime ∧
          8 * T ^ 3 ≤ p ∧ p < q ∧ q < r ∧
            r - q > q - p ∧ r - p < T := by
  filter_upwards
      [Erdos700PNT.eventually_packing_threshold_lt_prime_count,
        eventually_ge_atTop (1 : ℕ)] with T hcount hT
  let s : Finset ℕ := primesIoc (8 * T ^ 3) (16 * T ^ 3)
  have hendpoints : 8 * T ^ 3 ≤ 16 * T ^ 3 := by omega
  have hcard :
      (8 * T ^ 2) * (Nat.log 2 T + 2) < s.card := by
    simpa [s, card_primesIoc _ _ hendpoints] using hcount
  have hbounds :
      ∀ n ∈ s, 8 * T ^ 3 < n ∧ n ≤ 16 * T ^ 3 := by
    intro n hn
    exact (Finset.mem_Ioc.mp (Finset.mem_filter.mp hn).1)
  have hpow : T < 2 ^ (Nat.log 2 T + 1) := by
    simpa [Nat.succ_eq_add_one] using
      (Nat.lt_pow_succ_log_self (by decide : 1 < 2) T)
  obtain ⟨p, hp, q, hq, r, hr, hNp, hpq, hqr, hasym, hrpT⟩ :=
    eight_cube_right_closed_interval_has_asymmetric_triple
      s T (Nat.log 2 T) (by omega) hbounds hcard hpow
  have hpprime : p.Prime := (Finset.mem_filter.mp hp).2
  have hqprime : q.Prime := (Finset.mem_filter.mp hq).2
  have hrprime : r.Prime := (Finset.mem_filter.mp hr).2
  exact ⟨p, q, r, hpprime, hqprime, hrprime, hNp, hpq, hqr, hasym, hrpT⟩

#print axioms card_primesIoc
#print axioms eventually_exists_asymmetric_prime_triple

end Erdos700PNT.PackingWork
