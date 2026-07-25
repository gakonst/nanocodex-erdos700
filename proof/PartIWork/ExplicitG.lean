import PartIWork.FactorTableau
import PartIWork.ExplicitBorrow

namespace Erdos700PartI

open scoped BigOperators
open ExplicitTableau

noncomputable section

structure OrderedPrimeFactorization (n r : ℕ) where
  p : Fin r → ℕ
  a : Fin r → ℕ
  prime : ∀ i, (p i).Prime
  exponent_pos : ∀ i, 0 < a i
  ordered : StrictMono p
  prod_eq : (∏ i : Fin r, p i ^ a i) = n

namespace OrderedPrimeFactorization

variable {n r : ℕ}

def primeEmbedding (F : OrderedPrimeFactorization n r) : Fin r ↪ ℕ where
  toFun := F.p
  inj' := F.ordered.injective

@[simp]
theorem primeEmbedding_apply
    (F : OrderedPrimeFactorization n r) (i : Fin r) :
    F.primeEmbedding i = F.p i :=
  rfl

end OrderedPrimeFactorization

/-- Encode exponents attached to the ordered primes as a `Finsupp`. -/
def exponentVector {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ) : ℕ →₀ ℕ :=
  ∑ i : Fin r, Finsupp.single (F.p i) (e i)

@[simp]
theorem exponentVector_apply_prime {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ) (i : Fin r) :
    exponentVector F e (F.p i) = e i := by
  classical
  have hp : ∀ j : Fin r, F.p j = F.p i ↔ j = i := by
    intro j
    constructor
    · intro h
      exact F.ordered.injective h
    · intro h
      subst j
      rfl
  simp [exponentVector, Finsupp.single_apply, hp]

theorem exponentVector_apply_eq_zero_of_not_image {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ) (q : ℕ)
    (hq : ∀ i, F.p i ≠ q) :
    exponentVector F e q = 0 := by
  classical
  simp [exponentVector, Finsupp.single_apply, hq]

theorem mem_support_exponentVector_iff {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ) (q : ℕ) :
    q ∈ (exponentVector F e).support ↔
      ∃ i : Fin r, F.p i = q ∧ e i ≠ 0 := by
  classical
  by_cases hq : ∃ i : Fin r, F.p i = q
  · rcases hq with ⟨i, rfl⟩
    rw [Finsupp.mem_support_iff, exponentVector_apply_prime]
    constructor
    · intro hi
      exact ⟨i, rfl, hi⟩
    · rintro ⟨j, hj, hne⟩
      have hji : j = i := F.ordered.injective hj
      simpa [hji] using hne
  · have hnone : ∀ i : Fin r, F.p i ≠ q := by
      intro i hi
      exact hq ⟨i, hi⟩
    rw [Finsupp.mem_support_iff,
      exponentVector_apply_eq_zero_of_not_image F e q hnone]
    constructor
    · intro h
      exact (h rfl).elim
    · rintro ⟨i, hi, _⟩
      exact (hq ⟨i, hi⟩).elim

theorem exponentProduct_exponentVector {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ) :
    exponentProduct (exponentVector F e) =
      ∏ i : Fin r, F.p i ^ e i := by
  classical
  let S : Finset (Fin r) :=
    Finset.univ.filter fun i => e i ≠ 0
  have hsupp :
      (exponentVector F e).support = S.map F.primeEmbedding := by
    apply Finset.ext
    intro q
    rw [mem_support_exponentVector_iff]
    constructor
    · rintro ⟨i, hip, hie⟩
      refine Finset.mem_map.mpr ⟨i, ?_, ?_⟩
      · simp [S, hie]
      · simpa using hip
    · intro hq
      rcases Finset.mem_map.mp hq with ⟨i, hi, hip⟩
      refine ⟨i, ?_, ?_⟩
      · simpa using hip
      · simpa [S] using hi
  unfold exponentProduct
  change
    (exponentVector F e).support.prod
        (fun q => q ^ exponentVector F e q) =
      ∏ i : Fin r, F.p i ^ e i
  rw [hsupp]
  simp only [Finset.prod_map,
    OrderedPrimeFactorization.primeEmbedding_apply,
    exponentVector_apply_prime]
  apply Finset.prod_subset (Finset.filter_subset _ _)
  intro i _ hi
  have hei : e i = 0 := by
    by_contra hne
    exact hi (by simp [S, hne])
  simp [hei]

def fullExponent {n r : ℕ}
    (F : OrderedPrimeFactorization n r) : ℕ →₀ ℕ :=
  exponentVector F F.a

theorem fullExponent_support_prime {n r : ℕ}
    (F : OrderedPrimeFactorization n r) :
    ∀ q, q ∈ (fullExponent F).support → q.Prime := by
  intro q hq
  have hq' : q ∈ (exponentVector F F.a).support := by
    simpa [fullExponent] using hq
  rcases (mem_support_exponentVector_iff F F.a q).mp hq' with
    ⟨i, rfl, _⟩
  exact F.prime i

/-- Equality between the supplied ordered factorization and `Nat.factorization`. -/
theorem factorization_eq_fullExponent {n r : ℕ}
    (F : OrderedPrimeFactorization n r) :
    n.factorization = fullExponent F := by
  have hfac :=
    factorization_exponentProduct
      (fullExponent F) (fullExponent_support_prime F)
  have hprod : exponentProduct (fullExponent F) = n := by
    calc
      exponentProduct (fullExponent F) =
          ∏ i : Fin r, F.p i ^ F.a i := by
            simpa [fullExponent] using
              exponentProduct_exponentVector F F.a
      _ = n := F.prod_eq
  rw [hprod] at hfac
  exact hfac

