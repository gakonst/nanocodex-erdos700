import PartIWork.BoundaryAntichain

/-!
# Full cross-base digit-shadow characterization

This module replaces carry-count notation by explicit prefix comparisons in
each active prime base while retaining one common admissible row.
-/

namespace Erdos700PartI

/-- Number of base-`p` prefixes at which `k` overtakes `n`. -/
def fullDigitShadowCount (n k p : ℕ) : ℕ :=
  ((Finset.Ico 1 (Nat.log p n + 1)).filter fun i =>
    n % p ^ i < k % p ^ i).card

theorem carryResidue_iff_fullDigitOvertake
    (n k q : ℕ) (hk : k ≤ n) (hq : 0 < q) :
    q ≤ k % q + (n - k) % q ↔ n % q < k % q := by
  let a := k % q
  let b := (n - k) % q
  let s := a + b
  have ha : a < q := by
    dsimp [a]
    exact Nat.mod_lt _ hq
  have hb : b < q := by
    dsimp [b]
    exact Nat.mod_lt _ hq
  have hsum : k + (n - k) = n := by
    simpa [Nat.add_comm] using Nat.sub_add_cancel hk
  have hnmod : n % q = s % q := by
    calc
      n % q = (k + (n - k)) % q :=
        congrArg (fun x : ℕ => x % q) hsum.symm
      _ = (k % q + (n - k) % q) % q := Nat.add_mod _ _ _
      _ = s % q := by rfl
  change q ≤ a + b ↔ n % q < a
  rw [hnmod]
  by_cases hs : s < q
  · rw [Nat.mod_eq_of_lt hs]
    dsimp [s]
    constructor <;> intro h <;> omega
  · have hqs : q ≤ s := Nat.le_of_not_gt hs
    have hslt : s < q + q := by
      dsimp [s]
      omega
    have hsub : s - q < q := by omega
    have hdecomp : s = q + (s - q) := by omega
    have hsmod : s % q = s - q := by
      calc
        s % q = (q + (s - q)) % q :=
          congrArg (fun x : ℕ => x % q) hdecomp
        _ = (s - q) % q := by simp
        _ = s - q := Nat.mod_eq_of_lt hsub
    rw [hsmod]
    dsimp [s] at *
    constructor <;> intro h <;> omega

theorem residueCarryCount_eq_fullDigitShadowCount
    (n k p : ℕ) (hkn : k ≤ n) (hp : p.Prime) :
    residueCarryCount n k p = fullDigitShadowCount n k p := by
  unfold residueCarryCount fullDigitShadowCount
  apply congrArg Finset.card
  ext i
  simp only [Finset.mem_filter]
  constructor
  · rintro ⟨hi, hcarry⟩
    exact
      ⟨hi, (carryResidue_iff_fullDigitOvertake
        n k (p ^ i) hkn (pow_pos hp.pos i)).mp hcarry⟩
  · rintro ⟨hi, hshadow⟩
    exact
      ⟨hi, (carryResidue_iff_fullDigitOvertake
        n k (p ^ i) hkn (pow_pos hp.pos i)).mpr hshadow⟩

/-- One fixed common period for all prime-base shadow constraints of `d`. -/
def fullShadowPeriod (n d : ℕ) : ℕ :=
  d.primeFactors.prod (fun p => p ^ Nat.log p n)

theorem fullShadowPeriod_pos (n d : ℕ) :
    0 < fullShadowPeriod n d := by
  classical
  unfold fullShadowPeriod
  apply Finset.prod_pos
  intro p hp
  exact pow_pos (Nat.prime_of_mem_primeFactors hp).pos _

theorem primePowerLog_dvd_fullShadowPeriod
    (n d p : ℕ) (hp : p ∈ d.primeFactors) :
    p ^ Nat.log p n ∣ fullShadowPeriod n d := by
  classical
  unfold fullShadowPeriod
  apply Finset.dvd_prod_of_mem
  exact hp

private theorem shadowPow_dvd_pow_of_le
    (p i j : ℕ) (hij : i ≤ j) :
    p ^ i ∣ p ^ j := by
  refine ⟨p ^ (j - i), ?_⟩
  have hexp : i + (j - i) = j := by
    simpa [Nat.add_comm] using Nat.sub_add_cancel hij
  calc
    p ^ j = p ^ (i + (j - i)) := by rw [hexp]
    _ = p ^ i * p ^ (j - i) := by rw [pow_add]

private theorem shadow_mod_eq_of_mod_eq_of_dvd
    (a b Q q : ℕ)
    (hqQ : q ∣ Q)
    (hmod : a % Q = b % Q) :
    a % q = b % q := by
  have ha : (a % Q) % q = a % q := by
    apply Nat.mod_mod_of_dvd
    exact hqQ
  have hb : (b % Q) % q = b % q := by
    apply Nat.mod_mod_of_dvd
    exact hqQ
  calc
    a % q = (a % Q) % q := ha.symm
    _ = (b % Q) % q := congrArg (fun x : ℕ => x % q) hmod
    _ = b % q := hb

