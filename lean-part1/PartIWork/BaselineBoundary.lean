import PartIWork.BoundaryAntichain

/-!
# Boundary characterization at an arbitrary witnessed baseline

This module separates the boundary-antichain argument from the modern
largest-prime baseline. It is intended for the historical greatest
prime-power formulation of Erdős 700(i).
-/

namespace Erdos700PartI

def BoundaryAt (n baseline d : ℕ) : Prop :=
  d ∣ n ∧
    baseline < d ∧
      ∀ p, p.Prime → p ∣ d → d / p ≤ baseline

def BoundarySafeAt (n baseline : ℕ) : Prop :=
  ∀ d, BoundaryAt n baseline d → ¬ Realized n d

def MinimalOverweightDivisorAt (n baseline d : ℕ) : Prop :=
  d ∣ n ∧
    baseline < d ∧
      ∀ e, e ∣ d → e < d → e ≤ baseline

theorem minimalOverweightDivisorAt_iff_boundaryAt
    (n baseline d : ℕ) :
    MinimalOverweightDivisorAt n baseline d ↔
      BoundaryAt n baseline d := by
  unfold MinimalOverweightDivisorAt BoundaryAt
  constructor
  · rintro ⟨hdn, hBd, hminimal⟩
    refine ⟨hdn, hBd, ?_⟩
    intro p hp hpd
    have hdpos : 0 < d := by omega
    apply hminimal (d / p)
    · exact ⟨p, (Nat.div_mul_cancel hpd).symm⟩
    · exact Nat.div_lt_self hdpos hp.one_lt
  · rintro ⟨hdn, hBd, hprime⟩
    refine ⟨hdn, hBd, ?_⟩
    intro e hed he_lt
    by_contra heB
    have hBe : baseline < e :=
      Nat.lt_of_not_ge heB
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

theorem lt_residueCarryWeight_iff_exists_boundaryAt
    (n baseline k : ℕ) (hn : 0 < n) (hk : Admissible n k) :
    baseline < residueCarryWeight n k ↔
      ∃ d, BoundaryAt n baseline d ∧
        d ∣ residueCarryWeight n k := by
  constructor
  · intro hBW
    have hWn :=
      residueCarryWeight_dvd_n_of_admissible n k hn hk
    let hex :
        ∃ e : ℕ,
          e ∣ residueCarryWeight n k ∧ baseline < e :=
      ⟨residueCarryWeight n k,
        ⟨⟨1, by simp⟩, hBW⟩⟩
    let d := Nat.find hex
    have hd :
        d ∣ residueCarryWeight n k ∧ baseline < d := by
      exact Nat.find_spec hex
    have hminimal : MinimalOverweightDivisorAt n baseline d := by
      unfold MinimalOverweightDivisorAt
      refine ⟨dvd_trans hd.1 hWn, hd.2, ?_⟩
      intro e hed he_lt
      by_contra heB
      have hBe : baseline < e :=
        Nat.lt_of_not_ge heB
      have heW : e ∣ residueCarryWeight n k :=
        dvd_trans hed hd.1
      have hde : d ≤ e :=
        Nat.find_min' hex ⟨heW, hBe⟩
      omega
    exact
      ⟨d,
        (minimalOverweightDivisorAt_iff_boundaryAt
          n baseline d).mp hminimal,
        hd.1⟩
  · rintro ⟨d, hd, hdW⟩
    have hdle :
        d ≤ residueCarryWeight n k :=
      Nat.le_of_dvd (residueCarryWeight_pos n k) hdW
    exact hd.2.1.trans_le hdle

theorem carrySafe_iff_boundarySafeAt
    (n baseline : ℕ) (hn : 0 < n) (hbaseline : 1 < baseline) :
    CarrySafe n baseline (residueCarryWeight n) ↔
      BoundarySafeAt n baseline := by
  change
    (∀ k, Admissible n k →
      residueCarryWeight n k ≤ baseline) ↔
    (∀ d, BoundaryAt n baseline d → ¬ Realized n d)
  constructor
  · intro hsafe d hd hreal
    obtain ⟨m, hm, hbound, hdW⟩ :=
      (realized_iff_exists_dvd_residueCarryWeight
        n d hn hd.1).mp hreal
    have hd_le_mul : d ≤ d * m :=
      Nat.le_mul_of_pos_right d hm
    have hk : Admissible n (d * m) :=
      ⟨(hbaseline.trans hd.2.1).trans_le hd_le_mul, hbound⟩
    have hdleW :
        d ≤ residueCarryWeight n (d * m) :=
      Nat.le_of_dvd (residueCarryWeight_pos n (d * m)) hdW
    have hWleB := hsafe (d * m) hk
    exact (not_lt_of_ge (hdleW.trans hWleB)) hd.2.1
  · intro hboundary k hk
    by_contra hle
    have hBW :
        baseline < residueCarryWeight n k :=
      Nat.lt_of_not_ge hle
    obtain ⟨d, hd, hdW⟩ :=
      (lt_residueCarryWeight_iff_exists_boundaryAt
        n baseline k hn hk).mp hBW
    have hWk : residueCarryWeight n k ∣ k :=
      residueCarryWeight_dvd_of_admissible n k hn hk
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
        n d hn hd.1).mpr
        ⟨m, hm, hbound, hdW'⟩
    exact hboundary d hd hreal

theorem f_eq_div_iff_boundarySafeAt
    (n baseline witness : ℕ)
    (hn : 0 < n)
    (hbaseline : 1 < baseline)
    (hbaseline_dvd : baseline ∣ n)
    (hwitness : Admissible n witness)
    (hwitnessWeight : residueCarryWeight n witness = baseline) :
    Erdos700.f n = n / baseline ↔
      BoundarySafeAt n baseline := by
  exact
    (f_eq_div_iff_carrySafe n baseline witness
      (residueCarryWeight n) hn (by omega) hbaseline_dvd
      (exactCarryWeight_residueCarryWeight n hn)
      hwitness hwitnessWeight).trans
      (carrySafe_iff_boundarySafeAt n baseline hn hbaseline)

end Erdos700PartI

#print axioms Erdos700PartI.minimalOverweightDivisorAt_iff_boundaryAt
#print axioms Erdos700PartI.lt_residueCarryWeight_iff_exists_boundaryAt
#print axioms Erdos700PartI.carrySafe_iff_boundarySafeAt
#print axioms Erdos700PartI.f_eq_div_iff_boundarySafeAt