@[simp]
theorem factorization_apply_prime {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (i : Fin r) :
    n.factorization (F.p i) = F.a i := by
  calc
    n.factorization (F.p i) =
        fullExponent F (F.p i) :=
      congrArg (fun E : ℕ →₀ ℕ => E (F.p i))
        (factorization_eq_fullExponent F)
    _ = F.a i := by simp [fullExponent]

theorem mem_factorization_support_iff {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (q : ℕ) :
    q ∈ n.factorization.support ↔ ∃ i : Fin r, F.p i = q := by
  rw [factorization_eq_fullExponent F]
  change q ∈ (exponentVector F F.a).support ↔ _
  rw [mem_support_exponentVector_iff]
  constructor
  · rintro ⟨i, hi, _⟩
    exact ⟨i, hi⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, hi, (F.exponent_pos i).ne'⟩

theorem exponentVector_values_eq {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hsupp : ∀ q, q ∈ E.support → ∃ i : Fin r, F.p i = q) :
    exponentVector F (fun i => E (F.p i)) = E := by
  classical
  ext q
  by_cases hq : ∃ i : Fin r, F.p i = q
  · rcases hq with ⟨i, rfl⟩
    simp
  · have hnone : ∀ i : Fin r, F.p i ≠ q := by
      intro i hi
      exact hq ⟨i, hi⟩
    have hz :
        exponentVector F (fun i => E (F.p i)) q = 0 :=
      exponentVector_apply_eq_zero_of_not_image
        F (fun i => E (F.p i)) q hnone
    have hEq : E q = 0 := by
      by_contra hne
      rcases hsupp q (Finsupp.mem_support_iff.mpr hne) with ⟨i, hi⟩
      exact hq ⟨i, hi⟩
    rw [hz, hEq]

theorem exponentVector_le_full {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ)
    (he : ∀ i, e i ≤ F.a i) :
    exponentVector F e ≤ fullExponent F := by
  rw [Finsupp.le_def]
  intro q
  by_cases hq : ∃ i : Fin r, F.p i = q
  · rcases hq with ⟨i, rfl⟩
    simpa [fullExponent] using he i
  · have hnone : ∀ i : Fin r, F.p i ≠ q := by
      intro i hi
      exact hq ⟨i, hi⟩
    change exponentVector F e q ≤ exponentVector F F.a q
    rw [exponentVector_apply_eq_zero_of_not_image F e q hnone,
      exponentVector_apply_eq_zero_of_not_image F F.a q hnone]

theorem exponentVector_le_factorization {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (e : Fin r → ℕ)
    (he : ∀ i, e i ≤ F.a i) :
    exponentVector F e ≤ n.factorization := by
  rw [factorization_eq_fullExponent F]
  exact exponentVector_le_full F e he

theorem support_indexed_of_le_factorization {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) :
    ∀ q, q ∈ E.support → ∃ i : Fin r, F.p i = q := by
  intro q hq
  have hne : E q ≠ 0 := Finsupp.mem_support_iff.mp hq
  have hle : E q ≤ n.factorization q := hE q
  have hnne : n.factorization q ≠ 0 := by
    intro hn0
    have : E q = 0 := by omega
    exact hne this
  exact (mem_factorization_support_iff F q).mp
    (Finsupp.mem_support_iff.mpr hnne)

/-- The key reverse-direction Finsupp round trip. -/
theorem exponentVector_factorization_roundtrip {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) :
    exponentVector F (fun i => E (F.p i)) = E :=
  exponentVector_values_eq F E
    (support_indexed_of_le_factorization F E hE)

/-! Boolean one-hot selectors. -/

def OneHot {a : ℕ} (y : Fin (a + 1) → Bool) : Prop :=
  (∑ j : Fin (a + 1), bit (y j)) = (1 : ℤ)

def selectorOf {a : ℕ} (e : Fin (a + 1)) :
    Fin (a + 1) → Bool :=
  fun j => if j = e then true else false

def selectedExponentZ {a : ℕ} (y : Fin (a + 1) → Bool) : ℤ :=
  ∑ j : Fin (a + 1), (j.val : ℤ) * bit (y j)

def zeroExponent (a : ℕ) : Fin (a + 1) :=
  ⟨0, Nat.zero_lt_succ a⟩

def supportBitZ {a : ℕ} (y : Fin (a + 1) → Bool) : ℤ :=
  1 - bit (y (zeroExponent a))

private theorem sum_bit_eq_card_filter
    {α : Type*} [DecidableEq α]
    (s : Finset α) (y : α → Bool) :
    (∑ x ∈ s, bit (y x)) =
      (((s.filter fun x => y x = true).card : ℕ) : ℤ) := by
  induction s using Finset.induction_on with
  | empty =>
      simp
  | @insert x s hx ih =>
      rw [Finset.sum_insert hx]
      rw [Finset.filter_insert]
      simp only [bit] at ih
      cases h : y x <;> simp [hx, h, ih, bit, add_comm]

theorem oneHot_unique {a : ℕ} (y : Fin (a + 1) → Bool)
    (hy : OneHot y) :
    ∃ e : Fin (a + 1), ∀ j, y j = true ↔ j = e := by
  classical
  let S : Finset (Fin (a + 1)) :=
    Finset.univ.filter fun j => y j = true
  have hcardZ : (S.card : ℤ) = 1 := by
    calc
      (S.card : ℤ) = ∑ j : Fin (a + 1), bit (y j) := by
        symm
        simpa [S] using
          (sum_bit_eq_card_filter (Finset.univ) y)
      _ = 1 := hy
  have hcard : S.card = 1 := by omega
  rcases Finset.card_eq_one.mp hcard with ⟨e, he⟩
  refine ⟨e, ?_⟩
  intro j
  constructor
  · intro hj
    have hm : j ∈ S := by simp [S, hj]
    rw [he] at hm
    simpa using hm
  · intro hje
    have hm : j ∈ ({e} : Finset (Fin (a + 1))) := by
      simpa using hje
    rw [← he] at hm
    simpa [S] using hm

theorem eq_selectorOf_of_oneHot {a : ℕ}
    (y : Fin (a + 1) → Bool) (hy : OneHot y) :
    ∃ e : Fin (a + 1), y = selectorOf e := by
  classical
  rcases oneHot_unique y hy with ⟨e, he⟩
  refine ⟨e, funext ?_⟩
  intro j
  by_cases hje : j = e
  · subst j
    have ht : y e = true := (he e).2 rfl
    simpa [selectorOf] using ht
  · have hnot : y j ≠ true := by
      intro ht
      exact hje ((he j).1 ht)
    cases hj : y j with
    | false =>
        simp [selectorOf, hje, hj]
    | true =>
        exact (hnot hj).elim

theorem selectorOf_oneHot {a : ℕ} (e : Fin (a + 1)) :
    OneHot (selectorOf e) := by
  classical
  rw [OneHot]
  calc
    (∑ j : Fin (a + 1), bit (selectorOf e j)) =
        (((Finset.univ.filter fun j : Fin (a + 1) =>
          selectorOf e j = true).card : ℕ) : ℤ) := by
            simpa using
              (sum_bit_eq_card_filter (Finset.univ) (selectorOf e))
    _ = 1 := by
      have hf :
          Finset.univ.filter (fun j : Fin (a + 1) =>
            selectorOf e j = true) = {e} := by
        ext j
        simp [selectorOf]
      rw [hf]
      simp

@[simp]
theorem selectedExponentZ_selectorOf {a : ℕ}
    (e : Fin (a + 1)) :
    selectedExponentZ (selectorOf e) = (e.val : ℤ) := by
  classical
  unfold selectedExponentZ
  simp only [selectorOf]
  simp_rw [show ∀ j : Fin (a + 1),
      bit (if j = e then true else false) =
        if j = e then (1 : ℤ) else 0 by
    intro j
    by_cases h : j = e <;> simp [h, bit]]
  simp

@[simp]
theorem supportBitZ_selectorOf {a : ℕ}
    (e : Fin (a + 1)) :
    supportBitZ (selectorOf e) =
      if e.val = 0 then (0 : ℤ) else 1 := by
  by_cases he : e.val = 0
  · have heq : e = zeroExponent a := by
      apply Fin.ext
      simpa [zeroExponent] using he
    rw [heq]
    simp [supportBitZ, selectorOf, zeroExponent, bit]
  · have hne : zeroExponent a ≠ e := by
      intro h
      apply he
      simpa [zeroExponent] using congrArg Fin.val h.symm
    have hs : selectorOf e (zeroExponent a) = false := by
      simp [selectorOf, hne]
    rw [supportBitZ, hs]
    simp [bit, he]

def exponentChoice {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) (i : Fin r) :
    Fin (F.a i + 1) := by
  refine ⟨E (F.p i), Nat.lt_succ_of_le ?_⟩
  have hi : E (F.p i) ≤ n.factorization (F.p i) := hE _
  simpa using hi

@[simp]
theorem exponentChoice_val {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) (i : Fin r) :
    (exponentChoice F E hE i).val = E (F.p i) :=
  rfl

/-- Decode an arbitrary family of one-hot rows. -/
theorem selectorFamily_sound {n r : ℕ}
    (F : OrderedPrimeFactorization n r)
    (y : (i : Fin r) → Fin (F.a i + 1) → Bool)
    (hy : ∀ i, OneHot (y i)) :
    ∃ e : (i : Fin r) → Fin (F.a i + 1),
      (∀ i, y i = selectorOf (e i)) ∧
      (∀ i, selectedExponentZ (y i) = ((e i).val : ℤ)) ∧
      (∀ i, supportBitZ (y i) =
        if (e i).val = 0 then (0 : ℤ) else 1) ∧
      exponentVector F (fun i => (e i).val) ≤ n.factorization ∧
      (∀ q, q ∈ (exponentVector F (fun i => (e i).val)).support ↔
        ∃ i, F.p i = q ∧ (e i).val ≠ 0) ∧
      exponentProduct (exponentVector F (fun i => (e i).val)) =
        ∏ i : Fin r, F.p i ^ (e i).val := by
  classical
  let e : (i : Fin r) → Fin (F.a i + 1) :=
    fun i => Classical.choose (eq_selectorOf_of_oneHot (y i) (hy i))
  have he : ∀ i, y i = selectorOf (e i) := by
    intro i
    simpa [e] using
      Classical.choose_spec (eq_selectorOf_of_oneHot (y i) (hy i))
  refine ⟨e, he, ?_, ?_, ?_, ?_, ?_⟩
  · intro i
    rw [he i]
    exact selectedExponentZ_selectorOf (e i)
  · intro i
    rw [he i]
    exact supportBitZ_selectorOf (e i)
  · apply exponentVector_le_factorization F
    intro i
    exact Nat.le_of_lt_succ (e i).isLt
  · intro q
    exact mem_support_exponentVector_iff F (fun i => (e i).val) q
  · exact exponentProduct_exponentVector F (fun i => (e i).val)

/-- Construct selectors explicitly from a semantic `E ≤ n.factorization`. -/
theorem selectorFamily_complete {n r : ℕ}
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) :
    ∃ (e : (i : Fin r) → Fin (F.a i + 1))
      (y : (i : Fin r) → Fin (F.a i + 1) → Bool),
      (∀ i, (e i).val = E (F.p i)) ∧
      (∀ i, OneHot (y i)) ∧
      (∀ i, y i = selectorOf (e i)) ∧
      (∀ i, selectedExponentZ (y i) = (E (F.p i) : ℤ)) ∧
      (∀ i, supportBitZ (y i) =
        if E (F.p i) = 0 then (0 : ℤ) else 1) ∧
      exponentVector F (fun i => (e i).val) = E := by
  let e : (i : Fin r) → Fin (F.a i + 1) :=
    fun i => exponentChoice F E hE i
  let y : (i : Fin r) → Fin (F.a i + 1) → Bool :=
    fun i => selectorOf (e i)
  refine ⟨e, y, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i
    rfl
  · intro i
    exact selectorOf_oneHot (e i)
  · intro i
    rfl
  · intro i
    simp [y, e, exponentChoice]
  · intro i
    simp [y, e, exponentChoice]
  · simpa [e, exponentChoice] using
      exponentVector_factorization_roundtrip F E hE

end

end Erdos700PartI

namespace Erdos700PartI
namespace DigitBorrowBridge

open scoped BigOperators
open ExplicitTableau

def finAt {α : Type*} {L : ℕ} (x : Fin L → α)
    (default : α) (j : ℕ) : α :=
  if hj : j < L then x ⟨j, hj⟩ else default

def restrict {α : Type*} (L : ℕ) (f : ℕ → α) : Fin L → α :=
  fun j => f j.val

@[simp] theorem finAt_restrict {α : Type*} (f : ℕ → α) (z : α)
    {L j : ℕ} (hj : j < L) :
    finAt (restrict L f) z j = f j := by
  simp [finAt, restrict, hj]

/-- Least-significant-digit-first evaluation. -/
def evalDigits (p : ℤ) (d : ℕ → ℤ) : ℕ → ℤ
  | 0 => 0
  | L + 1 => d 0 + p * evalDigits p (fun j => d (j + 1)) L

theorem evalDigits_congr (p : ℤ) (d e : ℕ → ℤ) (L : ℕ)
    (h : ∀ j, j < L → d j = e j) :
    evalDigits p d L = evalDigits p e L := by
  induction L generalizing d e with
  | zero => rfl
  | succ L ih =>
      simp only [evalDigits]
      have h0 : d 0 = e 0 := h 0 (by omega)
      have ht :
          evalDigits p (fun j => d (j + 1)) L =
            evalDigits p (fun j => e (j + 1)) L := by
        apply ih
        intro j hj
        exact h (j + 1) (by omega)
      rw [h0, ht]

theorem evalDigits_succ (p : ℤ) (d : ℕ → ℤ) (L : ℕ) :
    evalDigits p d (L + 1) =
      evalDigits p d L + d L * p ^ L := by
  induction L generalizing d with
  | zero => simp [evalDigits]
  | succ L ih =>
      change
        d 0 + p * evalDigits p (fun j => d (j + 1)) (L + 1) =
          d 0 + p * evalDigits p (fun j => d (j + 1)) L +
            d (L + 1) * p ^ (L + 1)
      rw [ih (d := fun j => d (j + 1)), pow_succ]
      ring

theorem evalDigits_eq_sum_range (p : ℤ) (d : ℕ → ℤ) (L : ℕ) :
    evalDigits p d L =
      ∑ j ∈ Finset.range L, d j * p ^ j := by
  induction L with
  | zero => simp [evalDigits]
  | succ L ih =>
      rw [evalDigits_succ, ih, Finset.sum_range_succ]

theorem evalDigits_eq_natWeighted (p : ℕ) (d : ℕ → ℤ) (L : ℕ) :
    evalDigits (p : ℤ) d L =
      ∑ j ∈ Finset.range L, d j * ((p ^ j : ℕ) : ℤ) := by
  simpa using evalDigits_eq_sum_range (p : ℤ) d L

def canonicalDigit (x p j : ℕ) : ℤ :=
  (((x / p ^ j) % p : ℕ) : ℤ)

theorem canonicalDigit_eq_quotient_sub (x p j : ℕ) :
    canonicalDigit x p j =
      ((x / p ^ j : ℕ) : ℤ) -
        (p : ℤ) * ((x / p ^ (j + 1) : ℕ) : ℤ) := by
  have hdiv : x / p ^ j / p = x / p ^ (j + 1) := by
    simpa [pow_succ] using
      (Nat.div_div_eq_div_mul x (p ^ j) p)
  have hmNat :
      (x / p ^ j) % p + p * (x / p ^ (j + 1)) =
        x / p ^ j := by
    have hm := Nat.mod_add_div (x / p ^ j) p
    rw [hdiv] at hm
    simpa [Nat.mul_comm] using hm
  have hmZ :
      (((x / p ^ j) % p : ℕ) : ℤ) +
          (p : ℤ) * ((x / p ^ (j + 1) : ℕ) : ℤ) =
        ((x / p ^ j : ℕ) : ℤ) := by
    exact_mod_cast hmNat
  unfold canonicalDigit
  omega

theorem evalDigits_quotientDiff (p : ℤ) (Q : ℕ → ℤ) (L : ℕ) :
    evalDigits p (fun j => Q j - p * Q (j + 1)) L =
      Q 0 - p ^ L * Q L := by
  induction L generalizing Q with
  | zero => simp [evalDigits]
  | succ L ih =>
      change
        (Q 0 - p * Q 1) +
            p * evalDigits p
              (fun j => Q (j + 1) - p * Q (j + 1 + 1)) L =
          Q 0 - p ^ (L + 1) * Q (L + 1)
      rw [ih (Q := fun j => Q (j + 1)), pow_succ]
      ring

theorem evalDigits_canonical (x p L : ℕ) :
    evalDigits (p : ℤ) (canonicalDigit x p) L =
      ((x % p ^ L : ℕ) : ℤ) := by
  let Q : ℕ → ℤ := fun j => ((x / p ^ j : ℕ) : ℤ)
  calc
    evalDigits (p : ℤ) (canonicalDigit x p) L =
        evalDigits (p : ℤ)
          (fun j => Q j - (p : ℤ) * Q (j + 1)) L := by
            apply evalDigits_congr
            intro j _
            simpa [Q] using canonicalDigit_eq_quotient_sub x p j
    _ = Q 0 - (p : ℤ) ^ L * Q L :=
      evalDigits_quotientDiff (p : ℤ) Q L
    _ = ((x % p ^ L : ℕ) : ℤ) := by
      have hmNat :
          x % p ^ L + p ^ L * (x / p ^ L) = x := by
        simpa [Nat.mul_comm] using Nat.mod_add_div x (p ^ L)
      have hmZ :
          ((x % p ^ L : ℕ) : ℤ) +
              (p : ℤ) ^ L * ((x / p ^ L : ℕ) : ℤ) =
            (x : ℤ) := by
        exact_mod_cast hmNat
      dsimp [Q]
      simp only [pow_zero, Int.ediv_one]
      have hdivcast :
          ((x / p ^ L : ℕ) : ℤ) =
            (x : ℤ) / (p : ℤ) ^ L := by
        simpa using Int.natCast_ediv x (p ^ L)
      have hmodcast :
          ((x % p ^ L : ℕ) : ℤ) =
            (x : ℤ) % (p : ℤ) ^ L := by
        simpa using Int.natCast_emod x (p ^ L)
      rw [← hdivcast, ← hmodcast]
      omega

theorem canonicalDigit_bounds (x p j : ℕ) (hp : 0 < p) :
    0 ≤ canonicalDigit x p j ∧ canonicalDigit x p j < (p : ℤ) := by
  unfold canonicalDigit
  constructor
  · exact Int.natCast_nonneg _
  · exact_mod_cast Nat.mod_lt (x / p ^ j) hp

theorem evalDigits_bounds (p : ℤ) (d : ℕ → ℤ) (L : ℕ)
    (hp : 0 < p)
    (hd : ∀ j, j < L → 0 ≤ d j ∧ d j < p) :
    0 ≤ evalDigits p d L ∧ evalDigits p d L < p ^ L := by
  induction L generalizing d with
  | zero => simp [evalDigits]
  | succ L ih =>
      have h0 := hd 0 (by omega)
      have ht :=
        ih (d := fun j => d (j + 1)) (by
          intro j hj
          exact hd (j + 1) (by omega))
      constructor
      · simp only [evalDigits]
        exact add_nonneg h0.1 (mul_nonneg hp.le ht.1)
      · simp only [evalDigits]
        have hs :
            evalDigits p (fun j => d (j + 1)) L + 1 ≤ p ^ L := by
          omega
        calc
          d 0 + p * evalDigits p (fun j => d (j + 1)) L
              < p + p * evalDigits p (fun j => d (j + 1)) L :=
            add_lt_add_left h0.2 _
          _ = p * (evalDigits p (fun j => d (j + 1)) L + 1) := by
            ring
          _ ≤ p * p ^ L := mul_le_mul_of_nonneg_left hs hp.le
          _ = p ^ (L + 1) := by rw [pow_succ]; ring

theorem evalDigits_split_nonneg
    (p : ℤ) (d : ℕ → ℤ) (s u : ℕ)
    (hp : 0 < p)
    (hd : ∀ j, j < s + u → 0 ≤ d j ∧ d j < p) :
    ∃ q : ℤ, 0 ≤ q ∧
      evalDigits p d (s + u) =
        evalDigits p d s + p ^ s * q := by
  induction s generalizing d with
  | zero =>
      refine ⟨evalDigits p d u, ?_, ?_⟩
      · exact (evalDigits_bounds p d u hp (by
          intro j hj
          exact hd j (by omega))).1
      · simp [evalDigits]
  | succ s ih =>
      have htail :
          ∀ j, j < s + u →
            0 ≤ d (j + 1) ∧ d (j + 1) < p := by
        intro j hj
        exact hd (j + 1) (by omega)
      obtain ⟨q, hq0, hq⟩ :=
        ih (d := fun j => d (j + 1)) htail
      refine ⟨q, hq0, ?_⟩
      rw [Nat.succ_add]
      change
        d 0 + p * evalDigits p (fun j => d (j + 1)) (s + u) =
          d 0 + p * evalDigits p (fun j => d (j + 1)) s +
            p ^ (s + 1) * q
      rw [hq, pow_succ]
      ring

/-- Bounded full reconstruction determines every residue prefix. -/
theorem evalDigits_prefix_eq_mod
    (p x L t : ℕ) (d : ℕ → ℤ)
    (hp : 0 < p) (ht : t ≤ L)
    (hd : ∀ j, j < L → 0 ≤ d j ∧ d j < (p : ℤ))
    (hrecon : evalDigits (p : ℤ) d L = (x : ℤ)) :
    evalDigits (p : ℤ) d t = ((x % p ^ t : ℕ) : ℤ) := by
  let u := L - t
  have htu : t + u = L := by
    dsimp [u]
    omega
  have hpZ : (0 : ℤ) < (p : ℤ) := by exact_mod_cast hp
  obtain ⟨q, hq0, hq⟩ :=
    evalDigits_split_nonneg
      (p := (p : ℤ)) (d := d) (s := t) (u := u) hpZ (by
        intro j hj
        apply hd j
        omega)
  rw [htu] at hq
  have hpre :=
    evalDigits_bounds (p : ℤ) d t hpZ (by
      intro j hj
      exact hd j (lt_of_lt_of_le hj ht))

  let A : ℕ := (evalDigits (p : ℤ) d t).toNat
  let Q : ℕ := q.toNat
  have hA : (A : ℤ) = evalDigits (p : ℤ) d t := by
    dsimp [A]
    exact Int.toNat_of_nonneg hpre.1
  have hQ : (Q : ℤ) = q := by
    dsimp [Q]
    exact Int.toNat_of_nonneg hq0

  have hxZ :
      (x : ℤ) = (A : ℤ) + (p : ℤ) ^ t * (Q : ℤ) := by
    calc
      (x : ℤ) = evalDigits (p : ℤ) d L := hrecon.symm
      _ = evalDigits (p : ℤ) d t + (p : ℤ) ^ t * q := hq
      _ = (A : ℤ) + (p : ℤ) ^ t * (Q : ℤ) := by
        rw [hA, hQ]
  have hxNat : x = A + p ^ t * Q := by
    exact_mod_cast hxZ

  have hAltZ : (A : ℤ) < (p : ℤ) ^ t := by
    rw [hA]
    exact hpre.2
  have hAlt : A < p ^ t := by exact_mod_cast hAltZ
  have hxmod : x % p ^ t = A := by
    rw [hxNat]
    simp [Nat.add_mod, Nat.mod_eq_of_lt hAlt]

  calc
    evalDigits (p : ℤ) d t = (A : ℤ) := hA.symm
    _ = ((x % p ^ t : ℕ) : ℤ) := by rw [hxmod]

theorem weighted_prefix_eq_mod
    (p x L t : ℕ) (d : ℕ → ℤ)
    (hp : 0 < p) (ht : t ≤ L)
    (hd : ∀ j, j < L → 0 ≤ d j ∧ d j < (p : ℤ))
    (hrecon :
      (∑ j ∈ Finset.range L, d j * ((p ^ j : ℕ) : ℤ)) = (x : ℤ)) :
    (∑ j ∈ Finset.range t, d j * ((p ^ j : ℕ) : ℤ)) =
      ((x % p ^ t : ℕ) : ℤ) := by
  have hfull : evalDigits (p : ℤ) d L = (x : ℤ) :=
    (evalDigits_eq_natWeighted p d L).trans hrecon
  calc
    (∑ j ∈ Finset.range t, d j * ((p ^ j : ℕ) : ℤ)) =
        evalDigits (p : ℤ) d t :=
      (evalDigits_eq_natWeighted p d t).symm
    _ = ((x % p ^ t : ℕ) : ℤ) :=
      evalDigits_prefix_eq_mod p x L t d hp ht hd hfull

theorem canonical_weighted_reconstruction
    (x p L : ℕ) (hx : x < p ^ L) :
    (∑ j ∈ Finset.range L,
        canonicalDigit x p j * ((p ^ j : ℕ) : ℤ)) = (x : ℤ) := by
  calc
    _ = evalDigits (p : ℤ) (canonicalDigit x p) L :=
      (evalDigits_eq_natWeighted p (canonicalDigit x p) L).symm
    _ = ((x % p ^ L : ℕ) : ℤ) := evalDigits_canonical x p L
    _ = (x : ℤ) := by rw [Nat.mod_eq_of_lt hx]

def deltaDigit (p : ℤ) (η ξ : ℕ → ℤ)
    (β : ℕ → Bool) (j : ℕ) : ℤ :=
  η j - ξ j - bit (β j) + p * bit (β (j + 1))

theorem deltaDigit_bounds_of_row
    (p : ℤ) (η ξ : ℕ → ℤ) (β : ℕ → Bool) (j : ℕ)
    (hrow :
      BorrowRow p (ξ j) (η j) (β j) (β (j + 1))) :
    0 ≤ deltaDigit p η ξ β j ∧
      deltaDigit p η ξ β j < p := by
  unfold BorrowRow at hrow
  unfold deltaDigit
  omega

theorem borrow_telescope
    (p : ℤ) (η ξ : ℕ → ℤ) (β : ℕ → Bool) (L : ℕ) :
    evalDigits p η L - evalDigits p ξ L - bit (β 0) =
      evalDigits p (deltaDigit p η ξ β) L -
        p ^ L * bit (β L) := by
  induction L generalizing η ξ β with
  | zero => simp [evalDigits]
  | succ L ih =>
      have htail :=
        ih (η := fun j => η (j + 1))
          (ξ := fun j => ξ (j + 1))
          (β := fun j => β (j + 1))
      change
        evalDigits p (fun j => η (j + 1)) L -
              evalDigits p (fun j => ξ (j + 1)) L -
              bit (β 1) =
            evalDigits p
                (fun j => deltaDigit p η ξ β (j + 1)) L -
              p ^ L * bit (β (L + 1)) at htail
      change
        (η 0 + p * evalDigits p (fun j => η (j + 1)) L) -
              (ξ 0 + p * evalDigits p (fun j => ξ (j + 1)) L) -
              bit (β 0) =
            (η 0 - ξ 0 - bit (β 0) + p * bit (β 1)) +
                p * evalDigits p
                  (fun j => deltaDigit p η ξ β (j + 1)) L -
              p ^ (L + 1) * bit (β (L + 1))
      rw [pow_succ]
      linear_combination p * htail

/-- Decode arbitrary bounded digits and signed borrow rows. -/
theorem borrow_true_iff_residue_lt_of_weighted
    (n k p L : ℕ) (η ξ : ℕ → ℤ) (β : ℕ → Bool)
    (hp : 0 < p)
    (hηdigit : ∀ j, j < L → 0 ≤ η j ∧ η j < (p : ℤ))
    (hξdigit : ∀ j, j < L → 0 ≤ ξ j ∧ ξ j < (p : ℤ))
    (hηrecon :
      (∑ j ∈ Finset.range L, η j * ((p ^ j : ℕ) : ℤ)) = (n : ℤ))
    (hξrecon :
      (∑ j ∈ Finset.range L, ξ j * ((p ^ j : ℕ) : ℤ)) = (k : ℤ))
    (hβ0 : β 0 = false)
    (hrows :
      ∀ j, j < L →
        BorrowRow (p : ℤ) (ξ j) (η j) (β j) (β (j + 1))) :
    ∀ t, t ≤ L →
      (β t = true ↔ n % p ^ t < k % p ^ t) := by
  have hηeval :
      evalDigits (p : ℤ) η L = (n : ℤ) :=
    (evalDigits_eq_natWeighted p η L).trans hηrecon
  have hξeval :
      evalDigits (p : ℤ) ξ L = (k : ℤ) :=
    (evalDigits_eq_natWeighted p ξ L).trans hξrecon
  intro t ht
  have hηt :=
    evalDigits_prefix_eq_mod p n L t η hp ht hηdigit hηeval
  have hξt :=
    evalDigits_prefix_eq_mod p k L t ξ hp ht hξdigit hξeval
  have hδdigit :
      ∀ j, j < t →
        0 ≤ deltaDigit (p : ℤ) η ξ β j ∧
          deltaDigit (p : ℤ) η ξ β j < (p : ℤ) := by
    intro j hj
    exact deltaDigit_bounds_of_row (p : ℤ) η ξ β j
      (hrows j (by omega))
  have hpZ : (0 : ℤ) < (p : ℤ) := by exact_mod_cast hp
  have hδ :=
    evalDigits_bounds (p : ℤ)
      (deltaDigit (p : ℤ) η ξ β) t hpZ hδdigit
  rcases hδ with ⟨hδ0, hδlt⟩
  have htel := borrow_telescope (p : ℤ) η ξ β t
  rw [hηt, hξt] at htel
  constructor
  · intro hβt
    have heq := htel
    have hb0 : bit (β 0) = 0 := by rw [hβ0]; rfl
    have hbt : bit (β t) = 1 := by rw [hβt]; rfl
    rw [hb0, hbt] at heq
    have hz :
        ((n % p ^ t : ℕ) : ℤ) <
          ((k % p ^ t : ℕ) : ℤ) := by
      omega
    exact_mod_cast hz
  · intro hlt
    cases hβt : β t with
    | false =>
        exfalso
        have hz :
            ((n % p ^ t : ℕ) : ℤ) <
              ((k % p ^ t : ℕ) : ℤ) := by
          exact_mod_cast hlt
        have heq := htel
        have hb0 : bit (β 0) = 0 := by rw [hβ0]; rfl
        have hbt : bit (β t) = 0 := by rw [hβt]; rfl
        rw [hb0, hbt] at heq
        omega
    | true => rfl

/-- Recursive construction: every outgoing borrow is forced locally. -/
def makeBorrow (η ξ : ℕ → ℤ) : ℕ → Bool
  | 0 => false
  | j + 1 => decide (η j < ξ j + bit (makeBorrow η ξ j))

@[simp] theorem makeBorrow_zero (η ξ : ℕ → ℤ) :
    makeBorrow η ξ 0 = false := rfl

@[simp] theorem makeBorrow_succ_true_iff
    (η ξ : ℕ → ℤ) (j : ℕ) :
    makeBorrow η ξ (j + 1) = true ↔
      η j < ξ j + bit (makeBorrow η ξ j) := by
  simp [makeBorrow]

theorem makeBorrow_rows
    (p : ℤ) (η ξ : ℕ → ℤ)
    (hp : 2 ≤ p)
    (hη : ∀ j, 0 ≤ η j ∧ η j < p)
    (hξ : ∀ j, 0 ≤ ξ j ∧ ξ j < p) :
    ∀ j,
      BorrowRow p (ξ j) (η j)
        (makeBorrow η ξ j) (makeBorrow η ξ (j + 1)) := by
  intro j
  apply
    (borrowRow_iff_outgoing p (ξ j) (η j)
      (makeBorrow η ξ j) (makeBorrow η ξ (j + 1))
      (hξ j).1 (hξ j).2 (hη j).1 (hη j).2).2
  simp [makeBorrow]

def canonicalBorrow (n k p : ℕ) : ℕ → Bool :=
  makeBorrow (canonicalDigit n p) (canonicalDigit k p)

theorem canonicalBorrow_rows
    (n k p : ℕ) (hp : 2 ≤ p) (j : ℕ) :
    BorrowRow (p : ℤ)
      (canonicalDigit k p j) (canonicalDigit n p j)
      (canonicalBorrow n k p j)
      (canonicalBorrow n k p (j + 1)) := by
  have hpZ : (2 : ℤ) ≤ (p : ℤ) := by exact_mod_cast hp
  have hp0 : 0 < p := by omega
  simpa [canonicalBorrow] using
    (makeBorrow_rows
      (p := (p : ℤ))
      (η := canonicalDigit n p)
      (ξ := canonicalDigit k p)
      hpZ
      (fun j => canonicalDigit_bounds n p j hp0)
      (fun j => canonicalDigit_bounds k p j hp0) j)

theorem lt_pow_logLength (n p : ℕ) (hp : 1 < p) :
    n < p ^ (Nat.log p n + 1) := by
  simpa [Nat.succ_eq_add_one] using
    (Nat.lt_pow_succ_log_self (b := p) hp n)

theorem canonicalBorrow_true_iff_residue_lt
    (n k p : ℕ) (hp : 2 ≤ p) (hk : k ≤ n)
    (t : ℕ) (ht : t ≤ Nat.log p n + 1) :
    canonicalBorrow n k p t = true ↔
      n % p ^ t < k % p ^ t := by
  let L := Nat.log p n + 1
  have hp0 : 0 < p := by omega
  have hncut : n < p ^ L := by
    simpa [L] using lt_pow_logLength n p (by omega)
  have hkcut : k < p ^ L := lt_of_le_of_lt hk hncut
  have hs :=
    borrow_true_iff_residue_lt_of_weighted
      (n := n) (k := k) (p := p) (L := L)
      (η := canonicalDigit n p)
      (ξ := canonicalDigit k p)
      (β := canonicalBorrow n k p)
      hp0
      (fun j _ => canonicalDigit_bounds n p j hp0)
      (fun j _ => canonicalDigit_bounds k p j hp0)
      (canonical_weighted_reconstruction n p L hncut)
      (canonical_weighted_reconstruction k p L hkcut)
      (by simp [canonicalBorrow, makeBorrow])
      (fun j _ => canonicalBorrow_rows n k p hp j)
  exact hs t (by simpa [L] using ht)

theorem canonicalBorrow_terminal_false
    (n k p : ℕ) (hp : 2 ≤ p) (hk : k ≤ n) :
    canonicalBorrow n k p (Nat.log p n + 1) = false := by
  let L := Nat.log p n + 1
  have hncut : n < p ^ L := by
    simpa [L] using lt_pow_logLength n p (by omega)
  have hkcut : k < p ^ L := lt_of_le_of_lt hk hncut
  have hiff :=
    canonicalBorrow_true_iff_residue_lt n k p hp hk L
      (by simp [L])
  have hnot : ¬ n % p ^ L < k % p ^ L := by
    rw [Nat.mod_eq_of_lt hncut, Nat.mod_eq_of_lt hkcut]
    omega
  cases hβ : canonicalBorrow n k p L with
  | false => rfl
  | true => exact (hnot (hiff.mp hβ)).elim

/-- For `k ≤ n`, a wrapped residue subtraction is exactly a carry in
`k + (n-k)`. -/
theorem residue_lt_iff_carry
    (n k m : ℕ) (hk : k ≤ n) (hm : 0 < m) :
    n % m < k % m ↔
      m ≤ k % m + (n - k) % m := by
  have hsum : k + (n - k) = n := Nat.add_sub_of_le hk
  have hmod :
      n % m = (k % m + (n - k) % m) % m := by
    calc
      n % m = (k + (n - k)) % m :=
        congrArg (fun z : ℕ => z % m) hsum.symm
      _ = (k % m + (n - k) % m) % m := Nat.add_mod k (n - k) m
  have hkm := Nat.mod_lt k hm
  have hdm := Nat.mod_lt (n - k) hm
  constructor
  · intro hlt
    by_contra hnot
    have hslt : k % m + (n - k) % m < m :=
      Nat.lt_of_not_ge hnot
    rw [Nat.mod_eq_of_lt hslt] at hmod
    omega
  · intro hcarry
    have hslt2 : k % m + (n - k) % m < 2 * m := by omega
    have hsub :
        k % m + (n - k) % m =
          m + (k % m + (n - k) % m - m) := by omega
    have hsublt : k % m + (n - k) % m - m < m := by omega
    have hmodsum :
        (k % m + (n - k) % m) % m =
          k % m + (n - k) % m - m := by
      rw [hsub, Nat.add_mod]
      simp [Nat.mod_eq_of_lt hsublt, hm]
    rw [hmod, hmodsum]
    omega

private theorem sum_bit_eq_card_true
    {α : Type*} [DecidableEq α]
    (s : Finset α) (β : α → Bool) :
    (∑ x ∈ s, bit (β x)) =
      ((s.filter fun x => β x = true).card : ℤ) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      rw [Finset.sum_insert ha, Finset.filter_insert]
      simp only [bit] at ih
      cases h : β a <;> simp [ha, h, ih, bit, add_comm]

theorem sum_bit_eq_card_filter
    {α : Type*} [DecidableEq α]
    (s : Finset α) (β : α → Bool)
    (P : α → Prop) [DecidablePred P]
    (h : ∀ x, x ∈ s → (β x = true ↔ P x)) :
    (∑ x ∈ s, bit (β x)) = ((s.filter P).card : ℤ) := by
  classical
  have hf :
      s.filter (fun x => β x = true) = s.filter P := by
    ext x
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hx, hb⟩
      exact ⟨hx, (h x hx).mp hb⟩
    · rintro ⟨hx, hP⟩
      exact ⟨hx, (h x hx).mpr hP⟩
  calc
    _ = ((s.filter fun x => β x = true).card : ℤ) :=
      sum_bit_eq_card_true s β
    _ = ((s.filter P).card : ℤ) := by rw [hf]

/-- The inclusive budget drops its terminal zero and becomes exactly RCC. -/
theorem inclusiveBorrowSum_eq_residueCarryCount
    (n k p : ℕ) (β : ℕ → Bool)
    (hp : 2 ≤ p) (hk : k ≤ n)
    (hpoint :
      ∀ t, t ≤ Nat.log p n + 1 →
        (β t = true ↔ n % p ^ t < k % p ^ t))
    (hterminal : β (Nat.log p n + 1) = false) :
    (∑ t ∈ Finset.Ico 1 (Nat.log p n + 1 + 1), bit (β t)) =
      (residueCarryCount n k p : ℤ) := by
  let L := Nat.log p n + 1
  have hL : 1 ≤ L := by
    dsimp [L]
    omega
  have hterm : β L = false := by simpa [L] using hterminal
  have hset :
      Finset.Ico 1 (L + 1) = insert L (Finset.Ico 1 L) := by
    ext t
    simp [Finset.mem_Ico]
    omega
  have hdrop :
      (∑ t ∈ Finset.Ico 1 (L + 1), bit (β t)) =
        ∑ t ∈ Finset.Ico 1 L, bit (β t) := by
    rw [hset, Finset.sum_insert (by simp)]
    simp [hterm, bit]
  calc
    (∑ t ∈ Finset.Ico 1 (Nat.log p n + 1 + 1), bit (β t)) =
        ∑ t ∈ Finset.Ico 1 L, bit (β t) := by
          simpa [L] using hdrop
    _ =
        (((Finset.Ico 1 L).filter
          (fun t => n % p ^ t < k % p ^ t)).card : ℤ) := by
      apply sum_bit_eq_card_filter
      intro t ht
      apply hpoint t
      have htL : t < L := (Finset.mem_Ico.mp ht).2
      dsimp [L] at htL ⊢
      omega
    _ = (residueCarryCount n k p : ℤ) := by
      have hf :
          (Finset.Ico 1 L).filter
              (fun t => n % p ^ t < k % p ^ t) =
            (Finset.Ico 1 L).filter
              (fun t => p ^ t ≤ k % p ^ t + (n - k) % p ^ t) := by
        ext t
        simp only [Finset.mem_filter, Finset.mem_Ico]
        constructor
        · rintro ⟨ht, hlt⟩
          refine ⟨ht, (residue_lt_iff_carry n k (p ^ t) hk ?_).mp hlt⟩
          exact pow_pos (by omega) t
        · rintro ⟨ht, hcarry⟩
          refine ⟨ht, (residue_lt_iff_carry n k (p ^ t) hk ?_).mpr hcarry⟩
          exact pow_pos (by omega) t
      rw [hf]
      rfl

theorem canonicalBorrow_inclusiveSum
    (n k p : ℕ) (hp : 2 ≤ p) (hk : k ≤ n) :
    (∑ t ∈ Finset.Ico 1 (Nat.log p n + 1 + 1),
        bit (canonicalBorrow n k p t)) =
      (residueCarryCount n k p : ℤ) := by
  apply inclusiveBorrowSum_eq_residueCarryCount
  · exact hp
  · exact hk
  · intro t ht
    exact canonicalBorrow_true_iff_residue_lt n k p hp hk t ht
  · exact canonicalBorrow_terminal_false n k p hp hk

end DigitBorrowBridge
end Erdos700PartI

namespace Erdos700PartI

open scoped BigOperators
open ExplicitTableau

noncomputable section

namespace OrderedPrimeFactorization

variable {n r : ℕ} (F : OrderedPrimeFactorization n r)

def height (i : Fin r) : ℕ := Nat.log (F.p i) n

def zeroExponent (i : Fin r) : Fin (F.a i + 1) :=
  ⟨0, Nat.zero_lt_succ _⟩

def eta (i : Fin r) (j : Fin (F.height i + 1)) : ℤ :=
  DigitBorrowBridge.canonicalDigit n (F.p i) j.val

@[simp] theorem eta_def (i : Fin r) (j : Fin (F.height i + 1)) :
    F.eta i j = DigitBorrowBridge.canonicalDigit n (F.p i) j.val := rfl

end OrderedPrimeFactorization

namespace ExplicitG

variable {n r : ℕ} (F : OrderedPrimeFactorization n r)

structure Assignment where
  selector : (i : Fin r) → Fin (F.a i + 1) → Bool
  T : ℤ
  D : Fin (r + 1) → ℤ
  K : Fin (r + 1) → ℤ
  E : Fin r → ℤ
  Z : Fin r → ℤ
  digit : (i : Fin r) → Fin (F.height i + 1) → ℤ
  borrow : (i : Fin r) → Fin (F.height i + 2) → Bool

namespace Assignment

def finalD (x : Assignment F) : ℤ := x.D (Fin.last r)
def finalK (x : Assignment F) : ℤ := x.K (Fin.last r)

end Assignment

def ValidBaseline (B : ℤ) : Prop := (2 : ℤ) ≤ B ∧ B ≤ (n : ℤ)

def SelectorRows (x : Assignment F) : Prop :=
  (∀ i, OneHot (x.selector i)) ∧
  (∀ i, x.E i = selectedExponentZ (x.selector i)) ∧
  (∀ i, x.Z i = supportBitZ (x.selector i))

def IntegerBounds (x : Assignment F) : Prop :=
  1 ≤ x.T ∧ x.T ≤ (n : ℤ) ∧
  (∀ t, 1 ≤ x.D t ∧ x.D t ≤ (n : ℤ)) ∧
  (∀ t, 1 ≤ x.K t ∧ x.K t ≤ (n : ℤ)) ∧
  (∀ i, 0 ≤ x.E i ∧ x.E i ≤ (F.a i : ℤ)) ∧
  (∀ i, 0 ≤ x.Z i ∧ x.Z i ≤ 1)

def PrefixRows (x : Assignment F) : Prop :=
  x.D 0 = 1 ∧ x.K 0 = x.T ∧
  ∀ i (e : Fin (F.a i + 1)),
    let q : ℤ := ((F.p i) ^ e.val : ℕ)
    let slack : ℤ := (n : ℤ) ^ 2 * (1 - bit (x.selector i e))
    (-slack ≤ x.D i.succ - q * x.D i.castSucc ∧
      x.D i.succ - q * x.D i.castSucc ≤ slack ∧
      -slack ≤ x.K i.succ - q * x.K i.castSucc ∧
      x.K i.succ - q * x.K i.castSucc ≤ slack)

def BoundaryRows (B : ℤ) (x : Assignment F) : Prop :=
  B + 1 ≤ x.finalD ∧
  x.finalK ≤ ((n / 2 : ℕ) : ℤ) ∧
  ∀ i, x.finalD ≤
    B * (F.p i : ℤ) + (n : ℤ) * (1 - x.Z i)

def DigitRows (x : Assignment F) : Prop :=
  (∀ i j, 0 ≤ x.digit i j ∧ x.digit i j < (F.p i : ℤ)) ∧
  ∀ i, x.finalK =
    ∑ j : Fin (F.height i + 1),
      x.digit i j * (((F.p i) ^ j.val : ℕ) : ℤ)

def BorrowRows (x : Assignment F) : Prop :=
  ∀ i,
    x.borrow i 0 = false ∧
    x.borrow i (Fin.last (F.height i + 1)) = false ∧
    ∀ j : Fin (F.height i + 1),
      BorrowRow (F.p i : ℤ) (x.digit i j) (F.eta i j)
        (x.borrow i j.castSucc) (x.borrow i j.succ)

def BudgetRows (x : Assignment F) : Prop :=
  ∀ i,
    (∑ t ∈ Finset.Ico 1 (F.height i + 1 + 1),
        bit (DigitBorrowBridge.finAt (x.borrow i) false t)) ≤
      (F.a i : ℤ) - x.E i +
        ((F.height i + 1 : ℕ) : ℤ) * (1 - x.Z i)

def Satisfies (B : ℤ) (x : Assignment F) : Prop :=
  SelectorRows F x ∧ IntegerBounds F x ∧ PrefixRows F x ∧
  BoundaryRows F B x ∧ DigitRows F x ∧ BorrowRows F x ∧ BudgetRows F x

/-- The complete finite integer/Boolean selector, prefix, digit, borrow and budget system. -/
def G (B : ℤ) : Prop := ∃ x : Assignment F, Satisfies F B x

/-! ### Generic prefix lemmas -/

def qAt {r : ℕ} (q : Fin r → ℤ) (j : ℕ) : ℤ :=
  if hj : j < r then q ⟨j, hj⟩ else 1

theorem array_eq_prefix {r : ℕ} (D : Fin (r + 1) → ℤ)
    (q : Fin r → ℤ)
    (h0 : D 0 = 1)
    (hs : ∀ i : Fin r, D i.succ = q i * D i.castSucc) :
    ∀ t, t ≤ r →
      DigitBorrowBridge.finAt D 0 t =
        ∏ j ∈ Finset.range t, qAt q j := by
  intro t ht
  induction t with
  | zero => simpa [DigitBorrowBridge.finAt] using h0
  | succ t ih =>
      have htr : t < r := by omega
      let i : Fin r := ⟨t, htr⟩
      have hstep := hs i
      have hleft : DigitBorrowBridge.finAt D 0 (t + 1) = D i.succ := by
        unfold DigitBorrowBridge.finAt
        rw [dif_pos (by omega)]
        congr 1
      have hprev : DigitBorrowBridge.finAt D 0 t = D i.castSucc := by
        unfold DigitBorrowBridge.finAt
        rw [dif_pos (by omega)]
        congr 1
      rw [hleft, hstep, ← hprev, ih (by omega), Finset.prod_range_succ]
      simp [qAt, i, htr, mul_comm]

theorem array_final_eq_prod {r : ℕ} (D : Fin (r + 1) → ℤ)
    (q : Fin r → ℤ)
    (h0 : D 0 = 1)
    (hs : ∀ i : Fin r, D i.succ = q i * D i.castSucc) :
    D (Fin.last r) = ∏ i : Fin r, q i := by
  have h := array_eq_prefix D q h0 hs r (le_refl r)
  have hlast : DigitBorrowBridge.finAt D 0 r = D (Fin.last r) := by
    unfold DigitBorrowBridge.finAt
    rw [dif_pos (by omega)]
    congr 1
  rw [hlast] at h
  rw [← Fin.prod_univ_eq_prod_range (qAt q) r] at h
  simpa [qAt] using h

theorem array_eq_prefix_mul {r : ℕ} (D : Fin (r + 1) → ℤ)
    (q : Fin r → ℤ) (c : ℤ)
    (h0 : D 0 = c)
    (hs : ∀ i : Fin r, D i.succ = q i * D i.castSucc) :
    ∀ t, t ≤ r →
      DigitBorrowBridge.finAt D 0 t =
        (∏ j ∈ Finset.range t, qAt q j) * c := by
  intro t ht
  induction t with
  | zero => simpa [DigitBorrowBridge.finAt] using h0
  | succ t ih =>
      have htr : t < r := by omega
      let i : Fin r := ⟨t, htr⟩
      have hstep := hs i
      have hleft : DigitBorrowBridge.finAt D 0 (t + 1) = D i.succ := by
        unfold DigitBorrowBridge.finAt
        rw [dif_pos (by omega)]
        congr 1
      have hprev : DigitBorrowBridge.finAt D 0 t = D i.castSucc := by
        unfold DigitBorrowBridge.finAt
        rw [dif_pos (by omega)]
        congr 1
      rw [hleft, hstep, ← hprev, ih (by omega), Finset.prod_range_succ]
      simp [qAt, i, htr]
      ring

theorem array_final_eq_prod_mul {r : ℕ} (D : Fin (r + 1) → ℤ)
    (q : Fin r → ℤ) (c : ℤ)
    (h0 : D 0 = c)
    (hs : ∀ i : Fin r, D i.succ = q i * D i.castSucc) :
    D (Fin.last r) = (∏ i : Fin r, q i) * c := by
  have h := array_eq_prefix_mul D q c h0 hs r (le_refl r)
  have hlast : DigitBorrowBridge.finAt D 0 r = D (Fin.last r) := by
    unfold DigitBorrowBridge.finAt
    rw [dif_pos (by omega)]
    congr 1
  rw [hlast] at h
  rw [← Fin.prod_univ_eq_prod_range (qAt q) r] at h
  simpa [qAt] using h

theorem selected_prefix_step_D (x : Assignment F)
    (hprefix : PrefixRows F x)
    (e : (i : Fin r) → Fin (F.a i + 1))
    (hselector : ∀ i, x.selector i = selectorOf (e i)) :
    ∀ i : Fin r,
      x.D i.succ = (((F.p i) ^ (e i).val : ℕ) : ℤ) * x.D i.castSucc := by
  intro i
  have hrow := hprefix.2.2 i (e i)
  have hs : bit (x.selector i (e i)) = (1 : ℤ) := by
    rw [hselector i]
    simp [selectorOf, bit]
  dsimp only at hrow
  rw [hs] at hrow
  omega

theorem selected_prefix_step_K (x : Assignment F)
    (hprefix : PrefixRows F x)
    (e : (i : Fin r) → Fin (F.a i + 1))
    (hselector : ∀ i, x.selector i = selectorOf (e i)) :
    ∀ i : Fin r,
      x.K i.succ = (((F.p i) ^ (e i).val : ℕ) : ℤ) * x.K i.castSucc := by
  intro i
  have hrow := hprefix.2.2 i (e i)
  have hs : bit (x.selector i (e i)) = (1 : ℤ) := by
    rw [hselector i]
    simp [selectorOf, bit]
  dsimp only at hrow
  rw [hs] at hrow
  omega

theorem decoded_finalD (x : Assignment F)
    (hprefix : PrefixRows F x)
    (e : (i : Fin r) → Fin (F.a i + 1))
    (hselector : ∀ i, x.selector i = selectorOf (e i)) :
    x.finalD =
      (exponentProduct (exponentVector F (fun i => (e i).val)) : ℤ) := by
  have h := array_final_eq_prod x.D
    (fun i => (((F.p i) ^ (e i).val : ℕ) : ℤ))
    hprefix.1 (selected_prefix_step_D F x hprefix e hselector)
  rw [Assignment.finalD, h, exponentProduct_exponentVector]
  simp only [Nat.cast_prod, Nat.cast_pow]

theorem decoded_finalK (x : Assignment F)
    (hprefix : PrefixRows F x)
    (e : (i : Fin r) → Fin (F.a i + 1))
    (hselector : ∀ i, x.selector i = selectorOf (e i)) :
    x.finalK =
      (exponentProduct (exponentVector F (fun i => (e i).val)) : ℤ) * x.T := by
  have h := array_final_eq_prod_mul x.K
    (fun i => (((F.p i) ^ (e i).val : ℕ) : ℤ)) x.T
    hprefix.2.1 (selected_prefix_step_K F x hprefix e hselector)
  rw [Assignment.finalK, h, exponentProduct_exponentVector]
  simp only [Nat.cast_prod, Nat.cast_pow]

end ExplicitG
end
end Erdos700PartI

namespace Erdos700PartI
namespace ExplicitG

open scoped BigOperators
open ExplicitTableau

noncomputable section

variable {n r : ℕ} (F : OrderedPrimeFactorization n r)

/-! Canonical prefix products used in the reverse construction. -/

def prefixNat
    (e : (i : Fin r) → Fin (F.a i + 1)) (t : Fin (r + 1)) : ℕ :=
  ∏ i ∈ Finset.univ.filter (fun i : Fin r => i.val < t.val),
    F.p i ^ (e i).val

@[simp] theorem prefixNat_zero
    (e : (i : Fin r) → Fin (F.a i + 1)) :
    prefixNat F e 0 = 1 := by
  simp [prefixNat]

theorem prefixNat_succ
    (e : (i : Fin r) → Fin (F.a i + 1)) (i : Fin r) :
    prefixNat F e i.succ = F.p i ^ (e i).val * prefixNat F e i.castSucc := by
  classical
  have hs :
      Finset.univ.filter (fun j : Fin r => j.val < i.succ.val) =
        insert i (Finset.univ.filter (fun j : Fin r => j.val < i.castSucc.val)) := by
    ext j
    simp only [Finset.mem_filter, Finset.mem_univ, true_and,
      Finset.mem_insert]
    constructor
    · intro hj
      by_cases hji : j = i
      · exact Or.inl hji
      · exact Or.inr (by
          change j.val < i.val
          change j.val < i.val + 1 at hj
          omega)
    · rintro (rfl | hj)
      · simp
      · change j.val < i.val + 1
        change j.val < i.val at hj
        omega
  rw [prefixNat, prefixNat, hs, Finset.prod_insert]
  simp

theorem prefixNat_last
    (e : (i : Fin r) → Fin (F.a i + 1)) :
    prefixNat F e (Fin.last r) = ∏ i : Fin r, F.p i ^ (e i).val := by
  classical
  unfold prefixNat
  have hfilter :
      Finset.univ.filter (fun i : Fin r => i.val < (Fin.last r).val) =
        Finset.univ := by
    ext i
    simp
  rw [hfilter]

theorem prefixNat_pos
    (e : (i : Fin r) → Fin (F.a i + 1)) (t : Fin (r + 1)) :
    0 < prefixNat F e t := by
  classical
  unfold prefixNat
  exact Finset.prod_pos fun i _ => pow_pos (F.prime i).pos _

theorem prefixNat_dvd_full
    (e : (i : Fin r) → Fin (F.a i + 1)) (t : Fin (r + 1)) :
    prefixNat F e t ∣ ∏ i : Fin r, F.p i ^ (e i).val := by
  classical
  unfold prefixNat
  exact Finset.prod_dvd_prod_of_subset
    (Finset.univ.filter (fun i : Fin r => i.val < t.val)) Finset.univ
    (fun i : Fin r => F.p i ^ (e i).val)
    (Finset.filter_subset (fun i : Fin r => i.val < t.val) Finset.univ)

/-! An arbitrary feasible digit/borrow row has the semantic carry count. -/

theorem assignmentBorrowSum_eq_residueCarryCount
    (x : Assignment F) (hdigit : DigitRows F x) (hborrow : BorrowRows F x)
    (i : Fin r) (k : ℕ) (hkZ : x.finalK = (k : ℤ)) (hk : k ≤ n) :
    (∑ t ∈ Finset.Ico 1 (F.height i + 1 + 1),
        bit (DigitBorrowBridge.finAt (x.borrow i) false t)) =
      (residueCarryCount n k (F.p i) : ℤ) := by
  let L : ℕ := F.height i + 1
  let eta : ℕ → ℤ := DigitBorrowBridge.finAt (F.eta i) 0
  let xi : ℕ → ℤ := DigitBorrowBridge.finAt (x.digit i) 0
  let beta : ℕ → Bool := DigitBorrowBridge.finAt (x.borrow i) false
  have hp : 2 ≤ F.p i := (F.prime i).two_le
  have hp0 : 0 < F.p i := by omega
  have hncut : n < (F.p i) ^ L := by
    simpa [L, OrderedPrimeFactorization.height] using
      DigitBorrowBridge.lt_pow_logLength n (F.p i) (by omega)
  have heta_eq (j : ℕ) (hj : j < L) :
      eta j = DigitBorrowBridge.canonicalDigit n (F.p i) j := by
    unfold eta DigitBorrowBridge.finAt
    rw [dif_pos]
    · rfl
    · simpa [L] using hj
  have hxi_eq (j : ℕ) (hj : j < L) :
      xi j = x.digit i ⟨j, by simpa [L] using hj⟩ := by
    unfold xi DigitBorrowBridge.finAt
    rw [dif_pos]
  have hbeta_eq (j : ℕ) (hj : j < L + 1) :
      beta j = x.borrow i ⟨j, by dsimp [L] at hj ⊢; omega⟩ := by
    unfold beta DigitBorrowBridge.finAt
    rw [dif_pos]
  have hetaDigit :
      ∀ j, j < L → 0 ≤ eta j ∧ eta j < (F.p i : ℤ) := by
    intro j hj
    have hc := DigitBorrowBridge.canonicalDigit_bounds n (F.p i) j hp0
    rw [heta_eq j hj]
    exact hc
  have hxiDigit :
      ∀ j, j < L → 0 ≤ xi j ∧ xi j < (F.p i : ℤ) := by
    intro j hj
    have hd := hdigit.1 i ⟨j, by simpa [L] using hj⟩
    rw [hxi_eq j hj]
    simpa using hd
  have hetaRecon :
      (∑ j ∈ Finset.range L,
          eta j * (((F.p i) ^ j : ℕ) : ℤ)) = (n : ℤ) := by
    calc
      _ = ∑ j ∈ Finset.range L,
          DigitBorrowBridge.canonicalDigit n (F.p i) j *
            (((F.p i) ^ j : ℕ) : ℤ) := by
              apply Finset.sum_congr rfl
              intro j hj
              rw [heta_eq j (Finset.mem_range.mp hj)]
      _ = (n : ℤ) :=
        DigitBorrowBridge.canonical_weighted_reconstruction
          n (F.p i) L hncut
  have hxiRecon :
      (∑ j ∈ Finset.range L,
          xi j * (((F.p i) ^ j : ℕ) : ℤ)) = (k : ℤ) := by
    calc
      _ = ∑ j : Fin L,
          xi j.val * (((F.p i) ^ j.val : ℕ) : ℤ) := by
            symm
            exact Fin.sum_univ_eq_sum_range
              (fun j => xi j * (((F.p i) ^ j : ℕ) : ℤ)) L
      _ = ∑ j : Fin (F.height i + 1),
          x.digit i j * (((F.p i) ^ j.val : ℕ) : ℤ) := by
            apply Finset.sum_congr rfl
            intro j _hj
            have heq := hxi_eq j.val (by simpa [L] using j.isLt)
            simpa [L] using congrArg
              (fun z : ℤ => z * (((F.p i) ^ j.val : ℕ) : ℤ)) heq
      _ = x.finalK := (hdigit.2 i).symm
      _ = (k : ℤ) := hkZ
  have hbeta0 : beta 0 = false := by
    rw [hbeta_eq 0 (by omega)]
    simpa using (hborrow i).1
  have hrows :
      ∀ j, j < L →
        BorrowRow (F.p i : ℤ) (xi j) (eta j) (beta j) (beta (j + 1)) := by
    intro j hj
    let jj : Fin (F.height i + 1) := ⟨j, by simpa [L] using hj⟩
    have hr := (hborrow i).2.2 jj
    rw [hxi_eq j hj, heta_eq j hj,
      hbeta_eq j (by omega), hbeta_eq (j + 1) (by omega)]
    simpa [jj, OrderedPrimeFactorization.eta] using hr
  have hpoint :=
    DigitBorrowBridge.borrow_true_iff_residue_lt_of_weighted
      n k (F.p i) L eta xi beta hp0 hetaDigit hxiDigit
      hetaRecon hxiRecon hbeta0 hrows
  have hterminal : beta L = false := by
    rw [hbeta_eq L (by omega)]
    simpa [L] using (hborrow i).2.1
  simpa [L, beta] using
    (DigitBorrowBridge.inclusiveBorrowSum_eq_residueCarryCount
      n k (F.p i) beta hp hk hpoint hterminal)

/-! Forward projection from the raw integer system. -/

theorem G_to_factorTableauFeasible
    (F : OrderedPrimeFactorization n r) (B : ℤ)
    (hB : 2 ≤ B ∧ B ≤ (n : ℤ)) :
    G F B → FactorTableauFeasible n B.toNat := by
  rintro ⟨x, hselectorRows, hbounds, hprefix, hboundary,
    hdigit, hborrow, hbudget⟩
  rcases selectorFamily_sound F x.selector hselectorRows.1 with
    ⟨e, hselector, hExp, hZ, hEle, hsupp, _hprod⟩
  let E : ℕ →₀ ℕ := exponentVector F (fun i => (e i).val)
  let T : ℕ := x.T.toNat
  have hTnonneg : 0 ≤ x.T := le_trans (by norm_num) hbounds.1
  have hTcast : (T : ℤ) = x.T := by
    exact Int.toNat_of_nonneg hTnonneg
  have hBnonneg : 0 ≤ B := by omega
  have hBcast : (B.toNat : ℤ) = B := Int.toNat_of_nonneg hBnonneg
  have hD : x.finalD = (exponentProduct E : ℤ) := by
    simpa [E] using decoded_finalD F x hprefix e hselector
  have hK : x.finalK = (exponentProduct E : ℤ) * x.T := by
    simpa [E] using decoded_finalK F x hprefix e hselector
  have hxE : ∀ i, x.E i = ((e i).val : ℤ) := by
    intro i
    calc
      x.E i = selectedExponentZ (x.selector i) := hselectorRows.2.1 i
      _ = ((e i).val : ℤ) := hExp i
  have hxZ : ∀ i, (e i).val ≠ 0 → x.Z i = 1 := by
    intro i hi
    calc
      x.Z i = supportBitZ (x.selector i) := hselectorRows.2.2 i
      _ = 1 := by simpa [hi] using hZ i
  refine ⟨E, T, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro p hp
    rcases (hsupp p).mp (by simpa [E] using hp) with ⟨i, rfl, _⟩
    exact F.prime i
  · simpa [E] using hEle
  · have htz : (0 : ℤ) < (T : ℤ) := by
      rw [hTcast]
      exact lt_of_lt_of_le (by norm_num) hbounds.1
    exact_mod_cast htz
  · have hz : (B.toNat : ℤ) < (exponentProduct E : ℤ) := by
      calc
        (B.toNat : ℤ) = B := hBcast
        _ < B + 1 := by omega
        _ ≤ x.finalD := hboundary.1
        _ = (exponentProduct E : ℤ) := hD
    exact_mod_cast hz
  · have hz : ((exponentProduct E * T : ℕ) : ℤ) ≤ ((n / 2 : ℕ) : ℤ) := by
      rw [Nat.cast_mul, hTcast, ← hK]
      exact hboundary.2.1
    exact_mod_cast hz
  · intro p hp
    rcases (hsupp p).mp (by simpa [E] using hp) with ⟨i, hpi, hei⟩
    subst p
    have hZi : x.Z i = 1 := hxZ i hei
    have hdleZ :
        (exponentProduct E : ℤ) ≤
          ((B.toNat * F.p i : ℕ) : ℤ) := by
      rw [Nat.cast_mul, hBcast, ← hD]
      simpa [hZi] using hboundary.2.2 i
    have hdle : exponentProduct E ≤ B.toNat * F.p i := by
      exact_mod_cast hdleZ
    constructor
    · apply Nat.div_le_of_le_mul
      simpa [Nat.mul_comm] using hdle
    · let k : ℕ := exponentProduct E * T
      have hkhalf : k ≤ n / 2 := by
        dsimp [k]
        have hz : ((exponentProduct E * T : ℕ) : ℤ) ≤
            ((n / 2 : ℕ) : ℤ) := by
          rw [Nat.cast_mul, hTcast, ← hK]
          exact hboundary.2.1
        exact_mod_cast hz
      have hk : k ≤ n := le_trans hkhalf (Nat.div_le_self n 2)
      have hkZ : x.finalK = (k : ℤ) := by
        calc
          x.finalK = (exponentProduct E : ℤ) * x.T := hK
          _ = (exponentProduct E : ℤ) * (T : ℤ) := by rw [hTcast]
          _ = (k : ℤ) := by simp [k]
      have hsum := assignmentBorrowSum_eq_residueCarryCount
        F x hdigit hborrow i k hkZ hk
      have hcarryZ :
          (residueCarryCount n k (F.p i) : ℤ) ≤
            (F.a i : ℤ) - ((e i).val : ℤ) := by
        rw [← hsum]
        simpa [hxE i, hZi] using hbudget i
      have heia : (e i).val ≤ F.a i := Nat.le_of_lt_succ (e i).isLt
      have hcarryNat :
          residueCarryCount n k (F.p i) ≤ F.a i - (e i).val := by
        have hcast :
            ((F.a i - (e i).val : ℕ) : ℤ) =
              (F.a i : ℤ) - ((e i).val : ℤ) := Nat.cast_sub heia
        rw [← hcast] at hcarryZ
        exact_mod_cast hcarryZ
      simpa [k, E] using hcarryNat

/-! Arithmetic helpers for the canonical reverse witness. -/

theorem chosenPrimePower_dvd_n
    (F : OrderedPrimeFactorization n r) (i : Fin r)
    (e : Fin (F.a i + 1)) : F.p i ^ e.val ∣ n := by
  have he : e.val ≤ F.a i := Nat.le_of_lt_succ e.isLt
  have hpow : F.p i ^ e.val ∣ F.p i ^ F.a i := pow_dvd_pow _ he
  have hfactor :
      F.p i ^ F.a i ∣ ∏ j : Fin r, F.p j ^ F.a j := by
    exact Finset.dvd_prod_of_mem (fun j : Fin r => F.p j ^ F.a j)
      (Finset.mem_univ i)
  exact hpow.trans (by simpa [F.prod_eq] using hfactor)

theorem bigM_covers_product
    (N A C q : ℤ) (hN : 1 ≤ N)
    (hA : 1 ≤ A ∧ A ≤ N) (hC : 1 ≤ C ∧ C ≤ N)
    (hq : 1 ≤ q ∧ q ≤ N) :
    -N ^ 2 ≤ A - q * C ∧ A - q * C ≤ N ^ 2 := by
  have hqC0 : 0 ≤ q * C := mul_nonneg (by omega) (by omega)
  have hqCN : q * C ≤ N * N :=
    mul_le_mul hq.2 hC.2 (by omega) (by omega)
  constructor <;> nlinarith [sq_nonneg N]

theorem chosenProduct_eq_exponentProduct
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization) :
    (∏ i : Fin r, F.p i ^ (exponentChoice F E hE i).val) =
      exponentProduct E := by
  calc
    _ = exponentProduct
        (exponentVector F (fun i => (exponentChoice F E hE i).val)) :=
          (exponentProduct_exponentVector F
            (fun i => (exponentChoice F E hE i).val)).symm
    _ = exponentProduct E := congrArg exponentProduct
      (exponentVector_factorization_roundtrip F E hE)

theorem canonicalPrefix_le_exponentProduct
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ)
    (hE : E ≤ n.factorization)
    (hprime : ∀ p, p ∈ E.support → p.Prime) (s : Fin (r + 1)) :
    prefixNat F (exponentChoice F E hE) s ≤ exponentProduct E := by
  apply Nat.le_of_dvd (exponentProduct_pos E hprime)
  exact (prefixNat_dvd_full F (exponentChoice F E hE) s).trans
    (dvd_of_eq (chosenProduct_eq_exponentProduct F E hE))

