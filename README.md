# Nanocodex Erdős 700

This repository is the proof package and research record for an AI-assisted
attack on [Erdős Problem 700](https://www.erdosproblems.com/700). It contains:

[![Lean proof](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml/badge.svg)](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml)
[![Rust harness](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/rust.yml/badge.svg)](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/rust.yml)

- a complete kernel-checked solution of Part (i), covering both the maintained
  largest-prime statement and the original 1978 greatest-prime-power statement;
- a kernel-checked unconditional proof of Part (ii);
- the Nanocodex application and methodology used to discover, audit, and
  formalize those results;
- an explicit account of the unresolved obstruction in Part (iii), including
  the routes we tried and the counterexamples that killed them.

The repository separates proof completion from publication and priority.
Part (i) is solved here by exact finite iff characterizations; the Lean kernel
checks the encoded theorems, while independent review still decides novelty,
priority, exposition, and community acceptance.

## Read this repository in order

1. This page gives the problem, the two completed developments, and the open
   frontier.
2. [`proof/README.md`](proof/README.md) explains the promoted Lean package and
   how to verify it.
3. [`docs/research-map.md`](docs/research-map.md) maps every major route tried
   on Parts (i), (ii), and (iii), with outcomes and lessons.
4. [`docs/erdos700-iii-bottleneck-brief.md`](docs/erdos700-iii-bottleneck-brief.md)
   is the short technical handoff for new work on the open part.

The forensic run and session audits are linked from the research map. Readers
interested only in the mathematics do not need the Rust harness, raw runtime
artifacts, or the broader case catalog.

## Current status

For

\[
f(n)=\min_{1<k\le n/2}\gcd\left(n,\binom nk\right),
\]

the three subproblems currently stand as follows:

| Part  | Repository result | Evidence | Claim boundary |
| --- | --- | --- | --- |
| (i) | Complete exact finite characterizations for the maintained \(n/P(n)\) target and the original 1978 \(n/Q(n)\) target | Lean build, axiom audit, clean release rebuild, finite regression and statement audits | Solved internally; independent novelty, priority, and publication review remain external |
| (ii) | Infinitely many composite \(n\) satisfy \(f(n)^2>n\) | Complete natural proof, Lean build, axiom audit | Solved internally; independent novelty and community review remain external |
| (iii) | Open for \(A>1\) | Exact reductions, partial theorems, method counterexamples | No proof, disproof, or unconditional improvement beyond the classical \(D(n)\gg\log n\) scale |

Here \(P(n)\) is the largest prime factor used by the maintained problem page.
The 1978 paper instead uses \(Q(n)\), the greatest exact prime-power component
of \(n\); the repository proves both non-equivalent formulations. See
[the canonical status and claim boundaries](docs/status.md) before quoting a
result.

## The two completed developments

### Part (i): complete solution by exact finite characterization

For every composite \(n>1\), the Lean development proves

```lean
Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

and compiles `BoundarySafe` into an explicit finite system of selector,
prime-power, prefix-product, digit, and borrow constraints. The compiler
theorem proves that the finite system has neither false positives nor false
negatives relative to the semantic factor tableau.

For the literal 1978 definition

\[
Q(n)=\max_{p\mid n}p^{v_p(n)},
\]

the checked historical theorem is

```lean
Erdos700.f n = n / Erdos700.Q n ↔
  ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n
```

The release also proves equivalent full-digit-shadow, bounded-obstruction,
cofactor-normalized, divisor-poset, factor-tableau, and explicit
integer/Boolean forms. Thus “characterization” describes the form of the
solution; it is not a partial-result label.

- [Part (i) overview and scope](proof/PartIWork/report.md)
- [Recovered complete release record](docs/part-i-release/README.md)
- [Every recovered Part (i) run and what it contributed](docs/part-i-run-coverage-audit.md)
- [Original 1978 statement and theorem](docs/part-i-release/historical-characterization-report.md)
- [Independent novelty audit](docs/part-i-release/novelty-audit.md)
- [Human-readable boundary-antichain proof](proof/PartIWork/boundary-antichain.md)
- [Superseded intermediate structural audit](proof/PartIWork/STRUCTURAL_UPGRADE.md)
- [Public Lean verification surface](proof/PartIVerify.lean)

The broader [`dev-georgios` reconciliation](docs/dev-georgios-reconciliation.md)
records what was promoted, what remains raw provenance, and where the separate
Nanocodex runtime patch was preserved.

### Part (ii): an unconditional infinite family

The Lean development proves

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

The proof uses the prime number theorem to construct nearby primes
\(p<q<r\) with asymmetric gaps. A Lucas-theorem argument proves that every
legal row retains at least two primes, so \(f(pqr)=pq>\sqrt{pqr}\).

- [Lean project and verification](proof/README.md)
- [Complete mathematical proof](proof/docs/proof.md)
- [Statement alignment audit](proof/docs/statement-audit.md)
- [Research and formalization methodology](docs/methodology.md)

## Part (iii): where the proof stops

Put

\[
D_n(k)=\frac{n}{\gcd(n,\binom nk)},\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

Part (iii) is equivalent to proving, for every fixed \(A>0\),

\[
D(n)\ge c_A(\log n)^A
\]

for every composite \(n\), after absorbing finitely many small cases. The
classical largest-component argument gives only \(D(n)\gg\log n\).

Our work has reduced and mapped the missing same-row synchronization problem,
but has not crossed that \(A=1\) barrier. Fixed multiplier menus, naive
iteration, independent carry probabilities, abstract set cover, and several
pairwise Lucas and Carmichael reductions all have rigorous failure
certificates.

- [Technical Part (iii) bottleneck](docs/erdos700-iii-bottleneck-brief.md)
- [All-parts attempt and lesson map](docs/research-map.md)
- [Detailed exploration tree and result ledger](docs/part-iii-exploration-map.md)
- [Canonical status and evidence labels](docs/status.md)
- [Part (iii) campaign prompt index](campaigns/problems/README.md)

The current acceptance gate is deliberately strict: a new campaign counts as
progress only if it beats \(D(n)\gg\log n\) by an explicit unbounded factor,
proves the \(A=2\) case, or constructs an infinite counterfamily to such a
uniform statement.

## Reproducing the proofs

The pinned Lean project lives under `proof/`.

```sh
cd proof
./scripts/verify.sh
./scripts/verify-part-i.sh
```

The scripts build the relevant roots, reject `sorry` and `admit`, inspect
axiom dependencies, and run the Part (i) finite regression audit. CI runs the
same proof gates.

## Nanocodex research harness

This is also a normal Rust crate using Nanocodex as a library. The application
owns the research policy: problem freezing, route portfolios, retained worker
reports, exact jobs, candidate freezing, verification, and failure-aware
continuation.

The retained harness currently needs a Nanocodex `0.3.0` API migration before
these entry points build against a fresh `../nanocodex-latest`; see the
[harness compatibility status](harness/README.md#compatibility-status). This
does not affect the independent Lean proof package.

```sh
cargo build --release --bin nanocodex-erdos --bin research-loop
./harness/run-erdos700-loop.sh i
./harness/run-erdos700-loop.sh iii
```

Generated campaigns live under ignored `runs/` directories. They are evidence,
not the public API of the repository. Start with the
[harness guide](harness/README.md) for architecture, environment, and
operational details.

## Repository map

```text
proof/          Lean proofs and their mathematical/statement audits
docs/           status, all-parts research map, methodology, and Part (iii) ledger
campaigns/      frozen problem packages and research prompts
harness/        application runbooks, runtime lessons, and tool contracts
src/            Rust Nanocodex research application
experiments/    bounded falsification and game-selection instruments
cases/          broader AI-for-science case catalog
methods/        reusable research and verification methods
prompts/        reusable prompt patterns
architecture/   application and state-management design
data/           normalized case catalog and schema
sources/        primary-source index
runs/           ignored runtime workspaces
```

The broader AI-for-science knowledge base remains available in `cases/`,
`methods/`, `prompts/`, and `sources/`, but the repository front door is now
organized around Erdős 700 and the evidence produced here.

## Epistemic policy

- “Kernel-checked” means Lean accepted the encoded proposition with the
  reported dependency set.
- “Proved partial” means a complete mathematical lemma was obtained, but not
  the original target.
- “Method counterexample” refutes an auxiliary strategy, not Erdős 700.
- “Conditional reduction” is not progress unless its hypotheses are proved
  uniformly and are demonstrably easier than the original target.
- “Solved internally” means the repository contains a complete checked proof
  of the exact statement. Novelty, priority, publication, and community
  disposition remain separate external judgments.

## License

MIT or Apache-2.0.
