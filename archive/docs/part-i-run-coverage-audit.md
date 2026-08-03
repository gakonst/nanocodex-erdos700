# Part (i) persisted-run coverage audit

Date: 2026-08-03

This is the forensic companion to the Part (i) section of the
[research map](research-map.md). It records every persisted Part (i) campaign
directory recovered from `dev-georgios`, what it contributed, and where the
durable result now lives. It is not a substitute for the mathematical release
record.

## Audit verdict

The recovered corpus contains **15 Part (i) run directories**, plus one
Part (ii) release-prompt directory interleaved with them. The sequence does
contain complete solutions of both formulations of Part (i):

- the maintained largest-prime statement;
- the literal 1978 greatest-exact-prime-power statement, with the necessary
  composite-prime-power exception.

It also contains a complete explicit integer/Boolean compiler for the finite
criterion. The recurring campaign label `strong-candidate` was caused by a
host target registry that did not recognize the immutable Part (i) task and
exited before Lean. It was not evidence of a mathematical or kernel failure.
The promoted modules are now checked by the repository's direct canonical
verifier.

## Chronological run map

| Run | Route and terminal disposition | Durable result |
| --- | --- | --- |
| `math-1784840756-35224` | Initial equality-case exploration was interrupted before a lead report. It retained the decisive exact obstruction `n=78, k=39`, where `f(78)=2<n/P(78)=6`. | Mandatory regression case in the release audits and certificate. It killed factorization-only guesses that missed simultaneous prime omission. |
| `math-1784843263-47597` | Broad equality characterization. Derived the exact carry weight, proved it divides the row index, and reduced overweight rows to a finite antichain of divisibility-minimal dangerous divisors. | The core modern theorem `f_eq_div_iff_boundarySafe`; prose proof in the [release record](part-i-release/README.md). |
| `math-1784850943-109101` | Dedicated boundary-antichain formalization and adversarial pass, including positivity, endpoint, repeated-power, and common-multiplier checks. | `proof/PartIWork/BoundaryAntichain.lean` and the maintained Part (i) verifier. |
| `math-1784853673-138164` | Part (ii) release-audit prompt only; no returned mathematical artifact. | Outside Part (i); recorded here only to account for every interleaved run. |
| `math-1784859934-190817` | Full publication/release campaign. Proved the parameterized prime-power threshold and the literal 1978 theorem; added full-shadow, bounded-obstruction, cofactor, and divisor-poset forms; completed audits and regressions. | The [Part (i) release record](part-i-release/README.md), promoted Lean modules, prose proofs, reports, novelty audit, and machine-readable regression certificate. |
| `math-1784861746-211574` | Dedicated historical campaign. Independently proved the historical theorem by strict gcd/carry-weight order duality and by the finite extremum `M(n)=Q(n)`. | `HistoricalOrderDuality.lean`, `HistoricalExtremal.lean`, and the dedicated historical proof/audit records in the release directory. |
| `math-1784917925-3501879` | Structural-classification campaign. Recast one common row as synchronized accepting digit words and compiled realizability to a compact finite natural-linear system. | Semantic factor tableau and the architecture later compiled by `ExplicitG`. It showed why support-only, `m=1`, independent-prime, and fixed-small-multiplier criteria are insufficient. |
| `math-1784923227-3523152` | First explicit borrow-tableau closure. Proved local borrow semantics and several projection obligations, but honestly stopped at the global projection theorem. | Exact decomposition of the remaining compiler bridge; no incomplete theorem is promoted as final. |
| `math-1784925707-3532247` | First complete global projection proof. Constructed selector, prefix, digit, borrow, boundary, and budget assignments in both directions. | `Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible`. |
| `math-1784928184-3622565` | Independent project-native projection rebuild and statement-alignment audit. | Corroborated the same `ExplicitG` theorem and diagnosed the host failure as pre-Lean target dispatch. |
| `math-1784930103-3681859` | Recovery/repair pass over the strongest interrupted compiler architecture. | Reconfirmed the complete projection theorem with frozen-source and endpoint audits. |
| `math-1784930588-3685475` | Refinement-tree reset split the monolithic compiler into ten staged modules: raw system, factorization, selectors, prefixes, digits, borrow, boundary/budget, bridge, and final theorem. | Clean staged rebuild and the maintainable decomposition now represented under `proof/PartIWork/`. |
| `math-1784934017-3704661` | Repaired the dependent finite-index proof equating assignment borrow sums with residue carry counts. | Exact local lemma incorporated into the checked compiler. |
| `math-1784934017-3704662` | Proved canonical selector/prefix rows, including active equalities and inactive big-M bounds. | Canonical assignment prefix component incorporated into `ExplicitG`. |
| `math-1784934017-3704663` | Proved the selected-product prime-divisor bridge and boundary/deletion equivalence, including zero-exponent and empty-factorization edge cases. | Boundary projection component incorporated into `ExplicitG`. |
| `math-1784934017-3704664` | Proved finite canonical digit and borrow fields and the exact budget-left-hand-side identity. | Digit/borrow component incorporated into `ExplicitG`. |

## What was promoted

- Complete, imported Lean modules for every final mathematical form.
- Direct checks and axiom output for the public theorems.
- Complete prose proofs, statement/referee/reproducibility audits, novelty
  searches, verification records, and compact regression certificates.
- The explicit factor-tableau compiler and its staged local bridge theorems.
- The exact chronology and failure lessons above.

## What remains remote-only

Raw event and trace streams, agent session snapshots, downloaded duplicate
papers, frozen duplicate source bundles, `.olean` files, build caches, and
release archives remain on the host. They are large provenance/debugging
artifacts, not independent mathematical results. Their claim-bearing terminal
reports and unique checked source have been promoted.

## Lessons from the failed and superseded routes

1. Largest prime `P(n)` and greatest exact prime-power component `Q(n)`
   are distinct targets; `n=12` exposes the difference.
2. Composite prime powers require an explicit exception in the historical
   theorem because `Q(n)=n` while `f(n)>1`.
3. Primewise witnesses cannot be combined independently. A valid obstruction
   needs one literal common row, equivalently one common multiplier.
4. Testing only `m=1`, a fixed small multiplier menu, support patterns, or
   pairwise compatibility misses real cases; `n=136` and `n=195` are
   retained regressions.
5. The semantic boundary criterion is already an exact characterization.
   The tableau/compiler is a more explicit finite certificate, not a repair
   for a missing solution.
6. Host acceptance labels and proof validity are separate. A selector failure
   before theorem elaboration cannot demote a successful canonical Lean check.