noncomputable def canonicalAssignment
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization) : Assignment F where
  selector i := selectorOf (exponentChoice F E hE i)
  T := (T : ℤ)
  D s := (prefixNat F (exponentChoice F E hE) s : ℤ)
  K s := (prefixNat F (exponentChoice F E hE) s * T : ℕ)
  E i := (E (F.p i) : ℤ)
  Z i := if E (F.p i) = 0 then 0 else 1
  digit i j := DigitBorrowBridge.canonicalDigit
    (exponentProduct E * T) (F.p i) j.val
  borrow i j := DigitBorrowBridge.canonicalBorrow
    n (exponentProduct E * T) (F.p i) j.val

@[simp] theorem canonicalAssignment_finalD
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization) :
    (canonicalAssignment F E T hE).finalD = (exponentProduct E : ℤ) := by
  have hv := exponentVector_factorization_roundtrip F E hE
  have hp :
      (∏ i : Fin r, F.p i ^ (exponentChoice F E hE i).val) =
        exponentProduct E := by
    calc
      _ = exponentProduct
          (exponentVector F (fun i => (exponentChoice F E hE i).val)) :=
            (exponentProduct_exponentVector F
              (fun i => (exponentChoice F E hE i).val)).symm
      _ = exponentProduct E := congrArg exponentProduct hv
  change (prefixNat F (exponentChoice F E hE) (Fin.last r) : ℤ) = _
  rw [prefixNat_last, hp]

