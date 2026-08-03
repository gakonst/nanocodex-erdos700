# Erdős 700 research map

This is the narrative index of what we tried on all three parts of Erdős 700,
what survived, and what each stage taught us. It sits between the short
[repository status](../archive/docs/status.md) and the much larger retained campaign record.

The scope is deliberately auditable: this map covers the tracked proof
developments, every frozen Erdős 700 campaign prompt in
[`archive/campaigns/problems/`](../archive/campaigns/problems/), the promoted candidate
artifacts, the complete recovered Part (i) release campaign, and the persisted
Part (iii) runs and sessions audited through 28 July 2026, including the late
`dev-georgios` reconciliation. It does not claim to recover unrecorded
thoughts. A prompt is
evidence that a route was assigned, not evidence that its target was proved.

## One-screen overview

| Part | Where we ended | Main progression | Best next action |
| --- | --- | --- | --- |
| (i) | Solved: kernel-checked compact structural characterizations of both the maintained and original 1978 targets | residue/carry bridge → boundary antichain → prime-power transfer → synchronized factor tableau → explicit integer/Boolean compiler | independent novelty, priority, and publication review |
| (ii) | Kernel-checked unconditional infinite family; no novelty claim | nearby-prime structural lemma → Maynard candidate → PNT replacement → complete Lean proof | independent mathematical review and comparison with prior or independent resolutions |
| (iii) | Open beyond the classical \(A=1\) scale | exact weighted reduction → hard residual packets → many construction, averaging, algebraic, and counterexample routes → quantitative no-retry ledger | prove any unbounded gain over \(D(n)\gg\log n\), prove \(A=2\), or build a genuine counterfamily |

The canonical proof artifacts are in [`lean-part1/`](../lean-part1/) and
[`lean-part2/`](../lean-part2/). The full frozen prompt inventory is in the
[campaign index](../archive/campaigns/problems/README.md).

## Part (i): complete equality-case solution

### Result

For every composite \(n>1\), the checked development proves

```lean
Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

and then proves that failure of `BoundarySafe` is equivalent to satisfiability
of a compact integer/Boolean system `G(F,P(n))`. The system synchronizes one
selected divisor and one shared multiplier across explicit base-prime digit
and borrow rows. It contains no occurrence of `f`, gcd, or a binomial
coefficient and no coordinate for each possible multiplier. Thus the final
headline form is

\[
f(n)=\frac{n}{P(n)}
\quad\Longleftrightarrow\quad
\neg G(F,P(n)).
\]

Its sparse description is polynomial in the binary length of $n$; no
polynomial-time feasibility claim is made. This is an exact compact structural
characterization, not merely a bounded scan and not a short taxonomy of
factorization shapes.

The original 1978 paper uses the greatest exact prime-power component

\[
Q(n)=\max_{p\mid n}p^{v_p(n)}
\]

rather than the maintained page's largest prime factor. The formulations are
not equivalent (`n=12` separates them). The recovered release proves the
literal historical theorem

```lean
Erdos700.f n = n / Erdos700.Q n ↔
  ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n
