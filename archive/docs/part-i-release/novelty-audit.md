# Independent novelty and source audit

**Run:** `math-1784859934-190817`
**Audit date:** 2026-07-24 UTC
**Scope:** all eight content-addressed candidates under `frozen/`
**Audit type:** clean-room novelty/source audit; no proof repair

## 1. Bottom line

I found no prior source that states, proves, or immediately implies the frozen
all-composite characterization

\[
  f(n)=\frac{n}{P(n)}\quad\Longleftrightarrow\quad
  \operatorname{BoundarySafe}(n),
\]

or any of its frozen `FullShadowSafe`, `BoundedObstructionSafe`, or
`CofactorObstructionSafe` equivalents. The canonical modern problem page and
the current Formal Conjectures file both still presented the target as open at
the audit date. This is negative search evidence, not proof of novelty.

The decisive mathematical route is not new: Kummer's carry theorem gives the
prime-adic valuation of a binomial coefficient, Lucas-type digit arguments
give the prime-power witnesses, and the identity
\(n\binom{n-1}{k-1}=k\binom nk\) supplies the relevant divisibility. The
candidate's apparent contribution is to combine those established tools with
a divisibility-minimal obstruction divisor and package the result as an exact
finite criterion. This distinction determines the candidate-by-candidate
verdicts at the end.

There are two important qualifications:

1. the exact finite criterion still encodes an index search through simultaneous
   carry budgets, so whether it satisfies the intended mathematical force of
   “characterize” is a substantive interpretation question; and
2. the local Lean logs support only the encoded propositions. No frozen
   candidate received host-verifier acceptance, and this audit did not repair
   or replace any proof.

## 2. Chain of custody and audited objects

### 2.1 Frozen-artifact verification

I read `problem.md`, `lead-final.md`, `ledger.jsonl`, every `frozen/*.json`
manifest, and every manifest-referenced artifact from its frozen path. I did
not substitute later editable top-level drafts for frozen files.

Independent SHA-256 and byte-length checks covered **596 manifest references**
representing **189 distinct content hashes**. There were zero missing files,
byte-count mismatches, or digest mismatches. All text, JSON, and JSONL files
were read and type-checked; all six JPEGs were loaded; the frozen 1978 PDF and
its full-page rasters were visually inspected; and all 32 regular members of
the frozen release archive were read and hash-checked. Detailed audit-created
inventories are:

- `novelty-audit-artifact-inventory.tsv`;
- `novelty-audit-content-inventory.tsv`;
- `novelty-audit-release-archive-inventory.tsv`.

The immutable `problem.md` has SHA-256
`cbb06e948a80003befd4c34037c7ac0b83f761184f31daf087cde7bb33328144`
in every freeze. The main modern source in the latest freeze has SHA-256
`a7631a0a76fd15d5ec4ec44550e29e9821208cadd853171607a26f7d83b0e555`.

### 2.2 Manifest census