@[simp] theorem canonicalAssignment_finalK
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization) :
    (canonicalAssignment F E T hE).finalK =
      ((exponentProduct E * T : ℕ) : ℤ) := by
  have hv := exponentVector_factorization_roundtrip F E hE
  have hp :
      (∏ i : Fin r, F.p i ^ (exponentChoice F E hE i).val) =
        exponentProduct E := by
    calc
      _ = exponentProduct
          (exponentVector F (fun i => (exponentChoice F E hE i).val)) :=
            (exponentProduct_exponentVector F
              (fun i => (exponentChoice F E hE i).val)).symm
      _ = exponentProduct E := congrArg exponentProduct hv
  change ((prefixNat F (exponentChoice F E hE) (Fin.last r) * T : ℕ) : ℤ) = _
  rw [prefixNat_last, hp]

theorem canonicalAssignment_selectorRows
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization) :
    SelectorRows F (canonicalAssignment F E T hE) := by
  refine ⟨?_, ?_, ?_⟩
  · intro i
    exact selectorOf_oneHot (exponentChoice F E hE i)
  · intro i
    simp [canonicalAssignment]
  · intro i
    simp [canonicalAssignment]

theorem canonicalAssignment_integerBounds
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization)
    (hprime : ∀ p, p ∈ E.support → p.Prime)
    (hT : 0 < T) (hhalf : exponentProduct E * T ≤ n / 2) :
    IntegerBounds F (canonicalAssignment F E T hE) := by
  let d := exponentProduct E
  let k := d * T
  have hd : 0 < d := exponentProduct_pos E hprime
  have hk : 0 < k := Nat.mul_pos hd hT
  have hkn : k ≤ n := le_trans hhalf (Nat.div_le_self n 2)
  have hdn : d ≤ n := by
    have hdk : d ≤ k := by
      dsimp [k]
      simpa using Nat.mul_le_mul_left d hT
    exact hdk.trans hkn
  have hTn : T ≤ n := by
    have hTk : T ≤ k := by
      dsimp [k]
      calc
        T = T * 1 := by simp
        _ ≤ T * d := Nat.mul_le_mul_left T hd
        _ = d * T := by ac_rfl
    exact hTk.trans hkn
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · change (1 : ℤ) ≤ (T : ℤ)
    have hT1 : 1 ≤ T := by omega
    exact_mod_cast hT1
  · change (T : ℤ) ≤ (n : ℤ)
    exact_mod_cast hTn
  · intro s
    have hspos := prefixNat_pos F (exponentChoice F E hE) s
    have hsle := canonicalPrefix_le_exponentProduct F E hE hprime s
    constructor
    · change (1 : ℤ) ≤ (prefixNat F (exponentChoice F E hE) s : ℤ)
      exact_mod_cast hspos
    · change (prefixNat F (exponentChoice F E hE) s : ℤ) ≤ (n : ℤ)
      exact_mod_cast hsle.trans hdn
  · intro s
    have hspos := prefixNat_pos F (exponentChoice F E hE) s
    have hsle := canonicalPrefix_le_exponentProduct F E hE hprime s
    have hprodpos : 0 < prefixNat F (exponentChoice F E hE) s * T :=
      Nat.mul_pos hspos hT
    have hprodle : prefixNat F (exponentChoice F E hE) s * T ≤ n := by
      apply le_trans (Nat.mul_le_mul_right T hsle)
      exact hkn
    constructor
    · change (1 : ℤ) ≤
        ((prefixNat F (exponentChoice F E hE) s * T : ℕ) : ℤ)
      exact_mod_cast hprodpos
    · change ((prefixNat F (exponentChoice F E hE) s * T : ℕ) : ℤ) ≤
        (n : ℤ)
      exact_mod_cast hprodle
  · intro i
    constructor
    · simp [canonicalAssignment]
    · change (E (F.p i) : ℤ) ≤ (F.a i : ℤ)
      exact_mod_cast (show E (F.p i) ≤ F.a i by simpa using hE (F.p i))
  · intro i
    by_cases hi : E (F.p i) = 0 <;> simp [canonicalAssignment, hi]

