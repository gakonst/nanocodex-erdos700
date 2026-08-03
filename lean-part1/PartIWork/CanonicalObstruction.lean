import PartIWork.BoundaryAntichain

/-!
# Canonical bounded-obstruction characterization for Erdős 700(i)

This replaces the existential realizing multiplier by a finite universal
certificate: every candidate pair `(d,m)` has a prime factor whose carry
budget fails.  Boundary divisors are first confined to
`P n + 1 ≤ d ≤ (P n)^2`.
-/

namespace Erdos700PartI

theorem prime_le_largestPrime_of_dvd
    (n p : ℕ) (hn : 1 < n) (hp : p.Prime) (hpn : p ∣ n) :
    p ≤ Erdos700.P n := by
  rw [Erdos700.P]
  have hmem : p ∈ n.primeFactors := by
    rw [Nat.mem_primeFactors]
    exact ⟨hp, hpn, by omega⟩
  have hle :=
    Finset.le_sup (s := n.primeFactors) (f := fun q : ℕ => q)
      hmem
  simpa using hle

/-- Every divisor-minimal divisor above the largest prime lies below its
square.  This is the structural compression on the divisor coordinate. -/
theorem boundary_le_largestPrime_sq
    (n d : ℕ) (hn : 1 < n) (hd : Boundary n d) :
    d ≤ Erdos700.P n * Erdos700.P n := by
  have hPpos : 0 < Erdos700.P n :=
    (largestPrime_pos_dvd n hn).1
  have hPd : Erdos700.P n < d := hd.2.1
  have hd1 : d ≠ 1 := by omega
  obtain ⟨p, hp, hpd⟩ := Nat.exists_prime_and_dvd hd1
  have hpn : p ∣ n := dvd_trans hpd hd.1
  have hpP : p ≤ Erdos700.P n :=
    prime_le_largestPrime_of_dvd n p hn hp hpn
  have hquotP : d / p ≤ Erdos700.P n :=
    hd.2.2 p hp hpd
  calc
    d = (d / p) * p := (Nat.div_mul_cancel hpd).symm
    _ ≤ Erdos700.P n * Erdos700.P n :=
      Nat.mul_le_mul hquotP hpP

/-- A bounded rejection certificate.  It contains no `f`, gcd, binomial
coefficient, `Boundary`, `Realized`, `BoundarySafe`, or upstream open theorem.

For every possible boundary divisor and every possible positive multiplier,
one prime factor must exceed its available carry budget. -/
def BoundedObstructionSafe (n : ℕ) : Prop :=
  ∀ d ∈ Finset.Icc (Erdos700.P n + 1)
      (Erdos700.P n * Erdos700.P n),
    d ∣ n →
    (∀ p, p.Prime → p ∣ d → d / p ≤ Erdos700.P n) →
    ∀ m ∈ Finset.Icc 1 (n / 2),
      d * m ≤ n / 2 →
      ∃ p, p.Prime ∧ p ∣ d ∧
        n.factorization p - d.factorization p <
          residueCarryCount n (d * m) p

theorem boundedObstructionSafe_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) :
    BoundedObstructionSafe n ↔ BoundarySafe n := by
  classical
  unfold BoundedObstructionSafe BoundarySafe
  constructor
  · intro hbounded d hd hreal
    have hdmem :
        d ∈ Finset.Icc (Erdos700.P n + 1)
          (Erdos700.P n * Erdos700.P n) := by
      apply Finset.mem_Icc.mpr
      exact ⟨by have := hd.2.1; omega,
        boundary_le_largestPrime_sq n d hn hd⟩
    obtain ⟨m, hm, hbound, hcarry⟩ := hreal
    have hdpos : 0 < d := by
      have hPpos := (largestPrime_pos_dvd n hn).1
      have hPd := hd.2.1
      omega
    have hmle : m ≤ n / 2 := by
      exact (Nat.le_mul_of_pos_left m hdpos).trans hbound
    have hmmem : m ∈ Finset.Icc 1 (n / 2) :=
      Finset.mem_Icc.mpr ⟨by omega, hmle⟩
    obtain ⟨p, hp, hpd, hbad⟩ :=
      hbounded d hdmem hd.1 hd.2.2 m hmmem hbound
    have hgood := hcarry p hp hpd
    omega
  · intro hsafe d hdmem hdn hprime m hmmem hbound
    by_contra hreject
    push_neg at hreject
    have hdparts := Finset.mem_Icc.mp hdmem
    have hboundary : Boundary n d := by
      exact ⟨hdn, by omega, hprime⟩
    have hmpos : 0 < m := by
      have hmrange := Finset.mem_Icc.mp hmmem
      omega
    have hreal : Realized n d := by
      refine ⟨m, hmpos, hbound, ?_⟩
      intro p hp hpd
      have hnot := hreject p hp hpd
      omega
    exact hsafe d hboundary hreal

theorem f_eq_div_iff_boundedObstructionSafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundedObstructionSafe n := by
  exact
    (f_eq_div_iff_boundarySafe n hn hnprime).trans
      (boundedObstructionSafe_iff_boundarySafe n hn).symm

end Erdos700PartI

#print axioms Erdos700PartI.prime_le_largestPrime_of_dvd
#print axioms Erdos700PartI.boundary_le_largestPrime_sq
#print axioms Erdos700PartI.boundedObstructionSafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_boundedObstructionSafe
