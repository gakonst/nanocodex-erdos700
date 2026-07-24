import PartIWork.Characterization
import Mathlib.Data.Nat.PrimeFin

/-!
# Elementary facts about the largest-prime witness
-/

namespace Erdos700PartI

theorem largestPrime_mem_primeFactors (n : ℕ) (hn : 1 < n) :
    Erdos700.P n ∈ n.primeFactors := by
  rw [Erdos700.P]
  obtain ⟨p, hp, hsup⟩ :=
    Finset.exists_mem_eq_sup n.primeFactors
      (Nat.nonempty_primeFactors.2 hn) id
  rw [hsup]
  simpa using hp

theorem largestPrime_prime (n : ℕ) (hn : 1 < n) :
    (Erdos700.P n).Prime := by
  exact Nat.prime_of_mem_primeFactors (largestPrime_mem_primeFactors n hn)

theorem largestPrime_pos_dvd (n : ℕ) (hn : 1 < n) :
    0 < Erdos700.P n ∧ Erdos700.P n ∣ n := by
  have hmem := largestPrime_mem_primeFactors n hn
  exact
    ⟨(Nat.prime_of_mem_primeFactors hmem).pos,
      (Nat.mem_primeFactors.1 hmem).2.1⟩

theorem largestPrime_admissible
    (n : ℕ) (hn : 1 < n) (hnprime : ¬n.Prime) :
    Admissible n (Erdos700.P n) := by
  let p := Erdos700.P n
  change Admissible n p
  have hpprime : p.Prime := by
    simpa [p] using largestPrime_prime n hn
  have hpdvd : p ∣ n := by
    simpa [p] using (largestPrime_pos_dvd n hn).2
  obtain ⟨c, hc⟩ := hpdvd
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hcne : c ≠ 1 := by
    intro hc1
    apply hnprime
    have hn_eq : n = p := by
      simpa [hc1] using hc
    rw [hn_eq]
    exact hpprime
  have hc2 : 2 ≤ c := by omega
  have htwo : 2 * p ≤ n := by
    calc
      2 * p ≤ c * p := Nat.mul_le_mul_right p hc2
      _ = n := by simpa [Nat.mul_comm] using hc.symm
  exact ⟨hpprime.one_lt, by omega⟩

theorem largestPrime_coprime_choose_pred
    (n : ℕ) (hn : 1 < n) :
    (Erdos700.P n).Coprime
      ((n - 1).choose (Erdos700.P n - 1)) := by
  let p := Erdos700.P n
  change p.Coprime ((n - 1).choose (p - 1))
  have hpprime : p.Prime := by
    simpa [p] using largestPrime_prime n hn
  have hpdvd : p ∣ n := by
    simpa [p] using (largestPrime_pos_dvd n hn).2
  obtain ⟨c, hc⟩ := hpdvd
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hp_pred_lt : p - 1 < p := by
    exact Nat.pred_lt hpprime.pos.ne'
  have hp_le_mul : p ≤ p * c :=
    Nat.le_mul_of_pos_right p hcpos
  have hn_pred :
      n - 1 = p * (c - 1) + (p - 1) := by
    rw [hc]
    rw [Nat.mul_sub_left_distrib]
    simp only [Nat.mul_one]
    omega
  have hn_pred_mod : (n - 1) % p = p - 1 := by
    rw [hn_pred]
    simp [Nat.mod_eq_of_lt hp_pred_lt]
  letI : Fact p.Prime := ⟨hpprime⟩
  have hLucas :=
    Choose.choose_modEq_choose_mod_mul_choose_div_nat
      (p := p) (n := n - 1) (k := p - 1)
  have hmod :
      (n - 1).choose (p - 1) ≡ 1 [MOD p] := by
    simpa [hn_pred_mod, Nat.mod_eq_of_lt hp_pred_lt,
      Nat.div_eq_of_lt hp_pred_lt] using hLucas
  exact
    (Nat.coprime_of_mul_modEq_one 1
      (by simpa using hmod)).symm

theorem largestPrime_gcd_choose
    (n : ℕ) (hn : 1 < n) :
    Nat.gcd n (n.choose (Erdos700.P n)) =
      n / Erdos700.P n := by
  let p := Erdos700.P n
  change Nat.gcd n (n.choose p) = n / p
  have hpprime : p.Prime := by
    simpa [p] using largestPrime_prime n hn
  have hpdvd : p ∣ n := by
    simpa [p] using (largestPrime_pos_dvd n hn).2
  obtain ⟨c, hc⟩ := hpdvd
  have hn_mul : n = c * p := by
    simpa [Nat.mul_comm] using hc
  have hchoose :
      n.choose p = c * (n - 1).choose (p - 1) := by
    rw [hn_mul, Nat.choose_mul_right hpprime.ne_zero]
  have hcop :
      p.Coprime ((n - 1).choose (p - 1)) := by
    simpa [p] using largestPrime_coprime_choose_pred n hn
  calc
    Nat.gcd n (n.choose p) =
        Nat.gcd (c * p) (c * (n - 1).choose (p - 1)) := by
          rw [← hn_mul, ← hchoose]
    _ = c * Nat.gcd p ((n - 1).choose (p - 1)) := by
      rw [Nat.gcd_mul_left]
    _ = c := by rw [hcop.gcd_eq_one, Nat.mul_one]
    _ = n / p := by simp [hc, hpprime.ne_zero]

theorem largestPrime_witness
    (n : ℕ) (hn : 1 < n) (hnprime : ¬n.Prime) :
    residueCarryWeight n (Erdos700.P n) = Erdos700.P n := by
  have hnpos : 0 < n := by omega
  have hadmissible :=
    largestPrime_admissible n hn hnprime
  have hexact :=
    (residueCarryWeight_exact n (Erdos700.P n)
      hnpos hadmissible).2
  rw [largestPrime_gcd_choose n hn] at hexact
  have hcanonical :
      n / Erdos700.P n * Erdos700.P n = n :=
    Nat.div_mul_cancel (largestPrime_pos_dvd n hn).2
  have hquotpos : 0 < n / Erdos700.P n :=
    Nat.div_pos
      (Nat.le_of_dvd hnpos (largestPrime_pos_dvd n hn).2)
      (largestPrime_pos_dvd n hn).1
  exact
    Nat.mul_left_cancel hquotpos
      (hexact.trans hcanonical.symm)

theorem f_eq_div_iff_residueCarrySafe_complete
    (n : ℕ) (hn : 1 < n) (hnprime : ¬n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ ResidueCarrySafe n := by
  exact
    f_eq_div_iff_residueCarrySafe_of_witness
      n (Erdos700.P n)
      (by omega)
      (largestPrime_pos_dvd n hn).1
      (largestPrime_pos_dvd n hn).2
      (largestPrime_admissible n hn hnprime)
      (largestPrime_witness n hn hnprime)

end Erdos700PartI

#print axioms Erdos700PartI.largestPrime_admissible
#print axioms Erdos700PartI.largestPrime_gcd_choose
#print axioms Erdos700PartI.largestPrime_witness
#print axioms Erdos700PartI.f_eq_div_iff_residueCarrySafe_complete
