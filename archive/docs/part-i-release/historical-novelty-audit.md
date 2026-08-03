> Recovery note (2026-08-03): retained clean-room novelty-search record. A negative search is evidence, not proof of priority.

# Independent novelty and source audit

**Run:** `math-1784861746-211574`
**Audit date:** 2026-07-24 (UTC)
**Scope:** the six frozen candidates only

## 1. Audit boundary and result in brief

I read `problem.md`, `lead-final.md`, the complete discovery portion of
`ledger.jsonl`, every `frozen/*.json` manifest, and every artifact referenced by
those manifests. I used editable files outside `frozen/` only to locate or
cross-check material; no theorem claim below is attributed to an editable
release draft.

All six candidates prove the same mathematical equivalence. The differences
are verifier normal form and proof packaging: a direct theorem, an
`answer(True)` wrapper, an order-duality presentation, and a finite-extremum
presentation. I found no earlier source stating the candidate's
`HistoricalBoundarySafe` equivalence or a theorem that immediately implies it.
However, its decisive p-adic carry machinery is Kummer's classical theorem, the
exact index `k = Q(n)` gcd witness is already in Erdős--Szekeres (1978), and the
remaining boundary reduction is an elementary minimal-divisor reformulation.
The final candidate-by-candidate labels appear at the end.

This is a documented literature finding, not a guarantee that no unindexed or
unsearched source contains the result.

## 2. Frozen-corpus integrity

### 2.1 Inputs and hashes

The exact target file is `problem.md`, SHA-256
`6e442a9d9164075cfe02f0fd419c4a59f2246131abcaf9401d10c87d3ea80fc7`.
The terminal discovery summary is `lead-final.md`, SHA-256
`aa14177656f47339280a72fd30c02d97a05971770aecd6dfd53932be96dc5b8a`.
Discovery ledger records 1--68 were read before audit evidence was appended
through `record_evidence`.

I recomputed the byte size and SHA-256 digest for all 438 artifact references
in the six manifests. They resolve to 268 unique payloads (265 text payloads,
two `.olean` binaries, and one scanned PDF). There were no missing files, size
mismatches, or hash mismatches. Every payload was byte-read; textual payloads
were inspected, the PDF was inspected with text extraction, and the `.olean`
binaries were integrity-checked rather than decompiled. The broad v4 freeze
contains unrelated part-(ii)/PNT workspace material; it was read but does not
support the audited theorem.

The retained primary-source PDF has SHA-256
`da8bfddd328fa01605cba4c751a7bf9fe07c4fa31bd6cf519fd32c5707ed302b`.
The frozen exact verifier-target/contract payload has SHA-256
`7389d4bf90f6ca7eb0b1a21618d2be8a61091bd937eadc6c5d8f6b70f70eb564`.

### 2.2 Candidate identity and theorem-bearing payloads

