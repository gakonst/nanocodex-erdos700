import PartIWork.LargestPrime

/-!
# Boundary-antichain characterization for Erdős 700(i)
-/

namespace Erdos700PartI

def Boundary (n d : ℕ) : Prop :=
  d ∣ n ∧
    Erdos700.P n < d ∧
      ∀ p, p.Prime → p ∣ d → d / p ≤ Erdos700.P n

def Realized (n d : ℕ) : Prop :=
  ∃ m, 0 < m ∧ d * m ≤ n / 2 ∧
    ∀ p, p.Prime → p ∣ d →
      residueCarryCount n (d * m) p ≤
        n.factorization p - d.factorization p

def BoundarySafe (n : ℕ) : Prop :=
  ∀ d, Boundary n d → ¬ Realized n d

/-- No proper divisor of `d` remains above `P n`. -/
def MinimalOverweightDivisor (n d : ℕ) : Prop :=
  d ∣ n ∧
    Erdos700.P n < d ∧
      ∀ e, e ∣ d → e < d → e ≤ Erdos700.P n

/--
The complementary carry weight divides the index. This follows from
`n ∣ choose n k * k` and comparison of prime factorizations.
-/
theorem residueCarryWeight_dvd_index
    (n k : ℕ) (hn : 0 < n) (hk : 0 < k) (hkn : k ≤ n) :
    residueCarryWeight n k ∣ k := by
  apply
    (Nat.factorization_prime_le_iff_dvd
      (residueCarryWeight_pos n k).ne' hk.ne').mp
  intro p hp
  rw [factorization_residueCarryWeight n k p hp]
  by_cases hmem : p ∈ n.primeFactors
  · rw [if_pos hmem]
    have hchoose : 0 < n.choose k :=
      Nat.choose_pos hkn
    have hident :
        n * (n - 1).choose (k - 1) = n.choose k * k := by
      have hn_one : 1 ≤ n := by omega
      have hk_one : 1 ≤ k := by omega
      simpa only [Nat.sub_add_cancel hn_one, Nat.sub_add_cancel hk_one] using
        Nat.add_one_mul_choose_eq (n - 1) (k - 1)
    have hndvd : n ∣ n.choose k * k :=
      ⟨(n - 1).choose (k - 1), hident.symm⟩
    have hprodpos : 0 < n.choose k * k :=
      Nat.mul_pos hchoose hk
    have hfac :=
      ((Nat.factorization_prime_le_iff_dvd
        hn.ne' hprodpos.ne').mpr hndvd) p hp
    rw [Nat.factorization_mul hchoose.ne' hk.ne'] at hfac
    change
      n.factorization p ≤
        (n.choose k).factorization p + k.factorization p
      at hfac
    have hc :=
      residueCarryCount_eq_factorization_choose n k p hp hkn
    rw [← hc] at hfac
    omega
  · rw [if_neg hmem]
    exact Nat.zero_le _

