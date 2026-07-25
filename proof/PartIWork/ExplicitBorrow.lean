import PartIWork.FactorTableau

/-!
Typed local borrow rows and exact variable counts for the explicit
selector/borrow presentation of the Part (i) factor tableau.

All subtraction is performed in `ℤ`.  Digits are bounded integers and the
incoming and outgoing borrows are Boolean, avoiding truncated subtraction and
fractional solutions.
-/

namespace Erdos700PartI.ExplicitTableau

def bit : Bool → ℤ
  | false => 0
  | true => 1

def BorrowRow (p xi eta : ℤ) (incoming outgoing : Bool) : Prop :=
  1 - p + p * bit outgoing ≤ xi + bit incoming - eta ∧
    xi + bit incoming - eta ≤ p * bit outgoing

def resultDigit (p xi eta : ℤ) (incoming outgoing : Bool) : ℤ :=
  eta - xi - bit incoming + p * bit outgoing

/-- The signed row selects precisely whether subtraction borrows. -/
theorem borrowRow_iff_outgoing
    (p xi eta : ℤ) (incoming outgoing : Bool)
    (hxi0 : 0 ≤ xi) (hxip : xi < p)
    (heta0 : 0 ≤ eta) (hetap : eta < p) :
    BorrowRow p xi eta incoming outgoing ↔
      (outgoing = true ↔ eta < xi + bit incoming) := by
  cases incoming <;> cases outgoing <;>
    simp [BorrowRow, bit] at * <;> omega

/-- Equivalently, the row says that the resulting digit lies in `[0,p)`. -/
theorem borrowRow_iff_resultDigit
    (p xi eta : ℤ) (incoming outgoing : Bool) :
    BorrowRow p xi eta incoming outgoing ↔
      0 ≤ resultDigit p xi eta incoming outgoing ∧
        resultDigit p xi eta incoming outgoing < p := by
  cases incoming <;> cases outgoing <;>
    simp [BorrowRow, resultDigit, bit] <;> omega

abbrev SelectorIdx (r : ℕ) (a : Fin r → ℕ) :=
  Σ i : Fin r, Fin (a i + 1)

abbrev DigitIdx (r : ℕ) (h : Fin r → ℕ) :=
  Σ i : Fin r, Fin (h i + 1)

abbrev BorrowIdx (r : ℕ) (h : Fin r → ℕ) :=
  Σ i : Fin r, Fin (h i + 2)

/-- The first coordinate chooses the divisor or common-multiple prefix array. -/
abbrev PrefixIdx (r : ℕ) := Fin 2 × Fin (r + 1)

abbrev VarIdx (r : ℕ) (a h : Fin r → ℕ) :=
  SelectorIdx r a ⊕ (DigitIdx r h ⊕ (BorrowIdx r h ⊕ PrefixIdx r))

theorem card_selector (r : ℕ) (a : Fin r → ℕ) :
    Fintype.card (SelectorIdx r a) = ∑ i : Fin r, (a i + 1) := by
  simp [SelectorIdx]

theorem card_digit (r : ℕ) (h : Fin r → ℕ) :
    Fintype.card (DigitIdx r h) = ∑ i : Fin r, (h i + 1) := by
  simp [DigitIdx]

theorem card_borrow (r : ℕ) (h : Fin r → ℕ) :
    Fintype.card (BorrowIdx r h) = ∑ i : Fin r, (h i + 2) := by
  simp [BorrowIdx]

theorem card_prefix (r : ℕ) :
    Fintype.card (PrefixIdx r) = 2 * (r + 1) := by
  simp [PrefixIdx]

/-- Exact count of selector, digit, borrow, and prefix variables. -/
theorem card_var_exact (r : ℕ) (a h : Fin r → ℕ) :
    Fintype.card (VarIdx r a h) =
      (∑ i : Fin r, a i) + 2 * (∑ i : Fin r, h i) + 6 * r + 2 := by
  simp [VarIdx, SelectorIdx, DigitIdx, BorrowIdx, PrefixIdx,
    Finset.sum_add_distrib]
  ring

private theorem sum_le_card_mul
    (r n : ℕ) (f : Fin r → ℕ) (hf : ∀ i, f i ≤ n) :
    (∑ i : Fin r, f i) ≤ r * n := by
  calc
    (∑ i : Fin r, f i) ≤ ∑ _i : Fin r, n := by
      exact Finset.sum_le_sum fun i _hi => hf i
    _ = r * n := by simp

/-- A coarse explicit bound used by the sparse-encoding argument. -/
theorem card_var_le
    (r n : ℕ) (a h : Fin r → ℕ)
    (ha : ∀ i, a i ≤ n) (hh : ∀ i, h i ≤ n) :
    Fintype.card (VarIdx r a h) ≤ 3 * (r * n) + 6 * r + 2 := by
  rw [card_var_exact]
  have ha' : (∑ i : Fin r, a i) ≤ r * n :=
    sum_le_card_mul r n a ha
  have hh' : (∑ i : Fin r, h i) ≤ r * n :=
    sum_le_card_mul r n h hh
  omega

end Erdos700PartI.ExplicitTableau
