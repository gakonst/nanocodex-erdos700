# Erdős 700 research map

This is the narrative index of what we tried on all three parts of Erdős 700,
what survived, and what each stage taught us. It sits between the short
[repository status](status.md) and the much larger retained campaign record.

The scope is deliberately auditable: this map covers the tracked proof
developments, every frozen Erdős 700 campaign prompt in
[`campaigns/problems/`](../campaigns/problems/), the promoted candidate
artifacts, and the persisted Part (iii) runs and sessions audited through
28 July 2026, including the late `dev-georgios` reconciliation. It does not
claim to recover unrecorded thoughts. A prompt is
evidence that a route was assigned, not evidence that its target was proved.

## One-screen overview

| Part | Where we ended | Main progression | Best next action |
| --- | --- | --- | --- |
| (i) | Kernel-checked exact equality characterization and explicit finite certificate system | residue/carry bridge → boundary antichain → factor tableau → integer selector/digit/borrow compiler | independent review of whether this is the intended historical notion of “characterize” |
| (ii) | Kernel-checked unconditional infinite family | nearby-prime structural lemma → Maynard candidate → PNT replacement → complete Lean proof | independent mathematical, statement, and novelty review |
| (iii) | Open beyond the classical \(A=1\) scale | exact weighted reduction → hard residual packets → many construction, averaging, algebraic, and counterexample routes → quantitative no-retry ledger | prove any unbounded gain over \(D(n)\gg\log n\), prove \(A=2\), or build a genuine counterfamily |

The canonical proof artifacts are in [`proof/`](../proof/). The full frozen
prompt inventory is in the [campaign index](../campaigns/problems/README.md).

## Part (i): equality with the largest-prime witness

### Result

For every composite \(n>1\), the checked development proves