| Frozen candidate ID | Manifest label | Frozen theorem-bearing payload | Payload SHA-256 | Mathematical form |
|---|---|---|---|---|
| `d76ea2a166acfe5ab8264ba45e0f304f849e4617ed592d67ed9345ce672f0d07` | `historical-part-i-formal-candidate-v1` | `frozen/d76ea2a…/artifacts/release/solution.lean` | `aad01f038c3496534d7bd364675e31fb444b0d3022924c9bb86331aec5a6c44b` | Direct universal equivalence |
| `5b380d7f8e18dcd2417dcce056f6c4c7a57e9a6b6c28d54a392d4d4bff88f6a2` | `historical-part-i-formal-candidate-v2-isolated-target` | `frozen/5b380d7f…/artifacts/release/solution.lean` | `aad01f038c3496534d7bd364675e31fb444b0d3022924c9bb86331aec5a6c44b` | Same direct theorem, with an isolated target/bridge bundle |
| `f50aad5de57152503dd3eff6ad5d7083e7eed2b25883e0f6315d5bdabbe62059` | `historical-700i-v3-contract-normal-form` | `frozen/f50aad5d…/artifacts/release-v3/solution.lean` | `cecf2458222db24c84f3ec261d18cdafe510a6e5e3d7b3df830522a40062dcbc` | `answer(True) ↔` the same universal equivalence |
| `a1ab41b55c6037918214149540eec22389e08d1aa6d38d9e55066ae0ac8622cd` | `historical-700i-order-duality-v4` | `frozen/a1ab41b5…/artifacts/release-v4/solution.lean` | `0720960ed86834c8cf2dda9e7b4777d447a5bac07eefa0bb8821035905ef61eb` | Same theorem through gcd/weight order reversal; broad bundle |
| `103ac0a9ae9b582e66169cd21c00c9d59c8f8d501d83db94d5993066965ec76b` | `historical-700i-order-duality-v4-focused` | `frozen/103ac0a9…/artifacts/release-v4/solution.lean` | `0720960ed86834c8cf2dda9e7b4777d447a5bac07eefa0bb8821035905ef61eb` | Byte-identical v4 theorem root; focused bundle |
| `78d0f6ad8611f00746a1c8cd435f076e9e9d678f1fa599e2e3b0c97e666f03ad` | `historical-erdos-700i-extremal-v5` | `frozen/78d0f6ad…/artifacts/release-v5/solution.lean` | `7ef86a9b24b5f03254e5bf7c1018a17fa4dbd24c4711bf910351d390ba618f30` | Same theorem through a finite maximum of carry weights |

Ellipses in the displayed paths abbreviate only the already displayed full
candidate ID. Comparisons and conclusions were made from the full frozen paths
and verified digests. In particular, the duplicate root hashes establish that
v1/v2 and v4-full/v4-focused are not distinct mathematical claims.

## 3. Exact target recovered from `problem.md`

For a natural number `n`, let

\[
 f(n)=\min_{1<k\le \lfloor n/2\rfloor}
       \gcd\!\left(n,{n\choose k}\right)
\]

and, for `n > 1`, let the greatest exact prime-power component be

\[
 Q(n)=\max_{p\mid n,\ p\ {m prime}}p^{\nu_p(n)}.
\]

The correction in `problem.md` is substantive. The 1978 wording is “greatest
prime power which divides `n`,” which gives `Q(n)` above. The modern Erdős
Problems/Formal Conjectures transcription instead uses the largest *prime
divisor*. For example, `n=12` gives historical `Q(12)=4` and `f(12)=3=12/4`,
whereas the modern baseline is `3` and `12/3=4`. Thus results for the modern
formulation cannot be imported without a hypothesis such as squarefreeness.

The immutable target asks for every natural `n` satisfying

\[
 1<n\quad\text{and}\quad \neg n.\mathrm{Prime}
\]

to prove

\[
 f(n)=\frac{n}{Q(n)}
 \quad\Longleftrightarrow\quad
 \neg\mathrm{IsPrimePow}(n)\ \land\
 \mathrm{HistoricalBoundarySafe}(n).
\]

It additionally requires the prime-power failure and the exact witness at
`k=Q(n)`, rather than allowing either to be hidden in a side condition.

## 4. Precise candidate statement

### 4.1 Carry definitions

The frozen Lean roots define

\[
 C_p(n,k)=\#\left\{i:1\le i<\log_p(n)+1,
 p^i\le (k\bmod p^i)+((n-k)\bmod p^i)\right\}.
\]

This is `residueCarryCount n k p`. For prime `p` and `k≤n`, the candidates
prove/use

\[
 C_p(n,k)=\nu_p{n\choose k}.
\]

They define the complementary carry weight

\[
 W(n,k)=\prod_{p\mid n}p^{\nu_p(n)-C_p(n,k)}.
\]

For an admissible index (`1<k≤⌊n/2⌋`) the central exact identity is

\[
 \gcd\!\left(n,{n\choose k}\right)W(n,k)=n,
\]

and the frozen development also proves `W(n,k)∣n` and `W(n,k)∣k`.