theorem canonicalAssignment_prefixRows
    (F : OrderedPrimeFactorization n r) (E : ℕ →₀ ℕ) (T : ℕ)
    (hE : E ≤ n.factorization)
    (hprime : ∀ p, p ∈ E.support → p.Prime)
    (hT : 0 < T) (hhalf : exponentProduct E * T ≤ n / 2) :
    PrefixRows F (canonicalAssignment F E T hE) := by
  let x := canonicalAssignment F E T hE
  change PrefixRows F x
  have hbounds : IntegerBounds F x :=
    canonicalAssignment_integerBounds F E T hE hprime hT hhalf
  have hd : 0 < exponentProduct E := exponentProduct_pos E hprime
  have hk : 0 < exponentProduct E * T := Nat.mul_pos hd hT
  have hn : 0 < n := by
    have : exponentProduct E * T ≤ n :=
      hhalf.trans (Nat.div_le_self n 2)
    omega
  refine ⟨?_, ?_, ?_⟩
  · simp [x, canonicalAssignment, prefixNat_zero]
  · simp [x, canonicalAssignment, prefixNat_zero]
  · intro i e
    dsimp only
    by_cases he : e = exponentChoice F E hE i
    · subst e
      have hsel : x.selector i (exponentChoice F E hE i) = true := by
        simp [x, canonicalAssignment, selectorOf]
      have hD :
          x.D i.succ =
            ((F.p i ^ (exponentChoice F E hE i).val : ℕ) : ℤ) *
              x.D i.castSucc := by
        simp [x, canonicalAssignment, prefixNat_succ, Nat.cast_mul]
      have hK :
          x.K i.succ =
            ((F.p i ^ (exponentChoice F E hE i).val : ℕ) : ℤ) *
              x.K i.castSucc := by
        simp [x, canonicalAssignment, prefixNat_succ, Nat.cast_mul]
        ring
      rw [hsel, hD, hK]
      simp [bit, mul_assoc]
    · have hsel : x.selector i e = false := by
        simp [x, canonicalAssignment, selectorOf, he]
      have hqpos : 0 < F.p i ^ e.val := pow_pos (F.prime i).pos _
      have hqle : F.p i ^ e.val ≤ n :=
        Nat.le_of_dvd hn (chosenPrimePower_dvd_n F i e)
      have hnZ : (1 : ℤ) ≤ (n : ℤ) := by exact_mod_cast hn
      have hqZ :
          (1 : ℤ) ≤ ((F.p i ^ e.val : ℕ) : ℤ) ∧
            ((F.p i ^ e.val : ℕ) : ℤ) ≤ (n : ℤ) := by
        constructor <;> exact_mod_cast (by assumption)
      have hD := bigM_covers_product (n : ℤ)
        (x.D i.succ) (x.D i.castSucc) ((F.p i ^ e.val : ℕ) : ℤ)
        hnZ (hbounds.2.2.1 i.succ) (hbounds.2.2.1 i.castSucc) hqZ
      have hK := bigM_covers_product (n : ℤ)
        (x.K i.succ) (x.K i.castSucc) ((F.p i ^ e.val : ℕ) : ℤ)
        hnZ (hbounds.2.2.2.1 i.succ) (hbounds.2.2.2.1 i.castSucc) hqZ
      change
        (-((n : ℤ) ^ 2 * (1 - bit (x.selector i e))) ≤
            x.D i.succ - ((F.p i ^ e.val : ℕ) : ℤ) * x.D i.castSucc ∧
          x.D i.succ - ((F.p i ^ e.val : ℕ) : ℤ) * x.D i.castSucc ≤
            (n : ℤ) ^ 2 * (1 - bit (x.selector i e)) ∧
          -((n : ℤ) ^ 2 * (1 - bit (x.selector i e))) ≤
            x.K i.succ - ((F.p i ^ e.val : ℕ) : ℤ) * x.K i.castSucc ∧
          x.K i.succ - ((F.p i ^ e.val : ℕ) : ℤ) * x.K i.castSucc ≤
            (n : ℤ) ^ 2 * (1 - bit (x.selector i e)))
      rw [hsel]
      simp only [ExplicitTableau.bit, sub_zero, mul_one]
      constructor
      · linarith [hD.1]
      constructor
      · linarith [hD.2]
      constructor
      · linarith [hK.1]
      · linarith [hK.2]

