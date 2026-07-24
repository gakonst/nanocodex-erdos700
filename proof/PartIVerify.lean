import PartIWork

/-!
This is the public verification surface for the Part (i) boundary-antichain
characterization. It checks the exact theorem and prints the transitive
dependencies of every load-bearing bridge promoted by the characterization.
-/

#check Erdos700PartI.f_eq_div_iff_boundarySafe

#print axioms Erdos700PartI.residueCarryWeight_dvd_of_admissible
#print axioms Erdos700PartI.minimalOverweightDivisor_iff_boundary
#print axioms Erdos700PartI.lt_residueCarryWeight_iff_exists_boundary
#print axioms Erdos700PartI.dvd_residueCarryWeight_iff_carryInequalities
#print axioms Erdos700PartI.realized_iff_exists_dvd_residueCarryWeight
#print axioms Erdos700PartI.residueCarrySafe_iff_boundarySafe
#print axioms Erdos700PartI.f_eq_div_iff_boundarySafe
