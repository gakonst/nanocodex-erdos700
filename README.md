# Erdős Problem 700

This repository contains a complete Lean-checked proof of Part (ii),
Lean-checked exact feasibility criteria for Part (i), and the research
frontiers for the stricter direct classification in Part (i) and for Part
(iii) of [Erdős Problem 700](https://www.erdosproblems.com/700).

[![Lean proofs](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml/badge.svg)](https://github.com/gakonst/nanocodex-erdos700/actions/workflows/lean.yml)

| Part | Status | Read | Verify |
| --- | --- | --- | --- |
| (i) | **Exact finite criterion, Lean-checked** for both formulations; a direct prime-factor classification remains open | [Compiled exact-criterion proof](part-i-complete-solution.pdf) | [`lean-part1/`](lean-part1/README.md) |
| (ii) | **Complete unconditional proof** of infinitely many composite $n$ with $f(n)^2>n$; no novelty or priority claim | [Compiled proof](part-ii-infinite-family.pdf) | [`lean-part2/`](lean-part2/README.md) |
| (iii) | **Open** for every fixed exponent $A>1$ | [Compiled frontier report](part-iii-frontier.pdf) | [`lean-part3/`](lean-part3/README.md) |

The [research map](MAP.md) records the successful paths, failed approaches,
counterexamples to methods, and the surviving Part (i) and Part (iii)
bottlenecks. Everything
operational or historical—including the Nanocodex harness, campaigns, prompts,
run audits, old proof packaging, and TeX sources—is retained under
[`archive/`](archive/README.md).

## Problem

For composite $n$, define

$$
f(n)=\min_{2\le k\le n/2}\gcd\!\left(n,{n\choose k}\right).
$$

The three questions are:

1. Characterize the composite $n$ for which $f(n)=n/P(n)$, where $P(n)$ is
   the largest prime divisor. The 1978 source instead uses the greatest exact
   prime-power component. Part (i) here proves exact finite iff criteria for
   both non-equivalent versions, but not yet the requested direct taxonomy.
2. Prove that $f(n)>\sqrt n$ for infinitely many composite $n$.
3. Decide whether, for every $A>0$, there is a constant $C_A$ such that

$$
f(n)\le C_A\frac{n}{(\log n)^A}
$$

   for every composite $n$.

## What the checked developments establish

Part (i) reduces equality to the absence of a minimal carry obstruction and
then compiles simultaneous realization across all relevant prime bases into
one finite selector/prefix/digit/borrow system $G(F,B)$. For an ordered exact
factorization $F$ of $n$, Lean proves the full chain giving

$$
f(n)=\frac{n}{P(n)}
\quad\Longleftrightarrow\quad
\neg G(F,P(n)).
$$

The compiler uses one shared multiplier and does not enumerate every possible
row. This is an exact compact feasibility encoding, but it still asks whether
that symbolic multiplier can satisfy all prime-base conditions. It therefore
does not yet meet the stricter request for a direct classification readable
from the prime factorization without solving a bespoke feasibility problem.
The historical $Q(n)$ theorem uses the same system with the necessary
composite-prime-power exception. The precise remaining obligation and failed
shortcuts are recorded in the
[direct-classification audit](archive/docs/part-i-direct-classification/research-report.md).

Part (ii) constructs nearby primes $p<q<r$ using the prime number theorem. A
Lucas-theorem argument proves that every legal row retains at least two of the
three primes, while the row $k=r$ gives the matching witness. Hence
$f(pqr)=pq>\sqrt{pqr}$ for infinitely many triples.

Part (iii) remains open. The exact weighted carry reduction and all retained
partial results are in the [frontier PDF](part-iii-frontier.pdf); the complete
attempt ledger is in [`map/part-3.md`](map/part-3.md).

## Reproduce the checked results

Each checked development is an independent pinned Lake project:

```bash
(cd lean-part1 && ./scripts/verify.sh)
(cd lean-part2 && ./scripts/verify.sh)
```

Both scripts reject local proof placeholders, build the complete dependency
closure, print the final theorem dependencies, and reject `sorryAx`. Part (i)
also runs an independent finite regression audit through $n=1000$.

## Repository layout

```text
README.md                       this page
part-i-complete-solution.pdf    proof of the exact Part (i) feasibility criterion
part-ii-infinite-family.pdf     complete Part (ii) proof
part-iii-frontier.pdf           open Part (iii) research report
lean-part1/                     end-to-end Lean project for Part (i)
lean-part2/                     end-to-end Lean project for Part (ii)
lean-part3/                     explicit open-status handoff
MAP.md                          short research tree
map/                            detailed ideas, attempts, and lessons
archive/                        harness, campaigns, sources, history, TeX
```

Lean acceptance proves the encoded propositions. Novelty, priority,
interpretation, and community acceptance are separate questions.