theorem canonicalAssignment_boundaryRows
    (F : OrderedPrimeFactorization n r) (B : ℤ)
    (E : ℕ →₀ ℕ) (T : ℕ) (hE : E ≤ n.factorization)
    (hB : (2 : ℤ) ≤ B ∧ B ≤ (n : ℤ))
    (hprime : ∀ p, p ∈ E.support → p.Prime)
    (hT : 0 < T)
    (hbase : B.toNat < exponentProduct E)
    (hhalf : exponentProduct E * T ≤ n / 2)
    (hrows : ∀ p, p ∈ E.support →
      exponentProduct E / p ≤ B.toNat ∧
      residueCarryCount n (exponentProduct E * T) p ≤
        n.factorization p - E p) :
    BoundaryRows F B (canonicalAssignment F E T hE) := by
  let d := exponentProduct E
  let k := d * T
  have hB0 : 0 ≤ B := le_trans (by norm_num : (0 : ℤ) ≤ 2) hB.1
  have hBcoe : (B.toNat : ℤ) = B := by
    exact Int.toNat_of_nonneg hB0
  have hdpos : 0 < d := exponentProduct_pos E hprime
  have hkpos : 0 < k := Nat.mul_pos hdpos hT
  have hdn : d ≤ n := by
    have hk_le_n : k ≤ n := hhalf.trans (Nat.div_le_self n 2)
    exact le_trans (Nat.le_mul_of_pos_right d hT) hk_le_n
  refine ⟨?_, ?_, ?_⟩
  · rw [canonicalAssignment_finalD]
    rw [← hBcoe]
    exact_mod_cast (Nat.succ_le_iff.mpr hbase)
  · rw [canonicalAssignment_finalK]
    exact_mod_cast hhalf
  · intro i
    rw [canonicalAssignment_finalD]
    by_cases hi : E (F.p i) = 0
    · simp [canonicalAssignment, hi]
      have hnonneg : (0 : ℤ) ≤ B * (F.p i : ℤ) :=
        mul_nonneg hB0 (by positivity)
      have hdnZ : (d : ℤ) ≤ (n : ℤ) := by exact_mod_cast hdn
      omega
    · have hmem : F.p i ∈ E.support := Finsupp.mem_support_iff.mpr hi
      have hpdiv : F.p i ∣ d := by
        apply Nat.dvd_of_factorization_pos
        rw [factorization_exponentProduct E hprime]
        exact hi
      have hmul : d ≤ B.toNat * F.p i := by
        have hm := Nat.mul_le_mul_right (F.p i) (hrows (F.p i) hmem).1
        calc
          d = d / F.p i * F.p i := (Nat.div_mul_cancel hpdiv).symm
          _ ≤ B.toNat * F.p i := hm
      simp [canonicalAssignment, hi]
      rw [← hBcoe]
      exact_mod_cast hmul

