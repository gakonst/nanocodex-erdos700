import PartIWork.BoundaryAntichain

/-!
# Divisor-poset characterization for Erdős 700(i)

The outer finite domain is the exact divisor poset `n.divisors`; the inner
domain is the exact cofactor-normalized multiplier interval.
-/

namespace Erdos700PartI

theorem mul_le_half_iff_le_divisorPoset_half
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

/-- A finite rejection certificate directly over the divisor poset. -/
def DivisorPosetSafe (n : ℕ) : Prop :=
  ∀ d ∈ n.divisors,
    Erdos700.P n < d →
    (∀ p, p.Prime → p ∣ d → d / p ≤ Erdos700.P n) →
    ∀ m ∈ Finset.Icc 1 ((n / d) / 2),
      ∃ p, p.Prime ∧ p ∣ d ∧
        n.factorization p - d.factorization p <
          residueCarryCount n (d * m) p

theorem divisorPosetSafe_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) :
    DivisorPosetSafe n ↔ BoundarySafe n := by
  classical
  unfold DivisorPosetSafe BoundarySafe
  constructor
  · intro hposet d hd hreal
    have hdmem : d ∈ n.divisors := by
      rw [Nat.mem_divisors]
      exact ⟨hd.1, by omega⟩
    obtain ⟨m, hm, hbound, hcarry⟩ := hreal
    have hdpos : 0 < d := Nat.pos_of_mem_divisors hdmem
    have hmcofactor : m ≤ (n / d) / 2 :=
      (mul_le_half_iff_le_divisorPoset_half n d m hdpos hd.1).mp hbound
    have hmmem : m ∈ Finset.Icc 1 ((n / d) / 2) :=
      Finset.mem_Icc.mpr ⟨by omega, hmcofactor⟩
    obtain ⟨p, hp, hpd, hbad⟩ :=
      hposet d hdmem hd.2.1 hd.2.2 m hmmem
    have hgood := hcarry p hp hpd
    omega
  · intro hsafe d hdmem hPd hprime m hmmem
    by_contra hreject
    push_neg at hreject
    have hdn : d ∣ n := Nat.dvd_of_mem_divisors hdmem
    have hdpos : 0 < d := Nat.pos_of_mem_divisors hdmem
    have hbound : d * m ≤ n / 2 :=
      (mul_le_half_iff_le_divisorPoset_half n d m hdpos hdn).mpr
        (Finset.mem_Icc.mp hmmem).2
    have hmpos : 0 < m := by
      have hmrange := Finset.mem_Icc.mp hmmem
      omega
    have hreal : Realized n d := by
      refine ⟨m, hmpos, hbound, ?_⟩
      intro p hp hpd
      have hnot := hreject p hp hpd
      omega
    exact hsafe d ⟨hdn, hPd, hprime⟩ hreal

theorem f_eq_div_iff_divisorPosetSafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ DivisorPosetSafe n := by
  exact
    (f_eq_div_iff_boundarySafe n hn hnprime).trans
      (divisorPosetSafe_iff_boundarySafe n hn).symm

end Erdos700PartI

#print axioms Erdos700PartI.mul_le_half_iff_le_divisorPoset_half
#print axioms Erdos700PartI.divisorPosetSafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_divisorPosetSafe