### 4.2 Boundary and realization predicates

Writing `Q=Q(n)`, the exact predicates are:

\[
\begin{aligned}
\mathrm{HistoricalBoundary}(n,d)\ :\Longleftrightarrow\;&
 d\mid n,\quad Q<d,\\
& d/p\le Q\quad\text{for every prime }p\mid d;
\\[3pt]
\mathrm{HistoricalRealized}(n,d)\ :\Longleftrightarrow\;&
 \exists m>0:\ d m\le\lfloor n/2\rfloor,\\
& C_p(n,dm)\le\nu_p(n)-\nu_p(d)
   \quad\text{for every prime }p\mid d;
\\[3pt]
\mathrm{HistoricalBoundarySafe}(n)\ :\Longleftrightarrow\;&
 \forall d,\ \mathrm{HistoricalBoundary}(n,d)
 \Rightarrow\neg\mathrm{HistoricalRealized}(n,d).
\end{aligned}
\]

The existential realization uses **one common multiplier `m` for all prime
divisors of `d`**. Its endpoint is inclusive. Since a boundary has `d>Q>1`
and `m>0`, `k=dm` automatically satisfies the lower admissibility bound.

### 4.3 Hypotheses, conclusion, witness, and exceptional case

Each frozen candidate asserts, universally and with no unlisted numerical
cutoff,

```text
∀ n : ℕ, 1 < n → ¬ n.Prime →
  (Erdos700.f n = n / Erdos700.Q n ↔
    ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n).
```

For every non-prime-power `n>1`, the theorem bundle also supplies

```text
1 < Q(n) ∧ Q(n) ≤ n/2,
gcd(n, choose(n,Q(n))) = n/Q(n),
residueCarryWeight n Q(n) = Q(n).
```

For a composite prime power `n=p^a` with `a≥2`, it uses the proved special
case `f(p^a)=p`, while `Q(p^a)=p^a` and `n/Q(n)=1`; hence the equality fails.
The mandatory values `8,12,18,30,78,136` and the scan through `n≤1000` are
regression evidence only, not hypotheses or effective ranges.

There are no asymptotic constants, exceptional large/small ranges, or
probabilistic assumptions. The claimed range is every composite natural
number greater than one.

### 4.4 Formal dependencies

The manifests pin Formal Conjectures revision
`e751934294a381afd2d5fc1124c5953c8e25f9fa`, Lean 4.27.0, and the Mathlib
revision selected by that workspace's `lake-manifest.json`. Retained axiom
reports list `[propext, Classical.choice, Quot.sound]`. The prime-power branch
uses the upstream *proved special-case formula*, not the upstream open
universal characterization. These are dependency/status facts, not an
independent re-verification by this audit.

## 5. Decisive route extracted for novelty comparison

The following is a description of the frozen route, not a repair or substitute
proof.

1. Kummer carry counting identifies `C_p(n,k)` with
   `ν_p(choose(n,k))`.
2. Primewise valuation arithmetic gives
   `gcd(n,choose(n,k))·W(n,k)=n` for every admissible `k`.
3. The greatest-component index `k=Q(n)` is admissible off prime powers and
   has exactly `W(n,Q)=Q`, hence gcd `n/Q`.
4. Therefore `f(n)=n/Q` exactly when all admissible weights are at most `Q`.
5. If a divisor/weight exceeds `Q`, a divisor minimal above `Q` satisfies the
   displayed boundary conditions. Conversely, the realization inequalities
   are exactly the primewise conditions making such a boundary divisor divide
   `W(n,dm)`. This turns “some weight exceeds `Q`” into “some boundary is
   realized.”
6. The composite-prime-power branch is separated because its `Q` index is not
   admissible and its target equality is false.

Versions v1/v2 state this directly. Version v3 changes only the verifier
contract. Version v4 exposes the exact order reversal

\[
 \gcd(n,{n\choose k})<n/b
 \quad\Longleftrightarrow\quad b<W(n,k)
\]

