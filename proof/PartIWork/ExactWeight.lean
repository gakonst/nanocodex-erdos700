import PartIWork.ResidueCarry

/-!
# Reconstruction of the exact complementary carry weight
-/

namespace Erdos700PartI

theorem residueCarryWeight_pos
    (n k : ℕ) :
    0 < residueCarryWeight n k := by
  classical
  apply Finset.prod_pos
  intro p hp
  exact pow_pos (Nat.prime_of_mem_primeFactors hp).pos _

theorem factorization_residueCarryWeight
    (n k q : ℕ) (hq : q.Prime) :
    (residueCarryWeight n k).factorization q =
      if q ∈ n.primeFactors then
        n.factorization q - residueCarryCount n k q
      else 0 := by
  classical
  rw [residueCarryWeight, Nat.factorization_prod_apply]
  · simp only [Nat.factorization_pow]
    by_cases hmem : q ∈ n.primeFactors
    · rw [if_pos hmem, Finset.sum_eq_single q]
      · simp [hq.factorization_self]
      · intro p hp hpq
        have hpprime := Nat.prime_of_mem_primeFactors hp
        have hfac : p.factorization q = 0 := by
          rw [hpprime.factorization]
          simp [Ne.symm hpq]
        simp [hfac]
      · exact fun h => (h hmem).elim
    · rw [if_neg hmem]
      apply Finset.sum_eq_zero
      intro p hp
      have hpprime := Nat.prime_of_mem_primeFactors hp
      have hpq : p ≠ q := by
        intro heq
        subst p
        exact hmem hp
      have hfac : p.factorization q = 0 := by
        rw [hpprime.factorization]
        simp [Ne.symm hpq]
      simp [hfac]
  · intro p hp
    exact pow_ne_zero _ (Nat.prime_of_mem_primeFactors hp).ne_zero

theorem residueCarryWeight_exact
    (n k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    0 < residueCarryWeight n k ∧
      Nat.gcd n (n.choose k) * residueCarryWeight n k = n := by
  have hwpos := residueCarryWeight_pos n k
  refine ⟨hwpos, ?_⟩
  have hk_le_n : k ≤ n := by
    have : n / 2 ≤ n := Nat.div_le_self n 2
    exact hk.2.trans this
  have hchoose : 0 < n.choose k := Nat.choose_pos hk_le_n
  apply Nat.eq_of_factorization_eq
    (Nat.mul_pos (Nat.gcd_pos_of_pos_left _ hn) hwpos).ne'
    hn.ne'
  intro q
  by_cases hq : q.Prime
  · rw [Nat.factorization_mul
      (Nat.gcd_pos_of_pos_left (n.choose k) hn).ne' hwpos.ne',
      Nat.factorization_gcd hn.ne' hchoose.ne']
    change
      min (n.factorization q) ((n.choose k).factorization q) +
          (residueCarryWeight n k).factorization q =
        n.factorization q
    rw [factorization_residueCarryWeight n k q hq,
      residueCarryCount_eq_factorization_choose n k q hq hk_le_n]
    have hqmem : q ∈ n.primeFactors ↔ q ∣ n :=
      by simp [Nat.mem_primeFactors, hq, hn.ne']
    by_cases hqn : q ∣ n
    · rw [if_pos (hqmem.2 hqn)]
      omega
    · rw [if_neg (mt hqmem.1 hqn)]
      have hfac : n.factorization q = 0 := by
        exact Nat.factorization_eq_zero_of_not_dvd hqn
      simp [hfac]
  · simp [Nat.factorization_eq_zero_of_not_prime, hq]

theorem exactCarryWeight_residueCarryWeight (n : ℕ) (hn : 0 < n) :
    ExactCarryWeight n (residueCarryWeight n) := by
  intro k hk
  exact residueCarryWeight_exact n k hn hk

end Erdos700PartI

#print axioms Erdos700PartI.residueCarryWeight_exact