theorem canonicalAssignment_digitRows
    (F : OrderedPrimeFactorization n r)
    (E : ℕ →₀ ℕ) (T : ℕ) (hE : E ≤ n.factorization)
    (hprime : ∀ p, p ∈ E.support → p.Prime)
    (hT : 0 < T)
    (hhalf : exponentProduct E * T ≤ n / 2) :
    DigitRows F (canonicalAssignment F E T hE) := by
  let k := exponentProduct E * T
  have hk_le_n : k ≤ n := hhalf.trans (Nat.div_le_self n 2)
  constructor
  · intro i j
    simpa [canonicalAssignment, k] using
      DigitBorrowBridge.canonicalDigit_bounds k (F.p i) j.val (F.prime i).pos
  · intro i
    let L := F.height i + 1
    have hncut : n < F.p i ^ L := by
      simpa [L, OrderedPrimeFactorization.height] using
        DigitBorrowBridge.lt_pow_logLength n (F.p i) (F.prime i).one_lt
    have hkcut : k < F.p i ^ L := lt_of_le_of_lt hk_le_n hncut
    have hrange :=
      DigitBorrowBridge.canonical_weighted_reconstruction k (F.p i) L hkcut
    rw [canonicalAssignment_finalK]
    change (k : ℤ) = _
    calc
      (k : ℤ) =
          ∑ j ∈ Finset.range L,
            DigitBorrowBridge.canonicalDigit k (F.p i) j *
              (((F.p i) ^ j : ℕ) : ℤ) := hrange.symm
      _ = ∑ j : Fin L,
            DigitBorrowBridge.canonicalDigit k (F.p i) j.val *
              (((F.p i) ^ j.val : ℕ) : ℤ) := by
          symm
          exact Fin.sum_univ_eq_sum_range
            (fun j => DigitBorrowBridge.canonicalDigit k (F.p i) j *
              (((F.p i) ^ j : ℕ) : ℤ)) L
      _ = ∑ j : Fin (F.height i + 1),
            (canonicalAssignment F E T hE).digit i j *
              (((F.p i) ^ j.val : ℕ) : ℤ) := by
          simp [L, k, canonicalAssignment]