```lean
Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

and then proves that `BoundarySafe` is equivalent to an explicit finite
integer/Boolean system. The right side contains no occurrence of `f`, gcd, or
a binomial coefficient, but it still encodes a genuine simultaneous
cross-base digit/carry feasibility problem. It is therefore an exact finite
characterization, not a short taxonomy of factorization shapes.

### Route map

| Stage | What we tried | Disposition | What we learned / retained |
| --- | --- | --- | --- |
| Freeze the target | Separate the largest-prime statement from nearby prime-power-component formulations and forbid a predicate that merely recomputes `f` | Necessary statement control | “Characterization” has a mathematical part and an external interpretation part; they must be reported separately. |
| Reuse Part (ii) machinery | Express gcd size through prime-power carry deficits and prove the largest-prime row gives the baseline value | Proved | The equality question is exactly the absence of an admissible row with overweight retained prime-power mass. |
| Boundary-antichain reduction | Replace all overweight divisors by divisibility-minimal boundary divisors and ask whether one common multiplier realizes all their carry inequalities | Proved and formalized | Minimal divisors are the right finite obstruction set; independent primewise witnesses are not enough. |
| Simplify the multiplier search | Test `m=1`, squarefree-only, divisor-only, endpoint-excluding, and independent-prime criteria | Refuted by explicit regressions | `n=78`, `136`, and `195` show that endpoint inclusion, nontrivial multipliers, repeated powers, and same-row coupling are load-bearing. |
| Historical prime-power pass | Audit the Erdős–Szekeres greatest-prime-power formulation separately from the modern largest-prime target | Partial, kept separate | The two baselines are not interchangeable (`n=12` separates relevant formulations); source alignment cannot be repaired by notation. |
| Structural-classification pass | Seek a shorter closed taxonomy eliminating the common multiplier | No universal shorter taxonomy obtained | The quotient-carry recurrence and several solved strata are useful, but the all-composite cross-base feasibility problem remains irreducible in the current work. |
| Factor tableau | Encode a boundary divisor by one finite prime-exponent vector and one shared multiplier | Proved and formalized | This is a compact semantic certificate with exact soundness and completeness. |
| Explicit compiler | Replace the semantic tableau by ordered factorization, one-hot selectors, prefix products, base digits, and borrow rows | Proved and formalized | A modular refinement chain was substantially more tractable than one monolithic projection theorem. |
| Release gate | Build the root, reject placeholders, print axioms, and regression-test composites through (1000) | Passed internally | Lean establishes the encoded iff and compiler; it does not adjudicate historical taste or novelty. |

### Evidence and campaign trail

- The maintained proof narrative is
  [`proof/PartIWork/report.md`](../proof/PartIWork/report.md), with the
  [boundary-antichain proof](../proof/PartIWork/boundary-antichain.md),
  [structural analysis](../proof/PartIWork/STRUCTURAL_UPGRADE.md), and
  [adversarial audit](../proof/PartIWork/ADVERSARIAL_AUDIT.md).
- The public theorem and dependency surface is
  [`proof/PartIVerify.lean`](../proof/PartIVerify.lean); the deterministic gate
  is [`proof/scripts/verify-part-i.sh`](../proof/scripts/verify-part-i.sh).
- The prompt sequence is the Part (i) section of the
  [campaign index](../campaigns/problems/README.md). It records the initial
  target, boundary reduction, historical split, structural attempt, explicit
  borrow compiler, projection repair, refinement reset, and release audit.
- The persisted-run audit lists the Part (i) campaign and repair runs in its
  [out-of-scope table](part-iii-run-coverage-audit.md#outside-part-iii-scope).
  They are “out of scope” only for that Part (iii) audit, not for this map.

### Remaining boundary

There is no known formal gap in the encoded largest-prime theorem. The open
question is external: whether an exact finite carry/factorization system is a
satisfactory answer to the historical request to characterize all equality
cases, or whether a shorter factorization-only classification is required.

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

- Start with [`proof/README.md`](../proof/README.md), then read the
  [complete mathematical proof](../proof/docs/proof.md) and
  [statement audit](../proof/docs/statement-audit.md).
- The exact proof root is [`proof/Erdos700PNT.lean`](../proof/Erdos700PNT.lean)
  and the verifier is [`proof/scripts/verify.sh`](../proof/scripts/verify.sh).
- The earlier Maynard candidate, its source mapping, reviewer brief, and
  falsifier are retained under
  [`campaigns/candidates/erdos-700-maynard/`](../campaigns/candidates/erdos-700-maynard/).
  It is research history, not the canonical proof dependency.
- The intermediate PNT/Lean candidate snapshot under
  [`campaigns/candidates/erdos-700-pnt-lean/`](../campaigns/candidates/erdos-700-pnt-lean/)
  is likewise noncanonical; `proof/` contains the promoted development.
- The full discovery → structural audit → Maynard audit → Lean integration →
  PNT route → release sequence is linked in the Part (ii) section of the
  [campaign index](../campaigns/problems/README.md).
- The human/AI division of labor and the formalization pivot are documented in
  the [methodology case study](methodology.md).

### Remaining boundary

The repository's internal proof gate is complete. Independent mathematical
review, novelty review, and disposition by the problem community remain
external to the Lean theorem.

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
map](part-iii-exploration-map.md) is the canonical theorem-by-theorem ledger
and currently records 69 named no-retry constraints with the
extra input needed to revive each route.

### Coverage and evidence

- [Technical bottleneck brief](erdos700-iii-bottleneck-brief.md): the shortest
  specialist handoff.
- [Exploration map](part-iii-exploration-map.md): top-down tree, proved partial
  results, route outcomes, finite and infinite method counterexamples,
  quarantined claims, and exact surviving targets.
- [Persisted-run coverage audit](part-iii-run-coverage-audit.md): chronological
  run matrix and disposition labels.
- [Session coverage audit](part-iii-session-coverage-audit.md): local Codex
  forks and identified browser sessions, including terminal non-solution
  verdicts.
- [Campaign index](../campaigns/problems/README.md): every frozen Part (iii)
  prompt, grouped by representation. These prompts do not override the result
  ledgers above.
- [`experiments/erdos700_extremal.py`](../experiments/erdos700_extremal.py):
  bounded game selection and falsification, never asymptotic evidence.

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
[`harness/live-campaign-lessons.md`](../harness/live-campaign-lessons.md) and
[`harness/rlm-orchestration-lessons.md`](../harness/rlm-orchestration-lessons.md).

## Where each kind of artifact lives

| Artifact | Canonical location | Authority |
| --- | --- | --- |
| Promoted Parts (i) and (ii) proofs | [`proof/`](../proof/) | Lean sources, prose proofs, statement audits, deterministic verification |
| Current claim boundaries | [`docs/status.md`](status.md) | repository status vocabulary and publication posture |
| Cross-problem history | this document | narrative route and lesson map |
| Exhaustive Part (iii) synthesis | [`docs/part-iii-exploration-map.md`](part-iii-exploration-map.md) | promoted partial results and do-not-retry ledger |
| Frozen research assignments | [`campaigns/problems/`](../campaigns/problems/) | inputs and completion gates, not outcomes |
| Candidate snapshots | [`campaigns/candidates/`](../campaigns/candidates/) | historical intermediate evidence, noncanonical after promotion |
| Generated runs | `runs/` | ignored raw runtime evidence; durable conclusions must be promoted into docs |
| Research application | [`src/`](../src/) and [`harness/`](../harness/) | orchestration and verifier policy, not mathematical evidence by itself |
