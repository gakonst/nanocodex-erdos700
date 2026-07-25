import PartIWork.BaselineBoundary

/-!
# Factor-exponent residue tableau for Erdős 700(i)

This file replaces the list of possible boundary divisors by one finitely
supported exponent vector. Its support consists of primes, it is bounded by
the factorization of `n`, and all shortened-carry rows share one multiplier
`T`.
-/

namespace Erdos700PartI

open Finsupp

/-- Decode a finite prime-exponent vector. -/
noncomputable def exponentProduct (E : ℕ →₀ ℕ) : ℕ :=
  E.prod (fun p e => p ^ e)

/-- The canonical global residue tableau. -/
def FactorTableau (n baseline : ℕ) (E : ℕ →₀ ℕ) (T : ℕ) : Prop :=
  (∀ p, p ∈ E.support → p.Prime) ∧
  E ≤ n.factorization ∧
  0 < T ∧
  baseline < exponentProduct E ∧
  exponentProduct E * T ≤ n / 2 ∧
  ∀ p, p ∈ E.support →
    exponentProduct E / p ≤ baseline ∧
    residueCarryCount n (exponentProduct E * T) p ≤
      n.factorization p - E p

def FactorTableauFeasible (n baseline : ℕ) : Prop :=
  ∃ E : ℕ →₀ ℕ, ∃ T : ℕ, FactorTableau n baseline E T

def FactorTableauSafe (n baseline : ℕ) : Prop :=
  ¬ FactorTableauFeasible n baseline

theorem exponentProduct_pos
    (E : ℕ →₀ ℕ)
    (hprime : ∀ p, p ∈ E.support → p.Prime) :
    0 < exponentProduct E := by
  unfold exponentProduct
  exact Nat.prod_pow_pos_of_zero_notMem_support
    (fun hzero => Nat.not_prime_zero (hprime 0 hzero))

theorem factorization_exponentProduct
    (E : ℕ →₀ ℕ)
    (hprime : ∀ p, p ∈ E.support → p.Prime) :
    (exponentProduct E).factorization = E := by
  exact Nat.prod_pow_factorization_eq_self hprime

theorem factorTableauFeasible_iff_exists_boundary_realized
    (n baseline : ℕ) (hn : 0 < n) :
    FactorTableauFeasible n baseline ↔
      ∃ d, BoundaryAt n baseline d ∧ Realized n d := by
  constructor
  · rintro ⟨E, T, hprime, hEle, hT, hbase, hhalf, hrows⟩
    let d := exponentProduct E
    have hdpos : 0 < d := exponentProduct_pos E hprime
    have hdfac : d.factorization = E :=
      factorization_exponentProduct E hprime
    have hfac_le : d.factorization ≤ n.factorization := by
      simpa [hdfac] using hEle
    have hdn : d ∣ n :=
      (Nat.factorization_le_iff_dvd hdpos.ne' hn.ne').mp hfac_le
    have hboundary : BoundaryAt n baseline d := by
      refine ⟨hdn, hbase, ?_⟩
      intro p hp hpd
      have hpfac : 0 < d.factorization p :=
        hp.factorization_pos_of_dvd hdpos.ne' hpd
      have hpE : p ∈ E.support := by
        apply Finsupp.mem_support_iff.mpr
        rw [← hdfac]
        exact hpfac.ne'
      exact (hrows p hpE).1
    have hrealized : Realized n d := by
      refine ⟨T, hT, hhalf, ?_⟩
      intro p hp hpd
      have hpfac : 0 < d.factorization p :=
        hp.factorization_pos_of_dvd hdpos.ne' hpd
      have hpE : p ∈ E.support := by
        apply Finsupp.mem_support_iff.mpr
        rw [← hdfac]
        exact hpfac.ne'
      simpa [hdfac] using (hrows p hpE).2
    exact ⟨d, hboundary, hrealized⟩
  · rintro ⟨d, hd, m, hm, hhalf, hrows⟩
    have hdpos : 0 < d := Nat.zero_lt_of_lt hd.2.1
    let E : ℕ →₀ ℕ := d.factorization
    have hprime : ∀ p, p ∈ E.support → p.Prime := by
      intro p hp
      exact Nat.prime_of_mem_primeFactors (by simpa [E] using hp)
    have hdecode : exponentProduct E = d := by
      simpa [E, exponentProduct] using
        (Nat.factorization_prod_pow_eq_self hdpos.ne')
    have hEle : E ≤ n.factorization := by
      change d.factorization ≤ n.factorization
      exact (Nat.factorization_le_iff_dvd hdpos.ne' hn.ne').mpr hd.1
    refine ⟨E, m, hprime, hEle, hm, ?_, ?_, ?_⟩
    · simpa [hdecode] using hd.2.1
    · simpa [hdecode] using hhalf
    · intro p hpE
      have hmem : p ∈ d.primeFactors := by
        simpa [E] using hpE
      have hp : p.Prime := Nat.prime_of_mem_primeFactors hmem
      have hpd : p ∣ d := (Nat.mem_primeFactors.1 hmem).2.1
      constructor
      · simpa [hdecode] using hd.2.2 p hp hpd
      · simpa [E, hdecode] using hrows p hp hpd

theorem boundarySafeAt_iff_factorTableauSafe
    (n baseline : ℕ) (hn : 0 < n) :
    BoundarySafeAt n baseline ↔ FactorTableauSafe n baseline := by
  rw [FactorTableauSafe,
    factorTableauFeasible_iff_exists_boundary_realized n baseline hn]
  unfold BoundarySafeAt
  aesop

end Erdos700PartI