theorem canonicalAssignment_borrowRows
    (F : OrderedPrimeFactorization n r)
    (E : ℕ →₀ ℕ) (T : ℕ) (hE : E ≤ n.factorization)
    (hhalf : exponentProduct E * T ≤ n / 2) :
    BorrowRows F (canonicalAssignment F E T hE) := by
  let k := exponentProduct E * T
  have hk_le_n : k ≤ n := hhalf.trans (Nat.div_le_self n 2)
  intro i
  refine ⟨?_, ?_, ?_⟩
  · simp [canonicalAssignment, DigitBorrowBridge.canonicalBorrow,
      DigitBorrowBridge.makeBorrow]
  · simpa [canonicalAssignment, k, OrderedPrimeFactorization.height] using
      DigitBorrowBridge.canonicalBorrow_terminal_false
        n k (F.p i) (F.prime i).two_le hk_le_n
  · intro j
    simpa [canonicalAssignment, k, OrderedPrimeFactorization.eta] using
      DigitBorrowBridge.canonicalBorrow_rows
        n k (F.p i) (F.prime i).two_le j.val

theorem sum_bit_Ico_le_length (beta : ℕ → Bool) (L : ℕ) :
    (∑ t ∈ Finset.Ico 1 (L + 1), bit (beta t)) ≤ (L : ℤ) := by
  calc
    (∑ t ∈ Finset.Ico 1 (L + 1), bit (beta t)) ≤
        ∑ _t ∈ Finset.Ico 1 (L + 1), (1 : ℤ) := by
          apply Finset.sum_le_sum
          intro t ht
          cases h : beta t <;> simp [bit]
    _ = (L : ℤ) := by simp

theorem canonicalAssignment_inclusiveBorrowSum
    (F : OrderedPrimeFactorization n r)
    (E : ℕ →₀ ℕ) (T : ℕ) (hE : E ≤ n.factorization)
    (hhalf : exponentProduct E * T ≤ n / 2) (i : Fin r) :
    (∑ t ∈ Finset.Ico 1 (F.height i + 1 + 1),
        bit (DigitBorrowBridge.finAt
          ((canonicalAssignment F E T hE).borrow i) false t)) =
      (residueCarryCount n (exponentProduct E * T) (F.p i) : ℤ) := by
  let k := exponentProduct E * T
  have hk_le_n : k ≤ n := hhalf.trans (Nat.div_le_self n 2)
  calc
    (∑ t ∈ Finset.Ico 1 (F.height i + 1 + 1),
        bit (DigitBorrowBridge.finAt
          ((canonicalAssignment F E T hE).borrow i) false t)) =
        ∑ t ∈ Finset.Ico 1 (F.height i + 1 + 1),
          bit (DigitBorrowBridge.canonicalBorrow n k (F.p i) t) := by
            apply Finset.sum_congr rfl
            intro t ht
            simp only [canonicalAssignment]
            unfold DigitBorrowBridge.finAt
            rw [dif_pos (by
              have := (Finset.mem_Ico.mp ht).2
              omega)]
    _ = (residueCarryCount n k (F.p i) : ℤ) := by
      simpa [OrderedPrimeFactorization.height, k] using
        DigitBorrowBridge.canonicalBorrow_inclusiveSum
          n k (F.p i) (F.prime i).two_le hk_le_n

theorem canonicalAssignment_budgetRows
    (F : OrderedPrimeFactorization n r)
    (B : ℤ) (E : ℕ →₀ ℕ) (T : ℕ) (hE : E ≤ n.factorization)
    (hhalf : exponentProduct E * T ≤ n / 2)
    (hrows : ∀ p, p ∈ E.support →
      exponentProduct E / p ≤ B.toNat ∧
      residueCarryCount n (exponentProduct E * T) p ≤
        n.factorization p - E p) :
    BudgetRows F (canonicalAssignment F E T hE) := by
  intro i
  let L := F.height i + 1
  by_cases hi : E (F.p i) = 0
  · have hsum := sum_bit_Ico_le_length
        (fun t => DigitBorrowBridge.finAt
          ((canonicalAssignment F E T hE).borrow i) false t) L
    change
      (∑ t ∈ Finset.Ico 1 (L + 1),
          bit (DigitBorrowBridge.finAt
            ((canonicalAssignment F E T hE).borrow i) false t)) ≤
        (F.a i : ℤ) - (E (F.p i) : ℤ) +
          (L : ℤ) *
            (1 - (if E (F.p i) = 0 then (0 : ℤ) else 1))
    have ha0 : (0 : ℤ) ≤ (F.a i : ℤ) := by positivity
    have hAL : (L : ℤ) ≤ (F.a i : ℤ) + (L : ℤ) := by omega
    have hbound := hsum.trans hAL
    simpa [hi] using hbound
  · have hmem : F.p i ∈ E.support := Finsupp.mem_support_iff.mpr hi
    rw [canonicalAssignment_inclusiveBorrowSum F E T hE hhalf i]
    change
      (residueCarryCount n (exponentProduct E * T) (F.p i) : ℤ) ≤
        (F.a i : ℤ) - (E (F.p i) : ℤ) +
          ((F.height i + 1 : ℕ) : ℤ) *
            (1 - (if E (F.p i) = 0 then (0 : ℤ) else 1))
    rw [if_neg hi]
    simp only [sub_self, mul_zero, add_zero]
    have hr :
        residueCarryCount n (exponentProduct E * T) (F.p i) ≤
          F.a i - E (F.p i) := by
      simpa using (hrows (F.p i) hmem).2
    have hEi : E (F.p i) ≤ F.a i := by
      simpa using hE (F.p i)
    rw [← Nat.cast_sub hEi]
    exact_mod_cast hr

theorem factorTableauFeasible_to_G
    (F : OrderedPrimeFactorization n r) (B : ℤ)
    (hB : (2 : ℤ) ≤ B ∧ B ≤ (n : ℤ)) :
    FactorTableauFeasible n B.toNat → G F B := by
  rintro ⟨E, T, hprime, hE, hT, hbase, hhalf, hrows⟩
  refine ⟨canonicalAssignment F E T hE, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact canonicalAssignment_selectorRows F E T hE
  · exact canonicalAssignment_integerBounds F E T hE hprime hT hhalf
  · exact canonicalAssignment_prefixRows F E T hE hprime hT hhalf
  · exact canonicalAssignment_boundaryRows
      F B E T hE hB hprime hT hbase hhalf hrows
  · exact canonicalAssignment_digitRows F E T hE hprime hT hhalf
  · exact canonicalAssignment_borrowRows F E T hE hhalf
  · exact canonicalAssignment_budgetRows F B E T hE hhalf hrows

/-- Exact global projection equivalence between the explicit integer/Boolean
system and the semantic factor tableau. -/
theorem explicitG_iff_factorTableauFeasible
    (F : OrderedPrimeFactorization n r) (B : ℤ)
    (hB : (2 : ℤ) ≤ B ∧ B ≤ (n : ℤ)) :
    G F B ↔ FactorTableauFeasible n B.toNat := by
  constructor
  · exact G_to_factorTableauFeasible F B hB
  · exact factorTableauFeasible_to_G F B hB

end
end ExplicitG
end Erdos700PartI
