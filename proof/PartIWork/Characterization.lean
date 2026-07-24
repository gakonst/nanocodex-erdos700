import PartIWork.ExactWeight

/-!
# Residue-carry characterization, reduced to the largest-prime witness
-/

namespace Erdos700PartI

/--
The complete Kummer/product bridge: only the elementary largest-prime witness
facts remain as hypotheses.
-/
theorem f_eq_div_iff_residueCarrySafe_of_witness
    (n witness : ℕ)
    (hn : 0 < n)
    (hP : 0 < Erdos700.P n)
    (hPdvd : Erdos700.P n ∣ n)
    (hwitness : Admissible n witness)
    (hwitnessWeight : residueCarryWeight n witness = Erdos700.P n) :
    Erdos700.f n = n / Erdos700.P n ↔ ResidueCarrySafe n := by
  exact f_eq_div_iff_residueCarrySafe n witness hn hP hPdvd
    (exactCarryWeight_residueCarryWeight n hn) hwitness hwitnessWeight

end Erdos700PartI

#print axioms Erdos700PartI.f_eq_div_iff_residueCarrySafe_of_witness
