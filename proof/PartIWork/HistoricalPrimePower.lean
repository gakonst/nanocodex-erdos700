import PartIWork.PrimePowerThreshold

/-!
# Original 1978 greatest-prime-power formulation of Erdős 700(i)

The historical paper uses the greatest exact prime-power component, not the
largest prime divisor used by the maintained problem statement. This module
specializes the checked parameterized boundary theorem to that component and
handles composite prime powers explicitly.
-/

namespace Erdos700

noncomputable def Q (n : ℕ) : ℕ :=
  n.primeFactors.sup (fun p => p ^ n.factorization p)



abbrev HistoricalBoundary (n d : ℕ) : Prop :=
  Erdos700PartI.BoundaryAt n (Q n) d


abbrev HistoricalRealized (n d : ℕ) : Prop :=
  Erdos700PartI.Realized n d


abbrev HistoricalBoundarySafe (n : ℕ) : Prop :=
  Erdos700PartI.BoundarySafeAt n (Q n)

end Erdos700

namespace Erdos700PartI

theorem Q_component_le
    (n p : ℕ) (hmem : p ∈ n.primeFactors) :
    p ^ n.factorization p ≤ Erdos700.Q n := by
  rw [Erdos700.Q]
  exact Finset.le_sup
    (s := n.primeFactors)
    (f := fun q => q ^ n.factorization q) hmem

theorem Q_attained (n : ℕ) (hn : 1 < n) :
    ∃ p, p ∈ n.primeFactors ∧
      Erdos700.Q n = p ^ n.factorization p := by
  rw [Erdos700.Q]
  obtain ⟨p, hp, hsup⟩ :=
    Finset.exists_mem_eq_sup n.primeFactors
      (Nat.nonempty_primeFactors.2 hn)
      (fun p => p ^ n.factorization p)
  exact ⟨p, hp, hsup⟩

theorem Q_attained_exact (n : ℕ) (hn : 1 < n) :
    ∃ p, p ∈ n.primeFactors ∧ p.Prime ∧
      0 < n.factorization p ∧
      Erdos700.Q n = p ^ n.factorization p ∧
      ¬ p ∣ n / Erdos700.Q n := by
  obtain ⟨p, hmem, hQ⟩ := Q_attained n hn
  have hp : p.Prime := Nat.prime_of_mem_primeFactors hmem
  have hpdvd : p ∣ n := (Nat.mem_primeFactors.1 hmem).2.1
  have ha : 0 < n.factorization p :=
    hp.factorization_pos_of_dvd (by omega : n ≠ 0) hpdvd
  refine ⟨p, hmem, hp, ha, hQ, ?_⟩
  simpa [hQ] using
    (Nat.not_dvd_ordCompl hp (by omega : n ≠ 0))

theorem Q_pos_dvd (n : ℕ) (hn : 1 < n) :
    0 < Erdos700.Q n ∧ Erdos700.Q n ∣ n := by
  obtain ⟨p, hmem, hQ⟩ := Q_attained n hn
  have hp := Nat.prime_of_mem_primeFactors hmem
  rw [hQ]
  exact ⟨pow_pos hp.pos _, Nat.ordProj_dvd n p⟩

