import FormalConjectures.ErdosProblems.«700»

/-!
# The finite-order bridge for Erdős 700(i)

This file isolates the order-theoretic end of the proposed carry
characterization.  It deliberately makes the exact Kummer calculation a
hypothesis: once `weight n k` has been proved to be the complementary divisor
of `gcd(n, n.choose k)`, the characterization of `f n = n / P` is elementary
and independent of the open theorem in Formal Conjectures.
-/

namespace Erdos700PartI

/-- The indices occurring in the definition of `Erdos700.f`. -/
def Admissible (n k : ℕ) : Prop := 1 < k ∧ k ≤ n / 2

/--
The carry predicate, abstracted over the exact carry weight.

`weight` will eventually be instantiated by the finite product of the
prime-power layers omitted by the binomial coefficient.
-/
def CarrySafe (n P : ℕ) (weight : ℕ → ℕ) : Prop :=
  ∀ k, Admissible n k → weight k ≤ P

/--
If every admissible gcd is at least `d` and one admissible index attains `d`,
then the infimum defining `Erdos700.f` is exactly `d`.
-/
theorem f_eq_of_gcd_bounds_and_witness
    (n d witness : ℕ)
    (hwitness : Admissible n witness)
    (hattain : Nat.gcd n (n.choose witness) = d)
    (hlower : ∀ k, Admissible n k → d ≤ Nat.gcd n (n.choose k)) :
    Erdos700.f n = d := by
  have hne : (Erdos700.fSet n).Nonempty :=
    ⟨_, Erdos700.f_mem n witness hwitness.1 hwitness.2⟩
  obtain ⟨k, hk1, hk2, hkeq⟩ := Nat.sInf_mem hne
  apply Nat.le_antisymm
  · calc
      Erdos700.f n ≤ Nat.gcd n (n.choose witness) :=
        Erdos700.f_le n witness hwitness.1 hwitness.2
      _ = d := hattain
  · rw [Erdos700.f_eq, hkeq]
    exact hlower k ⟨hk1, hk2⟩

/--
The exact arithmetic interface supplied by Kummer's theorem.

Writing `W(k)` for the product of omitted prime-power layers, the desired
formula is `gcd(n, n.choose k) * W(k) = n`.  Positivity rules out the degenerate
factorization `0 * W = 0`.
-/
def ExactCarryWeight (n : ℕ) (weight : ℕ → ℕ) : Prop :=
  ∀ k, Admissible n k →
    0 < weight k ∧ Nat.gcd n (n.choose k) * weight k = n

/--
The finite-order part of the carry characterization.

The assumptions say:

* `P` is a positive divisor of `n`;
* `weight` is the exact complementary divisor of every admissible gcd;
* one admissible prime witness has weight exactly `P`.

No binomial valuation theorem and no open Erdős-700 theorem is used below.
-/
theorem f_eq_div_iff_carrySafe
    (n P witness : ℕ)
    (weight : ℕ → ℕ)
    (hn : 0 < n)
    (hP : 0 < P)
    (hPdvd : P ∣ n)
    (hexact : ExactCarryWeight n weight)
    (hwitness : Admissible n witness)
    (hwitnessWeight : weight witness = P) :
    Erdos700.f n = n / P ↔ CarrySafe n P weight := by
  have hnP : n / P * P = n := Nat.div_mul_cancel hPdvd
  constructor
  · intro hf k hk
    have hfle : Erdos700.f n ≤ Nat.gcd n (n.choose k) :=
      Erdos700.f_le n k hk.1 hk.2
    obtain ⟨hwpos, hexactk⟩ := hexact k hk
    rw [hf] at hfle
    by_contra hnle
    have hPweight : P < weight k := Nat.lt_of_not_ge hnle
    have hP_le_n : P ≤ n := Nat.le_of_dvd hn hPdvd
    have hnPpos : 0 < n / P := Nat.div_pos hP_le_n hP
    have hlt :
        n / P * P < n / P * weight k :=
      Nat.mul_lt_mul_of_pos_left hPweight hnPpos
    have hle :
        n / P * weight k ≤ Nat.gcd n (n.choose k) * weight k :=
      Nat.mul_le_mul_right (weight k) hfle
    omega
  · intro hsafe
    apply f_eq_of_gcd_bounds_and_witness n (n / P) witness hwitness
    · obtain ⟨_, hexactWitness⟩ := hexact witness hwitness
      rw [hwitnessWeight] at hexactWitness
      exact Nat.eq_div_of_mul_eq_right hP.ne'
        (by simpa [Nat.mul_comm] using hexactWitness)
    · intro k hk
      obtain ⟨hwpos, hexactk⟩ := hexact k hk
      have hwle : weight k ≤ P := hsafe k hk
      by_contra hnle
      have hglt :
          Nat.gcd n (n.choose k) < n / P := Nat.lt_of_not_ge hnle
      have hlt :
          Nat.gcd n (n.choose k) * weight k < n / P * weight k :=
        Nat.mul_lt_mul_of_pos_right hglt hwpos
      have hle : n / P * weight k ≤ n / P * P :=
        Nat.mul_le_mul_left (n / P) hwle
      omega

end Erdos700PartI

#print axioms Erdos700PartI.f_eq_of_gcd_bounds_and_witness
#print axioms Erdos700PartI.f_eq_div_iff_carrySafe