```

for every composite `n > 1`. Thus both readings of Part (i) are closed.

### Route map

| Stage | What we tried | Disposition | What we learned / retained |
| --- | --- | --- | --- |
| Freeze the target | Separate the maintained largest-prime statement from the original greatest-prime-power formulation and forbid a predicate that merely recomputes `f` | Necessary statement control | The source formulations are genuinely different and require separate theorems. |
| Reuse Part (ii) machinery | Express gcd size through prime-power carry deficits and prove the largest-prime row gives the baseline value | Proved | The equality question is exactly the absence of an admissible row with overweight retained prime-power mass. |
| Boundary-antichain reduction | Replace all overweight divisors by divisibility-minimal boundary divisors and ask whether one common multiplier realizes all their carry inequalities | Proved and formalized | Minimal divisors are the right finite obstruction set; independent primewise witnesses are not enough. |
| Simplify the multiplier search | Test `m=1`, squarefree-only, divisor-only, endpoint-excluding, and independent-prime criteria | Refuted by explicit regressions | `n=78`, `136`, and `195` show that endpoint inclusion, nontrivial multipliers, repeated powers, and same-row coupling are load-bearing. |
| Prime-power threshold | Generalize the exact witness and boundary theorem from the largest prime to every proper prime-power divisor | Proved and formalized | One parameterized theorem supplies the bridge to the original 1978 baseline. |
| Historical prime-power pass | Define the greatest exact prime-power component, isolate composite prime powers, and specialize the threshold theorem | Proved, audited, and formalized | `n=12` separates the source formulations; both now have exact all-composite iff theorems. |
| Structural-classification pass | Replace the multiplier scan by synchronized accepting digit words and a compact natural-linear system | Proved and formalized | The shared multiplier survives as one symbolic variable; there is no row or disjunction for each possible value. A factorization-family taxonomy remains optional. |
| Full digit shadow | Replace carry counts by explicit cross-base prefix comparisons over one common positive residue | Proved and formalized | The criterion is visibly independent of the original minimum while preserving same-row coupling. |
| Canonical bounded obstruction | Prove every boundary divisor satisfies `d ≤ P(n)^2` and expose a finite rejection rectangle | Proved and formalized | The divisor coordinate admits a sharp polynomial bound without changing the theorem. |
| Cofactor and divisor-poset forms | Normalize `d*m ≤ n/2` to `m ≤ (n/d)/2`, then range directly over `n.divisors` | Proved and formalized | The final search domains are exact, finite, and nonredundant. |
| Factor tableau | Encode a boundary divisor by one finite prime-exponent vector and one shared multiplier | Proved and formalized | This is the compact semantic breakthrough: one synchronized object replaces enumeration of legal rows. |
| Explicit compiler | Replace the semantic tableau by ordered factorization, one-hot selectors, prefix products, base digits, and borrow rows | Proved and formalized | Exact soundness and completeness turn the semantic idea into a sparse checkable integer/Boolean system. |
| Release gate | Build the root, reject placeholders, print axioms, regression-test composites through 1000, rebuild a bound archive, and run a clean novelty audit | Passed | The host campaign selector failed before Lean, but the direct kernel, release, statement, and regression gates passed; publication remains external. |

### Evidence and campaign trail

- The maintained proof narrative is
  [`lean-part1/PartIWork/report.md`](../lean-part1/PartIWork/report.md), with the
  [boundary-antichain proof](../lean-part1/PartIWork/boundary-antichain.md).
- The complete recovered release, including the historical report, prose
  proof, statement/referee/reproducibility audits, regression certificate,
  per-formulation adversarial audits, and novelty search, is indexed in the
  [Part (i) release record](../archive/docs/part-i-release/README.md).
- The public theorem and dependency surface is
  [`lean-part1/PartIVerify.lean`](../lean-part1/PartIVerify.lean); the deterministic gate
  is [`lean-part1/scripts/verify.sh`](../lean-part1/scripts/verify.sh).
- The prompt sequence is the Part (i) section of the
  [campaign index](../archive/campaigns/problems/README.md). It records the initial
  target, boundary reduction, historical split, structural attempt, explicit
  borrow compiler, projection repair, refinement reset, and release audit.
- The [Part (i) persisted-run audit](../archive/docs/part-i-run-coverage-audit.md) disposes
  every discovery, release, compiler, and repair run and identifies the
  canonical destination of each durable result.

### Remaining boundary

There is no known mathematical or formal gap in either Part (i) formulation.
The repository treats exact finite iff criteria independent of the original
minimum as a complete solution. A shorter factorization-family enumeration
would strengthen the result but is not required to discharge the stated
characterization target. Novelty, priority, publication, and community
disposition remain external.

## Part (ii): infinitely many strict examples

### Result

The checked theorem is

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

It constructs products \(n=pqr\) of three nearby primes with asymmetric gaps
and proves \(f(pqr)=pq>\sqrt{pqr}\).

### Route map

| Stage | What we tried | Disposition | What we learned / retained |
| --- | --- | --- | --- |
| Broad discovery | Explore Lucas/Kummer, prime products, proof/disproof, and theorem-transfer routes | Produced the decisive (pqr) architecture | Diverse representations mattered more than many variants of one prompt. |
| Structural lemma | For \(p<q<r\), \(r-q>q-p\), and \(4(r-p)^3<p\), show no legal row can omit two primes at once | Proved, independently audited, then formalized | The problem reduces to three concrete base-expansion/borrow cases; the row \(k=r\) gives exact equality \(f(pqr)=pq\). |
| Maynard construction | Use an admissible tuple with exponentially separated offsets to obtain infinitely many suitable triples | Complete natural-language candidate with source and finite falsifier audits | The route appears mathematically viable, but importing or formalizing the sieve theorem would create a large new trust boundary. |
| Lean structural route | Formalize Lucas omission, gcd assembly, and the exact target independently of the infinitude input | Proved | Separating the finite structural theorem from prime production made the later pivot cheap. |
| PNT pivot | Use PNT density in ((8T^3,16T^3]), short boxes, and an elementary exponential-gap lemma | Proved and formalized | Formal-library availability can improve the mathematics: the replacement is smaller and has a cleaner trust boundary than the original discovery route. |
| Integration and release | Prove interval density, packing, dominance, asymmetric gaps, exact `f`, unboundedness, and `Set.Infinite`; audit the final statement and axioms | Passed internally | Compilation, placeholder scans, axiom output, and statement alignment are separate checks and all are needed. |

### Evidence and campaign trail

- The standalone reviewer document is the
  [Part (ii) compiled proof](../part-ii-infinite-family.pdf).
- Start with [`lean-part2/README.md`](../lean-part2/README.md), then read the
  [complete mathematical proof](../lean-part2/docs/proof.md) and
  [statement audit](../lean-part2/docs/statement-audit.md).
- The exact proof root is [`lean-part2/Erdos700PNT.lean`](../lean-part2/Erdos700PNT.lean)
  and the verifier is [`lean-part2/scripts/verify.sh`](../lean-part2/scripts/verify.sh).
- The earlier Maynard candidate, its source mapping, reviewer brief, and
  falsifier are retained under
  [`archive/campaigns/candidates/erdos-700-maynard/`](../archive/campaigns/candidates/erdos-700-maynard/).
  It is research history, not the canonical proof dependency.
- The intermediate PNT/Lean candidate snapshot under
  [`archive/campaigns/candidates/erdos-700-pnt-lean/`](../archive/campaigns/candidates/erdos-700-pnt-lean/)
  is likewise noncanonical; `lean-part2/` contains the promoted development.
- The full discovery → structural audit → Maynard audit → Lean integration →
  PNT route → release sequence is linked in the Part (ii) section of the
  [campaign index](../archive/campaigns/problems/README.md).
- The human/AI division of labor and the formalization pivot are documented in
  the [methodology case study](../archive/docs/methodology.md).

### Remaining boundary

The repository's internal proof gate is complete. Independent mathematical
review and disposition by the problem community remain external to the Lean
theorem. No novelty or priority claim is made here.

## Part (iii): arbitrary logarithmic saving

### Target and current obstruction

Put

\[
D_n(k)=\frac{n}{\gcd(n,\binom nk)},\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

The target is \(D(n)\ge c_A(\log n)^A\) for every fixed \(A>0\) and every
composite \(n\). The exact local objective is

\[
\log D_n(k)=\sum_{p\mid n}
  \left(a_p-v_p\binom nk\right)_+\log p.
\]

The recurring obstruction is the phrase “one row”: successes proved at
different primes, components, or scales do not combine unless they hold for
one literal legal index (k).

### Route map

| Route family | What survived | What failed or remains open |
| --- | --- | --- |
| Exact reduction and easy regimes | Prime powers, a large component, bounded component count, high prime-power-height mass, and an all-height spectrum theorem | The squarefree-dominant residual case still has many comparable low-height components. |
| Direct row construction | Exact component rows, weighted-depth formulation, and some balanced-square classifications | Fixed multiplier menus, naive witness iteration, local bounded-loss peeling, and universal pair selection have counterexamples. An instance-adaptive unbounded multiplier remains open. |
| Pair, packet, and UHFL routes | Exact pair languages, packet regressions, conditional transfer, and finite capacity examples | Pairwise alignment and upper-half full-layer capture are overstrong as default targets; no hard-scale same-row capacity theorem is known. |
| Averaging, cover, and moments | Exact cover LPs, layer identities, exceptional-row necessity, and signed expansions | Marginal probabilities, phase-free set cover, unsigned moments, and generic density cannot force one common row. Actual signed cross-base correlation remains open. |
| Carmichael and global invariants | Several exact lcm/product identities and useful all-row reformulations | A fixed cubic Carmichael bridge is false; growing variants and generic determinant/resultant arguments do not close the target. |
| Digit boxes, affine or cyclotomic rigidity | Deep-prefix escape, an exact effective conductor, and restricted sparse/near-power exclusions | Fixed-base distribution results and bounded-prefix arguments do not transfer to moving bases, actual cutoffs, and one common ambient integer. |
| Algebraic, Pascal, character, and carry operators | Many exact identities and sharp finite falsifiers | Bounded-depth algebra, generic character damping, scalar carry iteration, and unweighted large sieve lose the full tail or the signed phase. |
| Counterexample construction | Method counterexamples to fixed menus, local exchange, cover, and several auxiliary bridges | No infinite family with a uniform all-row bound that disproves Part (iii) was found. |
| Quantitative reset | The high-height branch gives genuine restricted \(A=2\)-scale results | No unconditional unbounded factor beyond \(D(n)\gg\log n\) in the residual branch. |

This table is intentionally a summary. The [Part (iii) exploration
map](part-3.md) is the canonical theorem-by-theorem ledger
and currently records 69 named no-retry constraints with the
extra input needed to revive each route.

### Coverage and evidence

- [Technical bottleneck brief](part-3-bottleneck.md): the shortest
  specialist handoff.
- [Exploration map](part-3.md): top-down tree, proved partial
  results, route outcomes, finite and infinite method counterexamples,
  quarantined claims, and exact surviving targets.
- [Persisted-run coverage audit](../archive/docs/part-iii-run-coverage-audit.md): chronological
  run matrix and disposition labels.
- [Session coverage audit](../archive/docs/part-iii-session-coverage-audit.md): local Codex
  forks and identified browser sessions, including terminal non-solution
  verdicts.
- [Campaign index](../archive/campaigns/problems/README.md): every frozen Part (iii)
  prompt, grouped by representation. These prompts do not override the result
  ledgers above.
- [`archive/experiments/erdos700_extremal.py`](../archive/experiments/erdos700_extremal.py):
  bounded game selection and falsification, never asymptotic evidence.
- [Recovered Route 3 certificate](../archive/experiments/certificates/route3-verification.json):
  compact exact finite checks, also diagnostic rather than asymptotic evidence.

### Exact frontier

A new Part (iii) campaign counts as movement only if it does at least one of
the following:

1. proves \(D(n)\ge c\log n\,L(\log n)\) uniformly for an explicit
   \(L(x)\to\infty\);
2. proves the fixed \(A=2\) case for every composite \(n\);
3. constructs a rigorous infinite counterfamily to such a uniform statement.

Another equivalent conditional bridge is useful only when its hypothesis is
proved or is demonstrably easier than the existing same-row bottleneck.

## Lessons across all three parts

1. **Freeze statements before searching.** Largest prime versus greatest
   prime-power component, strict inequality versus equality, and “one row”
   versus separate witnesses are not cosmetic distinctions.
2. **Preserve same-row coupling.** It is the central arithmetic difficulty in
   Parts (i) and (iii). Any abstraction that multiplies marginal successes or
   changes the ambient cofactor must prove that it preserves the literal row.
3. **Use computation to kill lemmas.** The most durable computations found
   small regressions or exact countermodels. Finite positive evidence never
   discharged an asymptotic quantifier.
4. **Let formalization choose the route.** In Part (ii), the available formal
   PNT changed the final proof and removed a large sieve dependency.
5. **A failed route should leave a certificate.** Part (iii)'s no-retry ledger
   turns unsuccessful work into constraints on the next idea instead of a
   pile of transcripts.
6. **Separate proof status from acceptance.** Kernel checking proves the
   encoded proposition. Historical interpretation, novelty, and community
   acceptance require independent evidence.
7. **Measure progress against the theorem.** For Part (iii), new notation or a
   conditional reduction is not progress unless it crosses the \(A=1\)
   barrier or changes the counterexample frontier.

Operational lessons about the research harness are kept separately in
[`archive/harness/live-campaign-lessons.md`](../archive/harness/live-campaign-lessons.md) and
[`archive/harness/rlm-orchestration-lessons.md`](../archive/harness/rlm-orchestration-lessons.md).

## Where each kind of artifact lives

| Artifact | Canonical location | Authority |
| --- | --- | --- |
| Promoted Parts (i) and (ii) proofs | [`lean-part1/`](../lean-part1/) and [`lean-part2/`](../lean-part2/) | Lean sources, prose proofs, statement audits, deterministic verification |
| Complete Part (i) release evidence | [`archive/docs/part-i-release/`](../archive/docs/part-i-release/README.md) | modern/historical proofs, alternate routes, audits, and regressions |
| Recovered-host disposition | [`archive/docs/dev-georgios-reconciliation.md`](../archive/docs/dev-georgios-reconciliation.md) | promoted versus raw/duplicate/separate-upstream material |
| Current claim boundaries | [`archive/docs/status.md`](../archive/docs/status.md) | repository status vocabulary and publication posture |
| Cross-problem history | this document | narrative route and lesson map |
| Exhaustive Part (iii) synthesis | [`map/part-3.md`](part-3.md) | promoted partial results and do-not-retry ledger |
| Frozen research assignments | [`archive/campaigns/problems/`](../archive/campaigns/problems/) | inputs and completion gates, not outcomes |
| Candidate snapshots | [`archive/campaigns/candidates/`](../archive/campaigns/candidates/) | historical intermediate evidence, noncanonical after promotion |
| Generated runs | `archive/runs/` | ignored raw runtime evidence; durable conclusions must be promoted into the map or archive docs |
| Research application | [`archive/src/`](../archive/src/) and [`archive/harness/`](../archive/harness/) | orchestration and verifier policy, not mathematical evidence by itself |