theorem one_lt_Q (n : ℕ) (hn : 1 < n) :
    1 < Erdos700.Q n := by
  obtain ⟨p, hmem, hQ⟩ := Q_attained n hn
  have hp := Nat.prime_of_mem_primeFactors hmem
  have hpdvd : p ∣ n := (Nat.mem_primeFactors.1 hmem).2.1
  have ha : 0 < n.factorization p :=
    hp.factorization_pos_of_dvd (by omega : n ≠ 0) hpdvd
  rw [hQ]
  exact hp.one_lt.trans_le
    (Nat.le_of_dvd (pow_pos hp.pos _)
      (dvd_pow_self p ha.ne'))

theorem Q_eq_self_iff_isPrimePow (n : ℕ) (hn : 1 < n) :
    Erdos700.Q n = n ↔ IsPrimePow n := by
  constructor
  · intro hQn
    obtain ⟨p, hmem, hQ⟩ := Q_attained n hn
    have hp := Nat.prime_of_mem_primeFactors hmem
    have hpdvd : p ∣ n := (Nat.mem_primeFactors.1 hmem).2.1
    have ha : 0 < n.factorization p :=
      hp.factorization_pos_of_dvd (by omega : n ≠ 0) hpdvd
    exact (isPrimePow_nat_iff n).2
      ⟨p, n.factorization p, hp, ha, hQ.symm.trans hQn⟩
  · intro hpp
    obtain ⟨p, a, hp, ha, rfl⟩ :=
      (isPrimePow_nat_iff n).1 hpp
    simp [Erdos700.Q,
      Nat.primeFactors_prime_pow ha.ne' hp,
      Nat.factorization_pow,
      Nat.Prime.factorization hp]

theorem Q_admissible
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    Admissible n (Erdos700.Q n) := by
  have hQdvd := (Q_pos_dvd n hn).2
  obtain ⟨c, hc⟩ := hQdvd
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hcne : c ≠ 1 := by
    intro hc1
    apply hnpp
    apply (Q_eq_self_iff_isPrimePow n hn).1
    simpa [hc1] using hc.symm
  have hc2 : 2 ≤ c := by omega
  have htwo : 2 * Erdos700.Q n ≤ n := by
    calc
      2 * Erdos700.Q n ≤ c * Erdos700.Q n :=
        Nat.mul_le_mul_right _ hc2
      _ = n := by simpa [Nat.mul_comm] using hc.symm
  exact ⟨one_lt_Q n hn, by omega⟩

private theorem choose_pred_primePow_modEq_one
    (p c a : ℕ) (hp : p.Prime) (hc : 0 < c) :
    (c * p ^ a - 1).choose (p ^ a - 1) ≡ 1 [MOD p] := by
  induction a with
  | zero =>
      simpa using (Nat.ModEq.refl 1 : 1 ≡ 1 [MOD p])
  | succ a ih =>
      have hpred : p - 1 < p := Nat.pred_lt hp.pos.ne'
      have hpa : 0 < p ^ a := pow_pos hp.pos _
      have hcpa : 0 < c * p ^ a := Nat.mul_pos hc hpa
      have pred_mul (x : ℕ) (hx : 0 < x) :
          p * x - 1 = (p - 1) + p * (x - 1) := by
        rw [Nat.mul_sub_left_distrib]
        simp only [Nat.mul_one]
        have hle : p ≤ p * x :=
          Nat.le_mul_of_pos_right p hx
        omega
      have hN :
          c * p ^ (a + 1) - 1 =
            (p - 1) + p * (c * p ^ a - 1) := by
        have hmul :
            c * p ^ (a + 1) = p * (c * p ^ a) := by
          rw [pow_succ]
          ac_rfl
        rw [hmul]
        exact pred_mul _ hcpa
      have hK :
          p ^ (a + 1) - 1 =
            (p - 1) + p * (p ^ a - 1) := by
        have hmul : p ^ (a + 1) = p * p ^ a := by
          rw [pow_succ]
          ac_rfl
        rw [hmul]
        exact pred_mul _ hpa
      letI : Fact p.Prime := ⟨hp⟩
      have hLucas :=
        Choose.choose_modEq_choose_mod_mul_choose_div_nat
          (p := p)
          (n := c * p ^ (a + 1) - 1)
          (k := p ^ (a + 1) - 1)
      have hstep :
          (c * p ^ (a + 1) - 1).choose
              (p ^ (a + 1) - 1) ≡
            (c * p ^ a - 1).choose (p ^ a - 1) [MOD p] := by
        simpa [hN, hK, Nat.add_mul_mod_self_left,
          Nat.add_mul_div_left _ _ hp.pos,
          Nat.mod_eq_of_lt hpred,
          Nat.div_eq_of_lt hpred] using hLucas
      exact hstep.trans ih

private theorem primePow_coprime_choose_pred
    (p c a : ℕ) (hp : p.Prime) (hc : 0 < c) :
    (p ^ a).Coprime
      ((c * p ^ a - 1).choose (p ^ a - 1)) := by
  have hmod := choose_pred_primePow_modEq_one p c a hp hc
  have hpcop :
      p.Coprime ((c * p ^ a - 1).choose (p ^ a - 1)) :=
    (Nat.coprime_of_mul_modEq_one 1
      (by simpa using hmod)).symm
  exact hpcop.pow_left a

private theorem gcd_choose_primePow_mul
    (p c a : ℕ) (hp : p.Prime) (hc : 0 < c) :
    Nat.gcd (c * p ^ a)
        ((c * p ^ a).choose (p ^ a)) = c := by
  have hq0 : p ^ a ≠ 0 := pow_ne_zero _ hp.ne_zero
  have hchoose :
      (c * p ^ a).choose (p ^ a) =
        c * ((c * p ^ a - 1).choose (p ^ a - 1)) :=
    Nat.choose_mul_right hq0
  have hcop :=
    primePow_coprime_choose_pred p c a hp hc
  calc
    Nat.gcd (c * p ^ a)
        ((c * p ^ a).choose (p ^ a)) =
      Nat.gcd (c * p ^ a)
        (c * ((c * p ^ a - 1).choose (p ^ a - 1))) := by
          rw [hchoose]
    _ = c * Nat.gcd (p ^ a)
        ((c * p ^ a - 1).choose (p ^ a - 1)) := by
          rw [Nat.gcd_mul_left]
    _ = c := by rw [hcop.gcd_eq_one, Nat.mul_one]

private theorem gcd_choose_primePow_of_dvd
    (n p a : ℕ) (hn : 0 < n) (hp : p.Prime)
    (hdiv : p ^ a ∣ n) :
    Nat.gcd n (n.choose (p ^ a)) = n / p ^ a := by
  obtain ⟨c, hc⟩ := hdiv
  have hcpos : 0 < c := by
    by_contra hcz
    have : c = 0 := by omega
    rw [this, mul_zero] at hc
    omega
  have hn_mul : n = c * p ^ a := by
    simpa [Nat.mul_comm] using hc
  calc
    Nat.gcd n (n.choose (p ^ a)) =
        Nat.gcd (c * p ^ a)
          ((c * p ^ a).choose (p ^ a)) := by
      rw [hn_mul]
    _ = c := gcd_choose_primePow_mul p c a hp hcpos
    _ = n / p ^ a := by simp [hc, hp.ne_zero]

theorem Q_gcd_choose (n : ℕ) (hn : 1 < n) :
    Nat.gcd n (n.choose (Erdos700.Q n)) =
      n / Erdos700.Q n := by
  obtain ⟨p, hmem, hQ⟩ := Q_attained n hn
  have hp := Nat.prime_of_mem_primeFactors hmem
  have hdiv :
      p ^ n.factorization p ∣ n :=
    Nat.ordProj_dvd n p
  rw [hQ]
  exact gcd_choose_primePow_of_dvd
    n p (n.factorization p) (by omega) hp hdiv

theorem Q_quotient_dvd_choose (n : ℕ) (hn : 1 < n) :
    n / Erdos700.Q n ∣ n.choose (Erdos700.Q n) := by
  rw [← Q_gcd_choose n hn]
  exact Nat.gcd_dvd_right _ _

theorem Q_attaining_prime_not_dvd_choose
    (n : ℕ) (hn : 1 < n) :
    ∃ p, p ∈ n.primeFactors ∧
      Erdos700.Q n = p ^ n.factorization p ∧
      ¬ p ∣ n / Erdos700.Q n ∧
      ¬ p ∣ n.choose (Erdos700.Q n) := by
  obtain ⟨p, hmem, hp, ha, hQ, hpc⟩ :=
    Q_attained_exact n hn
  refine ⟨p, hmem, hQ, hpc, ?_⟩
  intro hpchoose
  apply hpc
  rw [← Q_gcd_choose n hn]
  exact Nat.dvd_gcd
    ((Nat.mem_primeFactors.1 hmem).2.1) hpchoose

theorem Q_weight_witness
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    residueCarryWeight n (Erdos700.Q n) =
      Erdos700.Q n := by
  have hnpos : 0 < n := by omega
  have hadmissible := Q_admissible n hn hnpp
  have hexact :=
    (residueCarryWeight_exact n (Erdos700.Q n)
      hnpos hadmissible).2
  rw [Q_gcd_choose n hn] at hexact
  have hQdvd := (Q_pos_dvd n hn).2
  have hcanonical :
      n / Erdos700.Q n * Erdos700.Q n = n :=
    Nat.div_mul_cancel hQdvd
  have hquotpos : 0 < n / Erdos700.Q n :=
    Nat.div_pos
      (Nat.le_of_dvd hnpos hQdvd)
      (Q_pos_dvd n hn).1
  exact Nat.mul_left_cancel hquotpos
    (hexact.trans hcanonical.symm)

theorem Q_primePow
    (p a : ℕ) (hp : p.Prime) (ha : 0 < a) :
    Erdos700.Q (p ^ a) = p ^ a := by
  have hpa : 0 < p ^ a := pow_pos hp.pos a
  have hp_le : p ≤ p ^ a :=
    Nat.le_of_dvd hpa (dvd_pow_self p ha.ne')
  have hn : 1 < p ^ a := hp.one_lt.trans_le hp_le
  exact (Q_eq_self_iff_isPrimePow (p ^ a) hn).2
    ((isPrimePow_nat_iff (p ^ a)).2
      ⟨p, a, hp, ha, rfl⟩)

theorem f_ne_div_Q_primePow
    (p a : ℕ) (hp : p.Prime) (ha : 2 ≤ a) :
    Erdos700.f (p ^ a) ≠
      (p ^ a) / Erdos700.Q (p ^ a) := by
  have hQ := Q_primePow p a hp (by omega)
  rw [Erdos700.erdos_700.variants.prime_pow p a hp ha,
      hQ, Nat.div_self (pow_pos hp.pos a)]
  exact hp.ne_one

theorem f_ne_div_Q_of_isPrimePow
    (n : ℕ) (hcomp : ¬ n.Prime) (hpp : IsPrimePow n) :
    Erdos700.f n ≠ n / Erdos700.Q n := by
  obtain ⟨p, a, hp, ha, rfl⟩ :=
    (isPrimePow_nat_iff n).1 hpp
  have ha2 : 2 ≤ a := by
    by_contra h
    have ha1 : a = 1 := by omega
    subst a
    apply hcomp
    simpa using hp
  exact f_ne_div_Q_primePow p a hp ha2

theorem f_eq_div_Q_iff_historicalBoundarySafe
    (n : ℕ) (hn : 1 < n) (hnpp : ¬ IsPrimePow n) :
    Erdos700.f n = n / Erdos700.Q n ↔
      BoundarySafeAt n (Erdos700.Q n) := by
  exact f_eq_div_iff_boundarySafeAt
    n (Erdos700.Q n) (Erdos700.Q n)
    (by omega)
    (one_lt_Q n hn)
    (Q_pos_dvd n hn).2
    (Q_admissible n hn hnpp)
    (Q_weight_witness n hn hnpp)

theorem erdos_700_i_historical
    (n : ℕ) (hn : 1 < n) (hcomp : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.Q n ↔
      ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n := by
  constructor
  · intro hf
    have hnpp : ¬ IsPrimePow n := by
      intro hpp
      exact (f_ne_div_Q_of_isPrimePow n hcomp hpp) hf
    exact ⟨hnpp,
      (f_eq_div_Q_iff_historicalBoundarySafe n hn hnpp).mp hf⟩
  · rintro ⟨hnpp, hsafe⟩
    exact
      (f_eq_div_Q_iff_historicalBoundarySafe n hn hnpp).mpr hsafe

end Erdos700PartI

#print axioms Erdos700PartI.erdos_700_i_historical
