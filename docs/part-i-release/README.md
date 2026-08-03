# Part (i) release record

This directory promotes the compact, claim-bearing artifacts recovered from
`dev-georgios` runs `math-1784859934-190817` and
`math-1784861746-211574`. Those campaigns closed both the
maintained largest-prime formulation and the literal 1978 greatest-prime-power
formulation of Erdős 700(i). Its final frozen candidate was v8,
`3f603b2a8b609dc7adb5cad0e8acaa6b1e889c37525d8051e503afc04803ba87`.

The corresponding Lean modules are no longer remote-only. They are imported
by [`proof/PartIWork.lean`](../../proof/PartIWork.lean), exposed by
[`proof/PartIVerify.lean`](../../proof/PartIVerify.lean), and checked by
[`proof/scripts/verify-part-i.sh`](../../proof/scripts/verify-part-i.sh).

## Exact results

| Form | Public theorem | Meaning |
| --- | --- | --- |
| Maintained largest prime | `Erdos700PartI.f_eq_div_iff_boundarySafe` | Exact boundary-antichain iff for every composite `n > 1` |
| Any proper prime-power divisor | `Erdos700PartI.f_eq_div_primePow_iff_boundarySafeAt` | Parameterized exact threshold theorem |
| Original 1978 greatest prime power | `Erdos700PartI.erdos_700_i_historical` | Exact historical iff, including the necessary non-prime-power exception |
| Historical order duality | `Erdos700PartI.erdos_700_i_historical_orderDual` | Independent proof through strict reversal between gcd and carry weight |
| Historical finite extremum | `Erdos700PartI.erdos_700_i_historical_extremal` | Independent proof through the exact maximum admissible carry weight |
| Full digit shadow | `Erdos700PartI.f_eq_div_iff_fullShadowSafe` | Finite common-residue digit formulation |
| Bounded obstruction | `Erdos700PartI.f_eq_div_iff_boundedObstructionSafe` | Restricts boundary divisors to `P(n) < d ≤ P(n)^2` |
| Cofactor normalized | `Erdos700PartI.f_eq_div_iff_cofactorObstructionSafe` | Uses the exact multiplier range `1 ≤ m ≤ (n/d)/2` |
| Divisor poset | `Erdos700PartI.f_eq_div_iff_divisorPosetSafe` | Post-freeze finite criterion directly over `n.divisors` |
| Integer/Boolean compiler | `Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible` | Compiles the semantic tableau into selector, prefix, digit, borrow, and budget rows |

These constitute a complete solution of Part (i) in the exact finite
characterization sense requested by the problem. A shorter enumeration of
factorization families would be an optional strengthening, not an unproved
part of the stated theorem.

## Reading order

1. [`complete-prose-proof.md`](complete-prose-proof.md) gives the complete
   boundary-antichain proof.
2. [`historical-characterization-report.md`](historical-characterization-report.md)
   separates the 1978 greatest-prime-power statement from the maintained
   largest-prime statement.
3. [`prime-power-threshold-prose-proof.md`](prime-power-threshold-prose-proof.md)
   proves the common generalization.
4. [`historical-order-duality-proof.md`](historical-order-duality-proof.md)
   and [`historical-extremal-proof.md`](historical-extremal-proof.md) give
   two independent historical proof architectures.
5. [`structural-upgrade.md`](structural-upgrade.md) explains the digit-shadow
   and bounded-obstruction progression.
6. The full-shadow, canonical, cofactor, and divisor-poset proof/audit pairs
   document each increasingly explicit equivalent predicate.

## Independent evidence

- [`mathematical-referee-report.md`](mathematical-referee-report.md)
- [`statement-alignment-audit.md`](statement-alignment-audit.md)
- [`formal-dependency-reproducibility-report.md`](formal-dependency-reproducibility-report.md)
- [`verification.md`](verification.md)
- [`regression-certificates.md`](regression-certificates.md) and the
  [machine-readable certificate](regression-certificates.json)
- [`release-audit-summary.md`](release-audit-summary.md)
- [`source-audit.md`](source-audit.md)
- [`novelty-audit.md`](novelty-audit.md)
- [`historical-dedicated-verification.md`](historical-dedicated-verification.md)
- [`historical-novelty-audit.md`](historical-novelty-audit.md)
- [`historical-campaign-report.md`](historical-campaign-report.md)

The clean novelty audit found no prior source stating or immediately implying
the exact all-composite characterization. It classified the candidates as
`known-method-new-application`: established Kummer/Lucas tools combined in a
new exact finite criterion. Absence of a search hit is not proof of priority.

## Campaign-versus-proof status

The campaign host never accepted a frozen candidate because its pre-approved
target selector did not recognize Erdős 700(i); it exited before invoking
Lean. That is an orchestration failure, not a mathematical or kernel failure.
The release archive was independently rebuilt successfully, and the promoted
repository now runs the authoritative Lean gate directly.

For a disposition of every Part (i) run, including the compiler repair
sequence, see the [persisted-run coverage audit](../part-i-run-coverage-audit.md).

Raw event streams, session snapshots, downloaded papers, build caches, the
release tarball, and duplicated standalone monoliths remain on
`dev-georgios`. They are not needed to reproduce the promoted proof and are
not canonical repository inputs.