| Version | Candidate ID | Frozen UTC | Manifest SHA-256 | Refs | Mathematical delta |
|---|---|---:|---|---:|---|
| v1 | `411c6fe34a7dd135c83e16f6ac96c1f083334ddb8eb946f26683d2a4dc56f55b` | 05:31:17 | `337b1fcd62512b91c50bc4366945088452b20e292c37f5d275c5339fac2b57f0` | 89 | Core `BoundarySafe` iff |
| v2 | `f8f7ed71d558f4497b8ccfea3b7eb9455bcd0b4d4eddd4f4072d6bbbe1d07794` | 05:56:38 | `21487ddb993e609ddc585b7903800c7bad1303e83e816f972f8dcaccc403ea9c` | 88 | Same theorem/candidate text as v1; evidence packaging changed |
| v3 | `7339e9d636a5b1bec65ed61fd449ba03cba973afdb54ef2580ec05e789481ad8` | 06:05:19 | `a75a8fac30c159b13f43007fd1e168fabb1456985cf9ff9d2fb99403801ba88b` | 93 | Same theorem/candidate text as v1-v2 |
| v4 | `9f451b6a9e4b7557425391d9d7faeceebd970b204b3e6d33d3b39ed032cdb243` | 08:35:47 | `88ac55711696a685e51e957a3a132b7829e021c097a989f5a0a255f40a830dd9` | 51 | Adds proper-prime-power threshold and literal-1978 specialization |
| v5 | `75bf0b89363ceac0a89df3351ff603d546121ba193b7c33ce5e1eaf7baaa5780` | 10:47:08 | `ec1af3161570895392139d53a53bd0f7fc52c9cc1615e96f8cdfeb47d1376e6b` | 58 | Same mathematics as v4; deterministic release |
| v6 | `9569872c989b401b2d6b6b7a7b69f902cac712655595112514d9c8c24b26c523` | 12:30:59 | `6a6d16d4081c7d47e00feda6aa610614637161ba670205581b38b58c217618dc` | 64 | Adds the equivalent full digit-shadow form |
| v7 | `427371d54c255cd56e3496efe582509f902c30c49a09340fe80bff61c9b84ccd` | 13:34:04 | `7998d5fa16a2a761cc4be4596d17de2e9eecd1dce3cb485cac566ccaa6557461` | 72 | Adds \(d\le P(n)^2\) and bounded-obstruction form |
| v8 | `3f603b2a8b609dc7adb5cad0e8acaa6b1e889c37525d8051e503afc04803ba87` | 14:14:23 | `ee553f40d08cb78b61f229e4b0c51ed979a07522b517a1d69ff63f032cac8bcd` | 81 | Adds exact cofactor-normalized multiplier range |

The first three freezes share the same `candidate.md` hash and are one
mathematical result, not three discoveries. Versions 4–8 are cumulative.
The ledger also discloses transfer of core material and the historical
specialization from earlier retained internal campaigns. That is relevant
authorship/provenance information but is not evidence of prior public
publication.

`lead-final.md` names v7, while v8 was frozen forty minutes later.
`campaign-final.json` names no verifier-accepted candidate. Following the user
request, I audited all eight manifests rather than treating the stale lead file
as an exclusive selection. The post-v8 `DivisorPosetObstruction.lean` recorded
at ledger sequences 82–83 is **not frozen** and is therefore outside the
candidate verdicts.

## 3. Exact target recovered from `problem.md`

For a natural number \(n>1\) that is not prime, define

\[
 f(n)=\min_{1<k\le \lfloor n/2\rfloor}
       \gcd\!\left(n,{n\choose k}\right),
\]

and let \(P(n)\) be the largest prime factor of \(n\). The required theorem is

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

The endpoint \(k=n/2\) is included. The right-hand predicate may not mention
`f`, gcd, binomial coefficients, or invoke the upstream open theorem.

For \(d\in\mathbb N\), the frozen definitions are:

* `Boundary n d`:
  \(d\mid n\), \(P(n)<d\), and \(d/p\le P(n)\) for every prime \(p\mid d\).
* `Realized n d`: there is an integer \(m>0\) with
  \(dm\le\lfloor n/2\rfloor\) such that, for every prime \(p\mid d\),
  \[
  C_p(n,dm)\le v_p(n)\mathbin{\dot-}v_p(d),
  \]
  where \(\dot-\) is natural-number truncated subtraction and
  \[
  C_p(n,k)=\#\{1\le i<\log_p(n)+1:
       p^i\le(k\bmod p^i)+((n-k)\bmod p^i)\}.
  \]
* `BoundarySafe n`: no `Boundary n d` is `Realized n d`.

There is no asymptotic qualifier or effective lower cutoff: the statement is
for every composite natural \(n>1\).

### Historical statement is different