for a positive divisor baseline `b`. Version v5 defines the finite maximum of
`W(n,k)` over admissible indices and proves that it equals `Q` exactly when the
boundary predicate is safe. These are equivalent presentations, not six
independent advances.

## 6. Search protocol

### 6.1 Databases and repositories

Searches were performed on 2026-07-24 in general web/full-text search, arXiv,
the Erdős Problems database and discussion forum, OEIS, GitHub code/issues/PRs
(especially Google DeepMind Formal Conjectures), zbMATH's web index, Crossref,
OpenAlex, publisher/DOI pages, author-hosted primary papers, and bibliographies
of the retrieved papers. The retained 1978 paper was searched both visually
and through a local extraction.

The Semantic Scholar API returned HTTP 429. The zbMATH API attempts failed, so
the public author/title web index was used. I did not have a complete
subscription citation graph from MathSciNet. These limitations matter because
the original problem is old and terminology is inconsistent.

### 6.2 Query families

The material query families, including exact-string and close semantic
variants, were:

- `"HistoricalBoundarySafe"`, `"HistoricalBoundary" "residueCarryCount"`,
  `"residueCarryWeight" binomial`, and `"admissibleCarryMaximum"`;
- `"gcd(n, binomial(n,k))" minimum`, `"min" "gcd(n" "binomial(n,k)"`, and
  `"min_{1<k" gcd binomial`;
- `"f(n)=n/P(n)"`, `"n/P(n)" binomial gcd`, `"f(30)=6"`, and the exact 1978
  title/citation;
- `"P(n) is the greatest prime power which divides n"`, `greatest exact
  prime-power component`, `largest prime-power divisor`, and equivalent
  `p^a || n` terminology;
- `Kummer carries n/P(n) binomial`, `number of carries greatest prime power`,
  `p-adic digits binomial gcd`, `minimal divisor binomial coefficient`, and
  `boundary antichain Pascal row`;
- citation and author searches around Erdős, Szekeres, Guy, Bergman, Hong,
  Joris--Oestreicher--Steinig, McTague, Casacuberta, Cambie, and recent Formal
  Conjectures work;
- aggregate row-gcd, truncated-row-gcd, restricted-index-gcd, and varying-row
  formulations, to test whether a stronger known theorem specializes to the
  target.

The candidate-specific identifiers had no external hits. Semantic searches
returned the original open problem, current open trackers, classical carry
theorems, and the non-equivalent neighboring results compared below. A search
failure is not proof of absence.

## 7. Source-by-source overlap analysis

### 7.1 Original problem and current status sources