private theorem shadow_mul_mod_eq_of_mod_eq
    (d a b q : ℕ)
    (hmod : a % q = b % q) :
    (d * a) % q = (d * b) % q := by
  calc
    (d * a) % q = (d % q * (a % q)) % q := Nat.mul_mod _ _ _
    _ = (d % q * (b % q)) % q := by rw [hmod]
    _ = (d * b) % q := (Nat.mul_mod _ _ _).symm

theorem fullDigitShadowCount_periodic
    (n d m r p : ℕ)
    (hd : 0 < d)
    (hp : p.Prime)
    (hpd : p ∣ d)
    (hmod :
      m % fullShadowPeriod n d =
        r % fullShadowPeriod n d) :
    fullDigitShadowCount n (d * m) p =
      fullDigitShadowCount n (d * r) p := by
  classical
  have hpmem : p ∈ d.primeFactors := by
    have hiff : p ∈ d.primeFactors ↔ p ∣ d := by
      simp [Nat.mem_primeFactors, hp, hd.ne']
    exact hiff.mpr hpd
  have hprefix :
      ∀ i ∈ Finset.Ico 1 (Nat.log p n + 1),
        (d * m) % p ^ i = (d * r) % p ^ i := by
    intro i hi
    have hiLe : i ≤ Nat.log p n := by
      have hiLt := (Finset.mem_Ico.mp hi).2
      omega
    have hsmall :
        p ^ i ∣ p ^ Nat.log p n :=
      shadowPow_dvd_pow_of_le p i (Nat.log p n) hiLe
    have hlarge :
        p ^ Nat.log p n ∣ fullShadowPeriod n d :=
      primePowerLog_dvd_fullShadowPeriod n d p hpmem
    have hpowPeriod :
        p ^ i ∣ fullShadowPeriod n d :=
      dvd_trans hsmall hlarge
    have hmr :
        m % p ^ i = r % p ^ i :=
      shadow_mod_eq_of_mod_eq_of_dvd
        m r (fullShadowPeriod n d) (p ^ i) hpowPeriod hmod
    exact shadow_mul_mod_eq_of_mod_eq d m r (p ^ i) hmr
  unfold fullDigitShadowCount
  apply congrArg Finset.card
  ext i
  simp only [Finset.mem_filter]
  constructor
  · rintro ⟨hi, hlt⟩
    refine ⟨hi, ?_⟩
    simpa only [hprefix i hi] using hlt
  · rintro ⟨hi, hlt⟩
    refine ⟨hi, ?_⟩
    simpa only [hprefix i hi] using hlt

/-- Least-positive representative, sending the zero class to `Q`. -/
def fullShadowPositiveResidue (m Q : ℕ) : ℕ :=
  (m - 1) % Q + 1

theorem fullShadowPositiveResidue_pos (m Q : ℕ) :
    0 < fullShadowPositiveResidue m Q := by
  unfold fullShadowPositiveResidue
  omega

theorem fullShadowPositiveResidue_le_period
    (m Q : ℕ) (hQ : 0 < Q) :
    fullShadowPositiveResidue m Q ≤ Q := by
  have hlt : (m - 1) % Q < Q := Nat.mod_lt _ hQ
  unfold fullShadowPositiveResidue
  omega

theorem fullShadowPositiveResidue_le_self
    (m Q : ℕ) (hm : 0 < m) :
    fullShadowPositiveResidue m Q ≤ m := by
  have hle : (m - 1) % Q ≤ m - 1 := Nat.mod_le _ _
  have hmEq : m - 1 + 1 = m := Nat.sub_add_cancel (by omega)
  unfold fullShadowPositiveResidue
  omega

theorem fullShadowPositiveResidue_mod
    (m Q : ℕ) (hm : 0 < m) :
    fullShadowPositiveResidue m Q % Q = m % Q := by
  unfold fullShadowPositiveResidue
  have hmEq : m - 1 + 1 = m := Nat.sub_add_cancel (by omega)
  calc
    ((m - 1) % Q + 1) % Q =
        (((m - 1) % Q) % Q + 1 % Q) % Q :=
      Nat.add_mod _ _ _
    _ = ((m - 1) % Q + 1 % Q) % Q := by rw [Nat.mod_mod]
    _ = ((m - 1) + 1) % Q := (Nat.add_mod _ _ _).symm
    _ = m % Q := by rw [hmEq]

/-- Finite common-residue realization criterion. -/
def FiniteShadowOccurs (n d : ℕ) : Prop :=
  ∃ r ∈ Finset.Icc 1 (fullShadowPeriod n d),
    d * r ≤ n / 2 ∧
      ∀ p, p.Prime → p ∣ d →
        fullDigitShadowCount n (d * r) p ≤
          n.factorization p - d.factorization p

theorem finiteShadowOccurs_iff_realized
    (n d : ℕ) (hn : 0 < n) (hdn : d ∣ n) :
    FiniteShadowOccurs n d ↔ Realized n d := by
  have hdpos : 0 < d := by
    apply Nat.pos_of_ne_zero
    intro hd0
    subst d
    obtain ⟨c, hc⟩ := hdn
    simp at hc
    omega
  have hhalf : n / 2 ≤ n := Nat.div_le_self n 2
  unfold FiniteShadowOccurs Realized
  constructor
  · rintro ⟨r, hrmem, hbound, hshadow⟩
    have hrange := Finset.mem_Icc.mp hrmem
    have hrpos : 0 < r := by omega
    refine ⟨r, hrpos, hbound, ?_⟩
    intro p hp hpd
    have hrn : d * r ≤ n := hbound.trans hhalf
    rw [residueCarryCount_eq_fullDigitShadowCount
      n (d * r) p hrn hp]
    exact hshadow p hp hpd
  · rintro ⟨m, hm, hbound, hcarry⟩
    let Q := fullShadowPeriod n d
    let r := fullShadowPositiveResidue m Q
    have hQpos : 0 < Q := by
      simpa [Q] using fullShadowPeriod_pos n d
    have hrpos : 0 < r := by
      simpa [r] using fullShadowPositiveResidue_pos m Q
    have hrQ : r ≤ Q := by
      simpa [r] using fullShadowPositiveResidue_le_period m Q hQpos
    have hrm : r ≤ m := by
      simpa [r] using fullShadowPositiveResidue_le_self m Q hm
    have hrmem : r ∈ Finset.Icc 1 Q :=
      Finset.mem_Icc.mpr ⟨by omega, hrQ⟩
    have hrbound : d * r ≤ n / 2 := by
      exact (Nat.mul_le_mul_left d hrm).trans hbound
    have hresidue : r % Q = m % Q := by
      simpa [r] using fullShadowPositiveResidue_mod m Q hm
    have hmod :
        m % fullShadowPeriod n d =
          r % fullShadowPeriod n d := by
      simpa [Q] using hresidue.symm
    have hmn : d * m ≤ n := hbound.trans hhalf
    refine ⟨r, ?_, hrbound, ?_⟩
    · simpa [Q] using hrmem
    · intro p hp hpd
      have hperiod :
          fullDigitShadowCount n (d * m) p =
            fullDigitShadowCount n (d * r) p :=
        fullDigitShadowCount_periodic
          n d m r p hdpos hp hpd hmod
      have hmshadow :
          fullDigitShadowCount n (d * m) p ≤
            n.factorization p - d.factorization p := by
        rw [← residueCarryCount_eq_fullDigitShadowCount
          n (d * m) p hmn hp]
        exact hcarry p hp hpd
      simpa only [hperiod] using hmshadow

def FullShadowBoundary (n d : ℕ) : Prop :=
  d ∣ n ∧
    Erdos700.P n < d ∧
      ∀ p, p.Prime → p ∣ d → d / p ≤ Erdos700.P n

/-- Contains no `f`, gcd, binomial coefficient, `Realized`, or
`BoundarySafe`. -/
def FullShadowSafe (n : ℕ) : Prop :=
  ∀ d, FullShadowBoundary n d → ¬ FiniteShadowOccurs n d

theorem fullShadowBoundary_iff_boundary (n d : ℕ) :
    FullShadowBoundary n d ↔ Boundary n d := by
  rfl

theorem fullShadowSafe_iff_boundarySafe
    (n : ℕ) (hn : 0 < n) :
    FullShadowSafe n ↔ BoundarySafe n := by
  constructor
  · intro hsafe d hd hreal
    exact
      hsafe d
        ((fullShadowBoundary_iff_boundary n d).mpr hd)
        ((finiteShadowOccurs_iff_realized n d hn hd.1).mpr hreal)
  · intro hsafe d hd hfinite
    have hd' : Boundary n d :=
      (fullShadowBoundary_iff_boundary n d).mp hd
    exact
      hsafe d hd'
        ((finiteShadowOccurs_iff_realized n d hn hd'.1).mp hfinite)

theorem f_eq_div_iff_fullShadowSafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ FullShadowSafe n := by
  exact
    (f_eq_div_iff_boundarySafe n hn hnprime).trans
      (fullShadowSafe_iff_boundarySafe n (by omega)).symm

end Erdos700PartI

#print axioms Erdos700PartI.finiteShadowOccurs_iff_realized
#print axioms Erdos700PartI.fullShadowSafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_fullShadowSafe
