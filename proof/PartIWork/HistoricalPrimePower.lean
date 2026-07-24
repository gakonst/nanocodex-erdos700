import PartIWork.BaselineBoundary
import Mathlib.Data.Nat.Factorization.PrimePow

/-!
# The prime-power-component witness for the historical Erdős 700(i)
-/

namespace Erdos700PartI

theorem choose_prime_pow_mul_modEq
    (p m a : ℕ) (hp : p.Prime) :
    (p ^ a * m).choose (p ^ a) ≡ m [MOD p] := by
  letI : Fact p.Prime := ⟨hp⟩
  induction a with
  | zero => simp
  | succ a ih =>
      calc
        (p ^ (a + 1) * m).choose (p ^ (a + 1)) ≡
            ((p ^ (a + 1) * m) % p).choose
                ((p ^ (a + 1)) % p) *
              ((p ^ (a + 1) * m) / p).choose
                ((p ^ (a + 1)) / p) [MOD p] :=
          Choose.choose_modEq_choose_mod_mul_choose_div_nat
        _ = (p ^ a * m).choose (p ^ a) := by
          simp [pow_succ, hp.ne_zero, Nat.mul_assoc,
            Nat.mul_comm, Nat.mul_left_comm]
        _ ≡ m [MOD p] := ih

end Erdos700PartI

#print axioms Erdos700PartI.choose_prime_pow_mul_modEq