theorem residueCarryWeight_dvd_of_admissible
    (n k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    residueCarryWeight n k ∣ k := by
  apply residueCarryWeight_dvd_index n k hn
  · exact Nat.zero_lt_of_lt hk.1
  · exact hk.2.trans (Nat.div_le_self n 2)

theorem residueCarryWeight_dvd_n_of_admissible
    (n k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    residueCarryWeight n k ∣ n := by
  have hexact := (residueCarryWeight_exact n k hn hk).2
  refine ⟨Nat.gcd n (n.choose k), ?_⟩
  simpa [Nat.mul_comm] using hexact.symm

/--
The prime-deletion definition of `Boundary` is equivalent to having no
proper divisor above `P n`.
-/
theorem minimalOverweightDivisor_iff_boundary (n d : ℕ) :
    MinimalOverweightDivisor n d ↔ Boundary n d := by
  unfold MinimalOverweightDivisor Boundary
  constructor
  · rintro ⟨hdn, hPd, hminimal⟩
    refine ⟨hdn, hPd, ?_⟩
    intro p hp hpd
    have hdpos : 0 < d := by omega
    apply hminimal (d / p)
    · exact ⟨p, (Nat.div_mul_cancel hpd).symm⟩
    · exact Nat.div_lt_self hdpos hp.one_lt
  · rintro ⟨hdn, hPd, hprime⟩
    refine ⟨hdn, hPd, ?_⟩
    intro e hed he_lt
    by_contra heP
    have hPe : Erdos700.P n < e :=
      Nat.lt_of_not_ge heP
    obtain ⟨q, hq⟩ := hed
    have hq1 : q ≠ 1 := by
      intro h
      subst q
      simp at hq
      omega
    obtain ⟨p, hp, hpq⟩ :=
      Nat.exists_prime_and_dvd hq1
    obtain ⟨r, hr⟩ := hpq
    have hpd : p ∣ d := by
      refine ⟨e * r, ?_⟩
      calc
        d = e * q := hq
        _ = e * (p * r) := by rw [hr]
        _ = p * (e * r) := by ac_rfl
    have hermul : (e * r) * p = d := by
      calc
        (e * r) * p = e * (p * r) := by ac_rfl
        _ = e * q := by rw [hr]
        _ = d := hq.symm
    have hpmul : p * (e * r) = d := by
      simpa [Nat.mul_comm] using hermul
    have hquot : d / p = e * r :=
      (Nat.eq_div_of_mul_eq_right hp.ne_zero hpmul).symm
    have hp_le_d : p ≤ d :=
      Nat.le_of_dvd (by omega) hpd
    have hquotpos : 0 < d / p :=
      Nat.div_pos hp_le_d hp.pos
    have hediv : e ∣ d / p :=
      ⟨r, hquot⟩
    have he_le : e ≤ d / p :=
      Nat.le_of_dvd hquotpos hediv
    have hquot_le := hprime p hp hpd
    omega

/--
An overweight carry weight has a minimal overweight divisor of `n`, and
conversely any such divisor forces the weight above `P n`.
-/
theorem lt_residueCarryWeight_iff_exists_minimalOverweightDivisor
    (n k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    Erdos700.P n < residueCarryWeight n k ↔
      ∃ d, d ∣ residueCarryWeight n k ∧
        MinimalOverweightDivisor n d := by
  constructor
  · intro hPW
    have hWn :=
      residueCarryWeight_dvd_n_of_admissible n k hn hk
    let hex :
        ∃ e : ℕ,
          e ∣ residueCarryWeight n k ∧ Erdos700.P n < e :=
      ⟨residueCarryWeight n k,
        ⟨⟨1, by simp⟩, hPW⟩⟩
    let d := Nat.find hex
    have hd :
        d ∣ residueCarryWeight n k ∧ Erdos700.P n < d := by
      exact Nat.find_spec hex
    refine ⟨d, hd.1, ?_⟩
    unfold MinimalOverweightDivisor
    refine ⟨dvd_trans hd.1 hWn, hd.2, ?_⟩
    intro e hed he_lt
    by_contra heP
    have hPe : Erdos700.P n < e :=
      Nat.lt_of_not_ge heP
    have heW : e ∣ residueCarryWeight n k :=
      dvd_trans hed hd.1
    have hde : d ≤ e :=
      Nat.find_min' hex ⟨heW, hPe⟩
    omega
  · rintro ⟨d, hdW, hminimal⟩
    have hPd : Erdos700.P n < d :=
      hminimal.2.1
    have hdle :
        d ≤ residueCarryWeight n k :=
      Nat.le_of_dvd (residueCarryWeight_pos n k) hdW
    exact hPd.trans_le hdle

theorem lt_residueCarryWeight_iff_exists_boundary
    (n k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    Erdos700.P n < residueCarryWeight n k ↔
      ∃ d, Boundary n d ∧ d ∣ residueCarryWeight n k := by
  constructor
  · intro h
    obtain ⟨d, hdW, hminimal⟩ :=
      (lt_residueCarryWeight_iff_exists_minimalOverweightDivisor
        n k hn hk).mp h
    exact
      ⟨d,
        (minimalOverweightDivisor_iff_boundary n d).mp hminimal,
        hdW⟩
  · rintro ⟨d, hd, hdW⟩
    apply
      (lt_residueCarryWeight_iff_exists_minimalOverweightDivisor
        n k hn hk).mpr
    exact
      ⟨d, hdW,
        (minimalOverweightDivisor_iff_boundary n d).mpr hd⟩

/--
For a divisor `d` of `n`, divisibility by the carry weight is exactly the
displayed family of carry-budget inequalities.
-/
theorem dvd_residueCarryWeight_iff_carryInequalities
    (n k d : ℕ) (hn : 0 < n) (hdn : d ∣ n) :
    d ∣ residueCarryWeight n k ↔
      ∀ p, p.Prime → p ∣ d →
        residueCarryCount n k p ≤
          n.factorization p - d.factorization p := by
  have hdne : d ≠ 0 := by
    intro hdz
    subst d
    obtain ⟨c, hc⟩ := hdn
    simp at hc
    omega
  have hwne : residueCarryWeight n k ≠ 0 :=
    (residueCarryWeight_pos n k).ne'
  constructor
  · intro hdW p hp hpd
    have hfac :=
      ((Nat.factorization_prime_le_iff_dvd hdne hwne).mpr hdW)
        p hp
    have hpn : p ∣ n :=
      dvd_trans hpd hdn
    have hmem : p ∈ n.primeFactors ↔ p ∣ n :=
      by simp [Nat.mem_primeFactors, hp, hn.ne']
    rw [factorization_residueCarryWeight n k p hp,
      if_pos (hmem.mpr hpn)] at hfac
    have hdnfac :=
      ((Nat.factorization_prime_le_iff_dvd hdne hn.ne').mpr hdn)
        p hp
    have hpfac : 1 ≤ d.factorization p := by
      have hraw :=
        ((Nat.factorization_prime_le_iff_dvd hp.ne_zero hdne).mpr hpd)
          p hp
      simpa [hp.factorization_self] using hraw
    omega
  · intro hcarry
    apply
      (Nat.factorization_prime_le_iff_dvd hdne hwne).mp
    intro p hp
    rw [factorization_residueCarryWeight n k p hp]
    by_cases hpd : p ∣ d
    · have hpn : p ∣ n :=
        dvd_trans hpd hdn
      have hmem : p ∈ n.primeFactors ↔ p ∣ n :=
        by simp [Nat.mem_primeFactors, hp, hn.ne']
      rw [if_pos (hmem.mpr hpn)]
      have hdnfac :=
        ((Nat.factorization_prime_le_iff_dvd hdne hn.ne').mpr hdn)
          p hp
      have hc := hcarry p hp hpd
      omega
    · have hz : d.factorization p = 0 :=
        Nat.factorization_eq_zero_of_not_dvd hpd
      rw [hz]
      exact Nat.zero_le _

theorem realized_iff_exists_dvd_residueCarryWeight
    (n d : ℕ) (hn : 0 < n) (hdn : d ∣ n) :
    Realized n d ↔
      ∃ m, 0 < m ∧ d * m ≤ n / 2 ∧
        d ∣ residueCarryWeight n (d * m) := by
  unfold Realized
  constructor
  · rintro ⟨m, hm, hbound, hcarry⟩
    refine ⟨m, hm, hbound, ?_⟩
    exact
      (dvd_residueCarryWeight_iff_carryInequalities
        n (d * m) d hn hdn).mpr hcarry
  · rintro ⟨m, hm, hbound, hdW⟩
    refine ⟨m, hm, hbound, ?_⟩
    exact
      (dvd_residueCarryWeight_iff_carryInequalities
        n (d * m) d hn hdn).mp hdW

theorem residueCarrySafe_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) :
    ResidueCarrySafe n ↔ BoundarySafe n := by
  change
    (∀ k, Admissible n k →
      residueCarryWeight n k ≤ Erdos700.P n) ↔
    (∀ d, Boundary n d → ¬ Realized n d)
  have hnpos : 0 < n := by omega
  have hPone : 1 < Erdos700.P n :=
    (largestPrime_prime n hn).one_lt
  constructor
  · intro hsafe d hd hreal
    obtain ⟨m, hm, hbound, hdW⟩ :=
      (realized_iff_exists_dvd_residueCarryWeight
        n d hnpos hd.1).mp hreal
    have hd_le_mul : d ≤ d * m :=
      Nat.le_mul_of_pos_right d hm
    have hk : Admissible n (d * m) :=
      ⟨(hPone.trans hd.2.1).trans_le hd_le_mul, hbound⟩
    have hdleW :
        d ≤ residueCarryWeight n (d * m) :=
      Nat.le_of_dvd (residueCarryWeight_pos n (d * m)) hdW
    have hWleP := hsafe (d * m) hk
    exact (not_lt_of_ge (hdleW.trans hWleP)) hd.2.1
  · intro hboundary k hk
    by_contra hle
    have hPW :
        Erdos700.P n < residueCarryWeight n k :=
      Nat.lt_of_not_ge hle
    obtain ⟨d, hd, hdW⟩ :=
      (lt_residueCarryWeight_iff_exists_boundary
        n k hnpos hk).mp hPW
    have hWk : residueCarryWeight n k ∣ k :=
      residueCarryWeight_dvd_of_admissible n k hnpos hk
    have hdk : d ∣ k :=
      dvd_trans hdW hWk
    obtain ⟨m, hkm⟩ := hdk
    have hm : 0 < m := by
      apply Nat.pos_of_ne_zero
      intro hm0
      have hk0 : k = 0 := by
        simpa [hm0] using hkm
      exact (Nat.ne_of_gt (Nat.zero_lt_of_lt hk.1)) hk0
    have hbound : d * m ≤ n / 2 := by
      rw [← hkm]
      exact hk.2
    have hdW' :
        d ∣ residueCarryWeight n (d * m) := by
      rw [← hkm]
      exact hdW
    have hreal : Realized n d :=
      (realized_iff_exists_dvd_residueCarryWeight
        n d hnpos hd.1).mpr
        ⟨m, hm, hbound, hdW'⟩
    exact hboundary d hd hreal

theorem f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n := by
  exact
    (f_eq_div_iff_residueCarrySafe_complete n hn hnprime).trans
      (residueCarrySafe_iff_boundarySafe n hn)

end Erdos700PartI

#print axioms Erdos700PartI.residueCarryWeight_dvd_of_admissible
#print axioms Erdos700PartI.minimalOverweightDivisor_iff_boundary
#print axioms Erdos700PartI.lt_residueCarryWeight_iff_exists_boundary
#print axioms Erdos700PartI.dvd_residueCarryWeight_iff_carryInequalities
#print axioms Erdos700PartI.realized_iff_exists_dvd_residueCarryWeight
#print axioms Erdos700PartI.residueCarrySafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_boundarySafe