The primary paper by Erdős and Szekeres defines \(P(n)\) as the **greatest
prime power dividing \(n\)**, not the largest prime factor, and then asks for
the equality cases. It records the prime-power-component witness and examples
including \(f(30)=6\) and \(f(210)=14<30\). See P. Erdős and G. Szekeres,
“Some number theoretic problems on binomial coefficients,” *Australian
Mathematical Society Gazette* 5 (1978), 97–99
([primary scan](https://www.renyi.hu/~p_erdos/1978-46.pdf); zbMATH
[Zbl 0401.10003](https://api.zbmath.org/v1/document/0401.10003)).

The distinction is extensionally real. At \(n=12\), the target gcds for
\(k=2,\ldots,6\) are \(6,4,3,12,12\), so \(f(12)=3\). The modern quotient is
\(12/3=4\), while the historical quotient is \(12/4=3\). Thus the modern
target fails and the literal historical equality holds. The audit therefore
does not use the 1978 question as if it were the same theorem.

## 4. Candidate theorem, constants, ranges, and dependencies

### 4.1 Core mechanism in all versions

The frozen proof defines the complementary carry weight

\[
 W_n(k)=\prod_{p\mid n}p^{v_p(n)\mathbin{\dot-}C_p(n,k)}.
\]

For admissible \(k\), the claimed chain is:

1. Kummer's theorem identifies \(C_p(n,k)=v_p\binom nk\).
2. Consequently
   \(\gcd(n,\binom nk)W_n(k)=n\).
3. From \(n\binom{n-1}{k-1}=k\binom nk\), one gets \(W_n(k)\mid k\).
4. The witness \(k=P(n)\) is admissible for composite \(n>1\) and satisfies
   \(W_n(P(n))=P(n)\).
5. Hence the target equality is equivalent to \(W_n(k)\le P(n)\) for every
   admissible \(k\).
6. If \(W_n(k)>P(n)\), a divisibility-minimal divisor \(d\mid W_n(k)\) above
   \(P(n)\) obeys exactly the `Boundary` deletion inequalities.
7. Since \(W_n(k)\mid k\), write \(k=dm\). The condition \(d\mid W_n(dm)\)
   is exactly the simultaneous prime-by-prime carry budget in `Realized`.

This is an exact finite equivalence, not merely a sufficient family or a
finite computational observation.

### 4.2 Cumulative extensions

| First frozen | Exact additional result | Hypotheses/range | Nature of conclusion |
|---|---|---|---|
| v4 | `f_eq_div_primePow_iff_boundarySafeAt` | \(p\) prime, \(b>0\), \(p^b\mid n\), and \(p^b<n\) | \(f(n)=n/p^b\) iff the same minimal-obstruction criterion uses baseline \(p^b\). The underlying witness gcd formula already assumes only \(n>0\) and \(p^b\mid n\). |
| v4 | `erdos_700_i_historical` | \(n>1\), \(n\) composite | For \(Q(n)=\max_{p\mid n}p^{v_p(n)}\), \(f(n)=n/Q(n)\) iff \(n\) is not a prime power and `HistoricalBoundarySafe n`. The prime-power exception is explicit. |
| v6 | `f_eq_div_iff_fullShadowSafe` | Same composite \(n>1\) hypotheses | Replaces each carry condition by \(n\bmod p^i<k\bmod p^i\). For fixed \(d\), it searches a positive residue \(1\le r\le Q_d\), where \(Q_d=\prod_{p\mid d}p^{\lfloor\log_p n\rfloor}\), still subject to \(dr\le n/2\). This is equivalent, not a stronger bound on \(f\). |
| v7 | `boundary_le_largestPrime_sq` and `f_eq_div_iff_boundedObstructionSafe` | \(n>1\); the iff also assumes composite | Every boundary divisor lies in the inclusive interval \(P(n)+1\le d\le P(n)^2\). For each such divisor and each \(1\le m\le n/2\) with \(dm\le n/2\), at least one prime factor must violate its carry budget. |
| v8 | `mul_le_half_iff_le_cofactor_half` and `f_eq_div_iff_cofactorObstructionSafe` | Positive \(d\mid n\); the iff assumes composite \(n>1\) | Replaces the product cutoff exactly by \(1\le m\le\lfloor(n/d)/2\rfloor\); the divisor range remains \(P(n)+1\) through \(P(n)^2\). |

The source hashes for these additions are respectively
`7f953044913a46b1bf4bdffbbcc0d9770345235ba2eb41eb0ad70e95ada0ceaa`
(prime-power threshold),
`a677c8a62a18ceaa5327944550500ede916020df92d98a0e48a959c6db80108c`
(historical),
`398fdbccd8a27e798416ff41d5f8889da816c04887b7f127c8f7e685d85f11a6`
(full shadow),
`776d77097b9ca3bf56647e22e26ab45bb68dd5eee6ecb498cb09314de6952de0`
(bounded obstruction), and
`238cdb64197025bf3e369d88b221f8872b2e44a4eed896f423f53947ab1e8459`
(cofactor obstruction).

### 4.3 Formal dependencies and status

The later manifests pin Lean 4.27.0 and the corresponding Mathlib/Formal
Conjectures revisions through included lockfiles and the deterministic v5
archive. Frozen compile logs report the axiom set
`[propext, Classical.choice, Quot.sound]` for promoted theorems. Those logs are
discovery artifacts; I verified their hashes and contents but do not convert
them into independent host acceptance.

`lead-final.md` says “strong-candidate; not host-verified.” The configured
verifier exited before invoking Lean because `problem.md` did not identify
exactly one pre-approved target. Thus there is no host acceptance or host
refutation of the encoded theorem.

## 5. Search protocol

All searches below were conducted on 2026-07-24. Material sources and overlap
decisions were appended to `ledger.jsonl` under `audit/*` routes (audit
sequences 84–126). Audit downloads and API responses are retained under
`novelty-audit-sources/`.

### 5.1 Databases and repositories

I searched or inspected:

* unrestricted general web search;
* the [Erdős Problems page for #700](https://www.erdosproblems.com/700) and
  its indexed discussion;
* [zbMATH Open](https://api.zbmath.org/v1/document/0401.10003), OpenAlex,
  Crossref, and the Semantic Scholar API;
* arXiv and primary publisher/DOI pages;
* [OEIS A091963](https://oeis.org/A091963);
* the current
  [Formal Conjectures Erdős 700 file](https://github.com/google-deepmind/formal-conjectures/blob/main/FormalConjectures/ErdosProblems/700.lean)
  and [PR #4197](https://github.com/google-deepmind/formal-conjectures/pull/4197);
* historical and modern binomial-gcd literature reached through title,
  citation, terminology, and author searches.

OpenAlex failed to index the known exact 1978 title in its exact-title filter,
Crossref results were noisy, Semantic Scholar returned HTTP 429, and zbMATH's
citing-record queries did not yield a usable citation set. These limitations
make the negative database result nonexhaustive. Direct access to the canonical
problem page was Cloudflare-blocked, so its current status was checked through
the indexed rendering. Full sections B31/B33 of the third edition of Guy were
not accessible; the two downloadable files found during audit were only
partial scans.

### 5.2 Query families

Representative exact queries, retained in the evidence ledger, were:

* exact target: `"min" "gcd(n" "binomial(n,k)" "n/P(n)"`,
  `"f(n)=n/P(n)" binomial coefficients gcd`, and
  `Erdos problem 700 binomial gcd largest prime factor characterization`;
* original source/citation path: the exact 1978 title,
  `Erdős Szekeres f(30)=6`, `f(210)=14 binomial`, and
  `"greatest prime power which divides n" f(n)`;
* equivalent formulations: `"n/gcd(n" binomial "divides k"`,
  `"gcd(n, binomial(n,k))" minimum`, `"smallest gcd" Pascal row binomial`,
  and `"complementary carry" binomial gcd`;
* distinctive frozen terms: `"BoundarySafe" "Erdos700"`,
  `"residueCarryCount" binomial`, `"CofactorObstructionSafe"`, and
  `"BoundedObstructionSafe" binomial`.

The four distinctive-term searches returned no indexed hits. The other query
families principally returned the original paper, the canonical open problem,
OEIS A091963, Bergman's related paper, and literature on **global gcds of
families** of binomial coefficients. No returned source supplied the frozen
iff or an immediate implication of it.

## 6. Source-by-source overlap analysis

### 6.1 Exact target and closest data sources

**Erdős–Szekeres (1978).** The paper has the same minimum operation but uses
the greatest exact prime-power component in its upper bound. It asks for the
equality cases and supplies witnesses/examples; it does not give a
classification. Its hypotheses and conclusion therefore do not imply the
modern largest-prime-factor iff, and the \(n=12\) calculation proves the two
targets are not interchangeable
([primary scan](https://www.renyi.hu/~p_erdos/1978-46.pdf)).

**ErdősProblems #700.** The canonical modern page gives exactly the largest
prime factor, the same range \(1<k\le n/2\), and the same equality question.
At audit time it labeled the problem open and listed no partial or complete
solution. That is the closest statement match, but an open-problem page has no
conclusion that could imply the candidate. The page itself cautions that its
status is not an exhaustive literature certification
([problem page](https://www.erdosproblems.com/700)).

**OEIS A091963.** The prose defines a smallest gcd between two interior
entries of a Pascal row; its Maple code computes
\(\min_k\gcd(n,\binom nk)\), the target data object up to the harmless
\(k=1\) term. The entry does not prove equivalence of those descriptions and
does not characterize equality with \(n/P(n)\). It is the closest indexed
equivalent-data lead, not an overlap theorem
([entry](https://oeis.org/A091963)).

**Formal Conjectures.** The current file encodes the modern target as open and
proves only the prime-power and two-prime special cases. Its existential
answer remains a placeholder; it contains no `BoundarySafe`, carry-obstruction,
\(P(n)^2\), or cofactor theorem. Its hypotheses match the target, but it has no
general conclusion implying the candidate
([source file](https://github.com/google-deepmind/formal-conjectures/blob/main/FormalConjectures/ErdosProblems/700.lean),
[PR #4197](https://github.com/google-deepmind/formal-conjectures/pull/4197)).

### 6.2 Classical method prior art

**Kummer, Lucas, Singmaster, and Granville.** Kummer's theorem says that
\(v_p\binom nk\) equals the number of base-\(p\) carries in
\(k+(n-k)=n\). Lucas gives the corresponding digitwise congruence framework.
Singmaster presents this prime and prime-power divisibility machinery
systematically, and Granville surveys/extensions modulo prime powers
([Kummer 1852](https://eudml.org/doc/147500),
[Singmaster 1980](https://www.fq.math.ca/Books/Collection/singmaster.pdf),
[Granville 1997](https://dms.umontreal.ca/~andrew/1997.php)).

These sources cover the frozen `residueCarryCount`, the full digit-shadow
conversion, and the prime-power witness method. They do **not** take the
ordinary numerical minimum of \(\gcd(n,\binom nk)\), select a simultaneous
minimal divisor above \(P(n)\), or conclude any of the frozen safety iff
statements. They overlap decisively in method, not theorem.

### 6.3 Related binomial-gcd theorems

A recurring distinction is essential. For a family \(a_k\), the global gcd
\(\gcd_k a_k\) takes the minimum valuation separately at each prime, possibly
at different indices. Erdős 700 takes the **ordinary integer minimum** of the
individual numbers \(\gcd(n,\binom nk)\). Those operations are not
interchangeable.

| Source | Source theorem: hypotheses and conclusion | Comparison with frozen candidate |
|---|---|---|
| Bergman, “On common divisors of multinomial coefficients” (2011) ([DOI](https://doi.org/10.1017/S0004972710001723), [preprint](https://escholarship.org/uc/item/4wm0f0fk)) | For \(2\le i\le j\le N/2\), gives lower bounds on \(\gcd(\binom Ni,\binom Nj)\); then treats common divisors of proper multinomial coefficients. | It compares two nontrivial row entries and gives a bound, rather than minimizing \(\gcd(\binom n1,\binom nk)\) and classifying equality with \(n/P(n)\). Neither conclusion implies the other. |
| Joris–Oestreicher–Steinig, “The greatest common divisor of certain sets of binomial coefficients” (1985) ([DOI](https://doi.org/10.1016/0022-314X(85)90013-7)) | Computes the gcd of consecutive blocks \(\binom nr,\ldots,\binom ns\). | A block gcd is a coordinatewise valuation minimum, not the candidate's numerical minimum. No largest-prime equality or simultaneous realization criterion is stated. |
| Kaplan–Levy, “GCD of truncated rows in Pascal's triangle” (2004) ([paper](https://math.colgate.edu/~integers/e14/e14.pdf)) | Factors \(\gcd\{\binom nt,\ldots,\binom n{n-t}\}\), using Kummer. | Different aggregate and range; it neither states nor immediately yields the frozen iff. |
| Ram/McTague full-row theorem ([McTague 2017 DOI](https://doi.org/10.4169/amer.math.monthly.124.4.353)) | The gcd of all interior entries is \(p\) when \(n\) is a power of \(p\), and 1 otherwise. | For non-prime-power composite \(n\), this global gcd can be 1 although each target pair gcd is greater than 1. This demonstrates why the aggregate cannot determine the target minimum. |
| McTague, restricted multiples (2018) ([arXiv:1510.06696](https://arxiv.org/abs/1510.06696)) | Fixes \(q\) and computes \(v_p\bigl(\gcd_{0<k<n/q}\binom n{qk}\bigr)\) under a congruence hypothesis on \(p\), in terms of base-\(p\) digit sums. | It establishes Kummer/digit prior art, but fixes a restricted global family and has no ordinary-minimum or `BoundarySafe` conclusion. |
| Hong, “The greatest common divisor of certain binomial coefficients” (2016) ([article](https://www.numdam.org/articles/10.1016/j.crma.2016.06.001/)) | For positive \(m,n\), computes the gcd of \(\binom{mn}k\) over indices with \(\gcd(k,m)=1\). | Upper argument, index restriction, aggregate operation, and formula all differ; no implication of the candidate was located. |
| Xiao–Yuan–Lin (2022) ([journal page](https://mta.csu.edu.cn/EN/Y2022/V42/I1/85)) | Computes a product formula for the gcd of the symmetric truncated set \(\{\binom nk:a<k<n-a\}\). | Again one global gcd, not the ordinary minimum of pairwise gcds with \(n\); no equality classification. |
| Chiu–Yuan–Zhou (2023) ([DOI](https://doi.org/10.4134/BKMS.b220166)) | Defines a central deletion threshold and computes valuations of a coprimality-restricted global gcd under digit hypotheses. | Different hypotheses and aggregate; only subject/method overlap. |
| Chung–Yang–Zhou (2025) ([DOI](https://doi.org/10.37256/cm.6120255017)) | Determines restricted-family gcds in cases controlled by base-\(p\) digit sums. | Uses Kummer but has no \(f(n)=n/P(n)\) or simultaneous-boundary conclusion. |
| Guo–Qiu–Cao–Feng–Gao (2026) ([arXiv:2606.22997](https://arxiv.org/abs/2606.22997)) | Fixes lower index \(k\), varies upper index \(qk\), and gives a largest-prime-power-component criterion for \(\gcd_q\binom{qk}k=1\). | Both the varying parameter and the global-gcd operation differ; it does not imply any frozen iff. |
| Wu (2026) ([arXiv:2606.20940](https://arxiv.org/abs/2606.20940)) | Studies \(g(m,n)=\gcd\{\binom{mn}{mk}:1\le k<n\}\) and its valuations. | This scaled-row global gcd has different parameters and conclusion. Its only material overlap is the Kummer carry method. |

### 6.4 Guy B31/B33

OEIS points to R. K. Guy, *Unsolved Problems in Number Theory*, §§B31 and
B33. The accessible primary Crux material identifies B31 with the fact that
two distinct interior entries in one Pascal row are never coprime; a library
contents record titles B33 “Largest divisor of a binomial coefficient.” Those
are divisibility/large-divisor problems, not an equality classification for
the target minimum
([Crux source](https://cms.math.ca/wp-content/uploads/crux-pdfs/Crux_v21n01_Jan.pdf),
[contents record](https://d-nb.info/969711492/04)). Because a complete third
edition was not accessible, this remains a source-access gap rather than a
claim that no nearby remark occurs anywhere in Guy.

## 7. Novelty determination

### 7.1 What was not found

No searched source supplied any of the following:

* a classification of all composite \(n\) satisfying the modern
  \(f(n)=n/P(n)\) equality;
* the simultaneous `Boundary`/`Realized` obstruction;
* an equivalent full digit-shadow classification;
* the canonical boundary-divisor interval \(P(n)<d\le P(n)^2\); or
* the cofactor-normalized finite rejection certificate.

The closest target-level sources are the canonical open page, the 1978
question with a different \(P(n)\), OEIS A091963, and the open Formal
Conjectures encoding. The closest theorem-level literature computes global or
restricted-family gcds, which is a semantically related but mathematically
different operation.

### 7.2 Why the method controls the classification

The carry valuation is the decisive bridge from binomial coefficients to the
frozen finite predicate. That bridge is exactly classical Kummer theory. The
remaining key steps—using the binomial recurrence to obtain \(W_n(k)\mid k\),
taking a divisibility-minimal divisor, proving \(d\le P(n)^2\) by deleting one
prime factor, and normalizing \(dm\le n/2\) by division—are elementary
order/divisibility constructions. I found no new analytic, algebraic, or
combinatorial machinery on which the result depends.

The theorem application/formulation appears absent from the searched record,
but the decisive route is established. The same assessment applies to v1–v3,
which are the identical theorem, and to v4–v8, which add cumulative
specializations or equivalent finite forms rather than a different proof
paradigm.

## 8. Correctness and interpretation concerns (separate from novelty)

1. **No host verification.** The host selector failed before Lean. Frozen
   local build and axiom logs are useful evidence for the encoded propositions
   but are not independent acceptance, statement alignment, or novelty
   evidence.
2. **Modern/historical mismatch.** The immutable target is the modern
   largest-prime-factor problem; it is not literally the 1978
   greatest-prime-power problem. Version 4 correctly treats the latter as a
   separate theorem with a prime-power exception, but any publication claim
   must preserve this distinction.
3. **Meaning of “characterize.”** `BoundarySafe` eliminates `f`, gcds, and
   binomial coefficients syntactically and is a finite decision predicate.
   By itself, `Realized` still searches for \(k=dm\), and `FullShadowSafe` can
   have a common period exceeding the original multiplier interval. The later
   `ExplicitG` development materially strengthens this presentation: it
   compiles the shared multiplier and all simultaneous Kummer budgets into one
   compact natural-linear integer/Boolean system with no row or disjunction
   for each multiplier value. The result is still not a closed
   factorization-family list, so whether that stronger optional form is the
   intended historical standard remains an external interpretation question.
4. **No silent repair.** I found no explicit logical counterexample while
   reading the frozen theorem and its evidence, but I did not alter any
   declaration or strengthen a missing argument. This audit is not an
   independent kernel replay or full proof referee report.
5. **Internal provenance.** The ledger says earlier retained campaigns already
   supplied substantial carry-antichain work and the historical
   specialization. That does not show public prior art, but later freezes
   should not be described as eight independently originated discoveries.

## 9. Residual uncertainty and expert follow-up

The negative search remains limited by terminology variation, inaccessible
citation graphs, Semantic Scholar throttling, the incomplete Guy scans, and
the absence of a subscription MathSciNet citation review. A domain expert
should next:

1. inspect the complete Guy B31/B33 text and MathSciNet/zbMATH forward
   citations to Erdős–Szekeres 1978;
2. ask specialists in Pascal-triangle divisibility whether A091963 has an
   unpublished or differently named equality classification;
3. compare the criterion against literature in the language of carry vectors,
   minimal divisors, antichains, and simultaneous valuation realization rather
   than only `f(n)` notation;
4. independently replay the exact frozen Lean sources in the pinned
   environment and separately referee the prose equivalence;
5. decide, before claiming the historical problem solved, whether a finite
   carry-search predicate meets the community's intended meaning of
   “characterize.”

## 10. Final novelty verdicts

| Frozen candidate | Novelty verdict |
|---|---|
| `411c6fe34a7dd135c83e16f6ac96c1f083334ddb8eb946f26683d2a4dc56f55b` | `known-method-new-application` |
| `f8f7ed71d558f4497b8ccfea3b7eb9455bcd0b4d4eddd4f4072d6bbbe1d07794` | `known-method-new-application` |
| `7339e9d636a5b1bec65ed61fd449ba03cba973afdb54ef2580ec05e789481ad8` | `known-method-new-application` |
| `9f451b6a9e4b7557425391d9d7faeceebd970b204b3e6d33d3b39ed032cdb243` | `known-method-new-application` |
| `75bf0b89363ceac0a89df3351ff603d546121ba193b7c33ce5e1eaf7baaa5780` | `known-method-new-application` |
| `9569872c989b401b2d6b6b7a7b69f902cac712655595112514d9c8c24b26c523` | `known-method-new-application` |
| `427371d54c255cd56e3496efe582509f902c30c49a09340fe80bff61c9b84ccd` | `known-method-new-application` |
| `3f603b2a8b609dc7adb5cad0e8acaa6b1e889c37525d8051e503afc04803ba87` | `known-method-new-application` |
