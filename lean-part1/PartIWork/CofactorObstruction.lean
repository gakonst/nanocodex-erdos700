import PartIWork.BoundaryAntichain

/-!
# Cofactor-normalized characterization for Erdős 700(i)

For a positive divisor `d ∣ n`, the original product cutoff
`d * m ≤ n / 2` is exactly the quotient cutoff `m ≤ (n / d) / 2`.
This gives a finite independent characterization in which every multiplier
interval is normalized by the cofactor `n / d`.
-/

namespace Erdos700PartI

theorem prime_le_largestPrime_of_dvd_cofactor
    (n p : ℕ) (hn : 1 < n) (hp : p.Prime) (hpn : p ∣ n) :
    p ≤ Erdos700.P n := by
  rw [Erdos700.P]
  have hmem : p ∈ n.primeFactors := by
    rw [Nat.mem_primeFactors]
    exact ⟨hp, hpn, by omega⟩
  have hle :=
    Finset.le_sup (s := n.primeFactors) (f := fun q : ℕ => q) hmem
  simpa using hle

theorem boundary_le_largestPrime_sq_cofactor
    (n d : ℕ) (hn : 1 < n) (hd : Boundary n d) :
    d ≤ Erdos700.P n * Erdos700.P n := by
  have hPpos : 0 < Erdos700.P n :=
    (largestPrime_pos_dvd n hn).1
  have hPd : Erdos700.P n < d := hd.2.1
  have hd1 : d ≠ 1 := by omega
  obtain ⟨p, hp, hpd⟩ := Nat.exists_prime_and_dvd hd1
  have hpn : p ∣ n := dvd_trans hpd hd.1
  have hpP : p ≤ Erdos700.P n :=
    prime_le_largestPrime_of_dvd_cofactor n p hn hp hpn
  have hquotP : d / p ≤ Erdos700.P n := hd.2.2 p hp hpd
  calc
    d = (d / p) * p := (Nat.div_mul_cancel hpd).symm
    _ ≤ Erdos700.P n * Erdos700.P n := Nat.mul_le_mul hquotP hpP

/-- Exact normalization of the product cutoff by the cofactor. -/
theorem mul_le_half_iff_le_cofactor_half
    (n d m : ℕ) (hd : 0 < d) (hdn : d ∣ n) :
    d * m ≤ n / 2 ↔ m ≤ (n / d) / 2 := by
  constructor
  · intro h
    have hdiv : (d * m) / d ≤ (n / 2) / d :=
      Nat.div_le_div_right h
    have hcancel : d * m / d = m := Nat.mul_div_cancel_left m hd
    rw [hcancel] at hdiv
    simpa [Nat.div_div_eq_div_mul, Nat.mul_comm] using hdiv
  · intro h
    have hm2 : m * 2 ≤ n / d :=
      (Nat.le_div_iff_mul_le (by omega : 0 < 2)).mp h
    have hmul : d * (m * 2) ≤ d * (n / d) :=
      Nat.mul_le_mul_left d hm2
    have hdn_eq : d * (n / d) = n := by
      rw [Nat.mul_comm]
      exact Nat.div_mul_cancel hdn
    apply (Nat.le_div_iff_mul_le (by omega : 0 < 2)).mpr
    calc
      d * m * 2 = d * (m * 2) := by simp [Nat.mul_assoc]
      _ ≤ d * (n / d) := hmul
      _ = n := hdn_eq

/- `CofactorObstructionSafe` mentions neither the original minimum nor
binomial coefficients, gcds, `Boundary`, `Realized`, or `BoundarySafe`.
It is a finite congruence/digit-carry rejection certificate. -/
def CofactorObstructionSafe (n : ℕ) : Prop :=
  ∀ d ∈ Finset.Icc (Erdos700.P n + 1)
      (Erdos700.P n * Erdos700.P n),
    d ∣ n →
    (∀ p, p.Prime → p ∣ d → d / p ≤ Erdos700.P n) →
    ∀ m ∈ Finset.Icc 1 ((n / d) / 2),
      ∃ p, p.Prime ∧ p ∣ d ∧
        n.factorization p - d.factorization p <
          residueCarryCount n (d * m) p

theorem cofactorObstructionSafe_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) :
    CofactorObstructionSafe n ↔ BoundarySafe n := by
  classical
  unfold CofactorObstructionSafe BoundarySafe
  constructor
  · intro hcofactor d hd hreal
    have hdmem :
        d ∈ Finset.Icc (Erdos700.P n + 1)
          (Erdos700.P n * Erdos700.P n) := by
      apply Finset.mem_Icc.mpr
      exact ⟨by have := hd.2.1; omega,
        boundary_le_largestPrime_sq_cofactor n d hn hd⟩
    obtain ⟨m, hm, hbound, hcarry⟩ := hreal
    have hdpos : 0 < d := by
      have hPpos := (largestPrime_pos_dvd n hn).1
      have hPd := hd.2.1
      omega
    have hmcofactor : m ≤ (n / d) / 2 :=
      (mul_le_half_iff_le_cofactor_half n d m hdpos hd.1).mp hbound
    have hmmem : m ∈ Finset.Icc 1 ((n / d) / 2) :=
      Finset.mem_Icc.mpr ⟨by omega, hmcofactor⟩
    obtain ⟨p, hp, hpd, hbad⟩ :=
      hcofactor d hdmem hd.1 hd.2.2 m hmmem
    have hgood := hcarry p hp hpd
    omega
  · intro hsafe d hdmem hdn hprime m hmmem
    by_contra hreject
    push_neg at hreject
    have hdparts := Finset.mem_Icc.mp hdmem
    have hdpos : 0 < d := by omega
    have hbound : d * m ≤ n / 2 :=
      (mul_le_half_iff_le_cofactor_half n d m hdpos hdn).mpr
        (Finset.mem_Icc.mp hmmem).2
    have hboundary : Boundary n d := ⟨hdn, by omega, hprime⟩
    have hmpos : 0 < m := by
      have hmrange := Finset.mem_Icc.mp hmmem
      omega
    have hreal : Realized n d := by
      refine ⟨m, hmpos, hbound, ?_⟩
      intro p hp hpd
      have hnot := hreject p hp hpd
      omega
    exact hsafe d hboundary hreal

theorem f_eq_div_iff_cofactorObstructionSafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ CofactorObstructionSafe n := by
  exact
    (f_eq_div_iff_boundarySafe n hn hnprime).trans
      (cofactorObstructionSafe_iff_boundarySafe n hn).symm

end Erdos700PartI

#print axioms Erdos700PartI.prime_le_largestPrime_of_dvd_cofactor
#print axioms Erdos700PartI.boundary_le_largestPrime_sq_cofactor
#print axioms Erdos700PartI.mul_le_half_iff_le_cofactor_half
#print axioms Erdos700PartI.cofactorObstructionSafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_cofactorObstructionSafe