**Erdős--Szekeres (1978).** The primary paper defines the same `f(n)`, defines
`P(n)` as the greatest prime power dividing `n`, proves the prime-power value,
and asks for a characterization of equality `f(n)=n/P(n)`. Crucially, when
`p^a || n`, it already states that choosing `j=p^a` gives
`gcd(n,choose(n,j))=n/p^a`; choosing the greatest such component yields the
candidate's load-bearing gcd witness and upper bound. It gives cases such as
two-prime products and `30`, but no `HistoricalBoundary`, common-`m`
realization, carry-weight maximum, or universal iff. Thus it overlaps the
problem, baseline, special cases, and witness, but not the claimed
characterization. [Primary paper](https://static.renyi.hu/~p_erdos/1978-46.pdf).

**Current Erdős Problems page.** Problem 700 was marked open when checked, but
the page's `P(n)` is the largest prime divisor. Its hypotheses therefore differ
for nonsquarefree `n`; `n=12` is a direct separator. On squarefree integers the
two baselines coincide, but the page still supplies no theorem implying the
candidate's boundary criterion. Its open marker is useful status evidence, not
a complete literature review. [Problem 700](https://www.erdosproblems.com/700).

**Formal Conjectures.** Both the pinned dependency and current main use the
modern largest-prime-factor baseline. The pinned part-(i) answer is open and
only prime-power/two-prime variants are proved. Current main, downloaded in
this audit with SHA-256
`12b484d31b0c6fababdd7283d94c085e5c9b5afc60202647b1b7062ee540088c`,
still has an open answer after the June 2026 update. Neither its open
placeholder nor its special cases imply an all-composite theorem for
`Q(n)=max p^{ν_p(n)}`. [Pinned source](https://raw.githubusercontent.com/google-deepmind/formal-conjectures/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean),
[current source](https://raw.githubusercontent.com/google-deepmind/formal-conjectures/main/FormalConjectures/ErdosProblems/700.lean),
[issue 888](https://github.com/google-deepmind/formal-conjectures/issues/888),
[merged PR 4197](https://github.com/google-deepmind/formal-conjectures/pull/4197).

**Erdős Problems discussion.** Stijn Cambie's 2025 comment gives a base-`p`
digit restatement for a special modern-baseline family `n=q(q+1)` and numerical
examples, while expressly not presenting it as the desired characterization.
The thread contains no universal boundary/common-m theorem. It is closest in
style on squarefree subcases, where the two baselines coincide, but its
hypotheses are strictly narrower and it does not imply the candidate.
[Discussion thread](https://www.erdosproblems.com/forum/thread/700?order=oldest).

**OEIS A091963.** The entry tabulates the same minimum-gcd sequence and gives a
Maple program and references. Its displayed range includes `k=1`; for the
composite range here that extra value `gcd(n,n)=n` does not change the minimum.
It contains no factorization formula, boundary predicate, or theorem from
which the candidate follows. [OEIS entry](https://oeis.org/A091963),
[internal record](https://oeis.org/A091963/internal).

**Guy, B31/B33.** Guy discusses non-coprimality and prime factors/common
divisors of selected binomial coefficients (B31), and proper divisors and prime
factors of an individual coefficient (B33). Neither section takes
`min_k gcd(n,choose(n,k))` or concludes equality to `n/Q(n)`. The OEIS/Guy
citation path is therefore neighboring literature, not prior disclosure of the
candidate. [Book record](https://link.springer.com/book/10.1007/978-0-387-26677-0).

### 7.2 Direct method overlap

**Kummer (1852), as presented by Granville (1997).** Kummer proves that
`ν_p(choose(n,k))` is the number of base-`p` carries when adding `k` and `n-k`.
This is exactly the mathematical content of the frozen
`residueCarryCount_eq_factorization_choose` bridge. Kummer/Granville do not
define `f`, `Q`, or the boundary predicate, so they do not imply the complete
theorem without the candidate's additional construction. They do establish
the decisive valuation method. [Kummer DOI](https://doi.org/10.1515/crll.1852.44.93),
[Granville's primary author page](https://dms.umontreal.ca/~andrew/Binomial/intro.html),
[full article](https://www.cecm.sfu.ca/organics/papers/granville/paper/binomial/html/binomial.html).

**Hong (2016).** For positive `m,n`, Hong proves

\[
 \gcd\{{mn\choose k}:1\le k\le mn,\ \gcd(k,m)=1\}
 =m\prod_{p\mid\gcd(m,n)}p^{\nu_p(n)}.
\]

This is one aggregate gcd over an arithmetically restricted family; the frozen
target is a minimum of the separate numbers `gcd(n,choose(n,k))` in one half
row. Neither conclusion determines the other. Hong's Lemma 2.3 does overlap a
witness ingredient by giving
`ν_p(choose(N,p^e))=ν_p(N)-e` for `e≤ν_p(N)`, but it has no greatest-component
boundary or shared multiplier. [Primary article](https://www.numdam.org/articles/10.1016/j.crma.2016.06.001/).

**Bergman (2011).** Bergman's Theorem 1 says that two proper same-row
coefficients `choose(N,i)` and `choose(N,j)` with
`0<i≤j≤N/2` have a common divisor greater than one; later sections concern
families of multinomial coefficients and Wasserman's conjecture. This does not
involve gcd with `N`, a minimum over `k`, or `n/Q(n)`. Its Kummer lemma confirms
the established carry method but supplies no candidate implication.
[Primary paper](https://www.cambridge.org/core/journals/bulletin-of-the-australian-mathematical-society/article/on-common-divisors-of-multinomial-coefficients/B01573B43C083B254C0A9A4F2A1DE3C7).

### 7.3 Neighboring gcd and divisibility theorems

| Source | Its hypotheses and conclusion | Comparison with the frozen theorem |
|---|---|---|
| Joris--Oestreicher--Steinig (1985) | Determines the aggregate gcd of prescribed consecutive terms in a fixed Pascal row. | An aggregate gcd can be below every individual term and is not `min_k gcd(n,choose(n,k))`; neither theorem immediately implies the other. [DOI](https://doi.org/10.1016/0022-314X(85)90013-7) |
| McTague (2017) | Studies `gcd(choose(n,q),choose(n,2q),…)` for an arithmetic progression of lower indices. | Fixed-row aggregate gcd, different index set, and no gcd with `n`, `Q`, or boundary criterion. [arXiv](https://arxiv.org/abs/1510.06696) |
| Chiu--Yuan--Zhou (2023) | Defines a least central truncation `b(n)` for which an aggregate row gcd is nontrivial and evaluates valuations of another restricted aggregate gcd. | The ranges and quantifiers differ; aggregate gcd and pointwise minimum do not commute. No implication in either direction was found. [DOI](https://doi.org/10.4134/BKMS.b220166) |
| Chung--Yang--Zhou (2025) | Evaluates gcds of sets of binomial coefficients selected by lower-index restrictions, using Kummer/p-adic methods. | It establishes related method use, not the individual-gcd minimum or a greatest-component equality. [Primary article](https://ojs.wiserpub.com/index.php/CM/article/view/5017) |
| Casacuberta (2019) | Seeks two primes such that every interior `choose(n,k)` is divisible by at least one and proves sufficient conditions using largest prime-power divisors and “dangerous intervals.” | Its conclusion is a covering/divisibility property, not the value of `gcd(n,choose(n,k))`; neither result entails the other despite shared Lucas/Kummer machinery. [arXiv](https://arxiv.org/abs/1906.07652) |
| Guo--Qiu--Cao--Feng--Gao (2026) | For `D(k)=gcd_{2≤q≤k+1} choose(qk,k)` and `n=k+1`, proves `D(k)=1 ↔ n/ppart(n)>ppart(n)`, with `ppart` the largest exact prime-power component. | This has varying upper indices and fixed lower index; the candidate has one upper row, varying lower index, and gcd with `n`. The same terminology and digit methods do not create an implication. [arXiv](https://arxiv.org/abs/2606.22997) |

No source in this set states `HistoricalBoundarySafe`, an equivalent
one-common-`m` obstruction, an all-admissible carry-weight maximum equal to
`Q(n)`, or a stronger theorem whose specialization gives that statement.

## 8. Overlap synthesis

The closest prior work has three distinct roles:

1. **Exact target and witness:** Erdős--Szekeres (1978) poses the equality
   problem and already proves the exact-prime-power-index gcd identity used at
   `Q(n)`.
2. **Decisive valuation engine:** Kummer's theorem, with modern presentations
   such as Granville's, supplies the carry characterization used prime by
   prime. Hong and other later papers confirm that prime-power indices and
   restricted gcd families are standard applications of this engine.
3. **Current status and nearby formulations:** the Erdős Problems page,
   current Formal Conjectures source, forum, and OEIS do not record a completed
   characterization. Their modern largest-prime baseline must not be conflated
   with the historical exact-prime-power baseline.

What I did **not** find is a prior publication of the particular finite
divisor-poset criterion: minimal divisors above `Q`, realized by a single
admissible multiple whose carries satisfy all primewise inequalities. Thus the
whole iff appears to be a new application/packaging of established tools, not
a recovered theorem from the sources checked. It is not a strict improvement
of a matched weaker theorem: the neighboring results have different
hypotheses and conclusions.

The novelty attributable to v3, v4, and v5 separately is still smaller. Their
contract, order-duality, and finite-maximum forms are internally equivalent to
the v1 theorem and do not change its mathematical scope.

## 9. Correctness and target-alignment concerns (separate from novelty)

1. **No accepted host-verifier result.** `lead-final.md` calls the final v5
   artifact a strong candidate but not verified. Its frozen host result has
   `accepted=false` and stopped before running Lean because the target had not
   been registered in the required host format. Frozen local build and axiom
   logs report successful elaboration and only the three standard axioms
   listed above. Host rejection therefore is not a refutation, but local logs
   must not be upgraded to host acceptance. I did not repair or alter the
   verifier setup.

2. **Characterization significance.** `HistoricalBoundarySafe` is engineered
   from the same Kummer carry data that determines the gcd minimum. Versions v4
   and v5 make explicit that it means, respectively, “no admissible gcd lies
   below `n/Q`” or “the maximum admissible weight is `Q`.” This is a valid exact
   predicate if the Lean equivalence is correct, but it may not satisfy a
   number theorist's intended meaning of “characterize `n`,” such as a usable
   condition on the factorization of `n` alone. This is a significance/target
   interpretation concern, not a proof disproof, and I have not replaced the
   predicate.

3. **Historical versus modern baseline.** The frozen statement correctly
   follows `problem.md`'s historical `Q`. Any referee testing it against the
   current largest-prime formulation will obtain apparent contradictions on
   numbers such as `12`; those are different propositions.

4. **Quantifier sensitivity.** The common multiplier in
   `HistoricalRealized` and the inclusive endpoint `dm≤⌊n/2⌋` are
   load-bearing. Replacing the common `m` by prime-dependent multipliers, or
   making the endpoint strict, would be a different theorem. The audited
   frozen roots use the intended versions.

## 10. Remaining uncertainty and recommended expert checks

- Search MathSciNet's full citation graph for the 1978 paper and non-English
  number-theory literature under “greatest prime power divisor,” Pascal-row
  minima, and p-adic digit/carry terminology. The public Crossref/OpenAlex and
  zbMATH-web searches did not provide a complete citation chain.
- Ask a specialist familiar with Erdős--Szekeres Problem 700, and preferably
  the Erdős Problems maintainers, whether this exact carry/boundary condition
  has circulated as folklore or appears in unpublished correspondence.
- Have a number theorist decide whether the carry-quantified boundary predicate
  counts as the requested characterization, or merely renames the extremal
  condition. That judgment affects significance, not the formal iff.
- Independently rebuild the **frozen** roots in the pinned Lean/Mathlib
  environment and compare the encoded `f`, half-interval endpoints,
  `IsPrimePow`, and `Q` against the historical prose. Lean acceptance would
  establish only the encoded proposition.
- Recheck literature appearing after the audit date. The June 2026 Guo et al.
  paper shows that nearby exact-prime-power gcd questions are currently active.

## Final novelty verdicts

- `d76ea2a166acfe5ab8264ba45e0f304f849e4617ed592d67ed9345ce672f0d07` — `known-method-new-application`
- `5b380d7f8e18dcd2417dcce056f6c4c7a57e9a6b6c28d54a392d4d4bff88f6a2` — `known-method-new-application`
- `f50aad5de57152503dd3eff6ad5d7083e7eed2b25883e0f6315d5bdabbe62059` — `known-method-new-application`
- `a1ab41b55c6037918214149540eec22389e08d1aa6d38d9e55066ae0ac8622cd` — `known-method-new-application`
- `103ac0a9ae9b582e66169cd21c00c9d59c8f8d501d83db94d5993066965ec76b` — `known-method-new-application`
- `78d0f6ad8611f00746a1c8cd435f076e9e9d678f1fa599e2e3b0c97e666f03ad` — `known-method-new-application`
