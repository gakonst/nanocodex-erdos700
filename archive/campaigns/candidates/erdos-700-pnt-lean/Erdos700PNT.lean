import Assembly
import CoreHelpers
import DominanceWork.Dominance
import FEquality
import PackingWork.AsymmetricGap
import PackingWork.PrimeBoxes
import PNTWork.PrimeInterval
import Reduction
import StructuralWork.PROmission
import StructuralWork.QROmission
import StructuralWork.Structural
import Solution
import Target

/-!
# Erdős 700(ii): PNT route

This is the root module for the kernel-checked proof.  It imports only pinned
dependencies and the locally verified proof slices.  The final analytic
dominance, interval-packing, combinatorial-gap, and three omission lemmas are
added here as they clear compilation and axiom audit.
-/

#check Erdos700.f
#check Erdos700.prime_dvd_of_not_dvd_choose
#check pi_alt'
#check Erdos700PNT.eventually_primeCounting_eight_cube_interval
#check Erdos700PNT.eventually_packing_threshold_lt_prime_count
#check Erdos700PNT.PackingWork.exists_asymmetric_triple_with_last
#check Erdos700PNT.PackingWork.eventually_exists_asymmetric_prime_triple
#check Erdos700PNT.not_p_and_r_omitted
#check Erdos700PNT.not_q_and_r_omitted
#check Erdos700PNT.f_eq_pqr_of_gcd_lower
#check Erdos700PNT.erdos_700_ii
#check Erdos700PNT.prime_triple_f_square_gt_of_pairwise_not_omitted
#check Erdos700PNT.exact_erdos_700_ii_target_of_unbounded
#check Erdos700PNT.exact_erdos_700_ii_of_unbounded_prime_triples

#print axioms pi_alt'
#print axioms Erdos700PNT.eventually_primeCounting_eight_cube_interval
#print axioms Erdos700PNT.eventually_packing_threshold_lt_prime_count
#print axioms Erdos700PNT.PackingWork.exists_asymmetric_triple_with_last
#print axioms Erdos700PNT.PackingWork.eventually_exists_asymmetric_prime_triple
#print axioms Erdos700PNT.not_p_and_r_omitted
#print axioms Erdos700PNT.not_q_and_r_omitted
#print axioms Erdos700PNT.f_eq_pqr_of_gcd_lower
#print axioms Erdos700PNT.erdos_700_ii
#print axioms Erdos700PNT.prime_triple_f_square_gt_of_pairwise_not_omitted
#print axioms Erdos700PNT.exact_erdos_700_ii_target_of_unbounded
#print axioms Erdos700PNT.exact_erdos_700_ii_of_unbounded_prime_triples
