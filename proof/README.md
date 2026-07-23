# A Lean proof of Erdős Problem 700(ii)

This repository contains a kernel-checked Lean 4 proof of the affirmative
answer to part (ii) of [Erdős Problem 700](https://www.erdosproblems.com/700).

For

\[
f(n)=\min_{1<k\le n/2}\gcd\left(n,\binom nk\right),
\]

the theorem proves that there are infinitely many composite \(n\) for which
\(f(n)>\sqrt n\). In the exact natural-number encoding used by the pinned
Formal Conjectures dependency:

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

The Erdős Problems site still listed the problem as open when this development
was completed. This repository presents the proof for independent mathematical
and formal review; it does not claim that the result has already been
adjudicated by the problem maintainers.

## Proof idea

The proof uses the prime number theorem rather than a computational search.

For a large integer \(T\), consider the primes in
\((8T^3,16T^3]\) and divide the interval into \(8T^2\) boxes of length
\(T\). The PNT shows that some box contains more than
\(\lfloor\log_2 T\rfloor+2\) primes. A finite gap argument then produces
three primes

\[
p<q<r,\qquad q-p<r-q,\qquad r-p<T.
\]

Writing \(a=q-p\) and \(c=r-q\), these primes satisfy
\(0<a<c\) and

\[
4(a+c)^3<p.
\]

A Lucas-theorem analysis of \(\binom{pqr}{k}\) proves that, for every
\(1<k\le pqr/2\), at least two of \(p,q,r\) divide the binomial
coefficient. Consequently

\[
f(pqr)^2>pqr.
\]

The construction gives unbounded values of \(pqr\), hence infinitely many
examples. See [the mathematical proof](docs/proof.md) and the
[statement audit](docs/statement-audit.md) for the full argument and boundary
checks. The [methodology case study](../docs/methodology.md) explains how the
Nanocodex research harness selected, developed, audited, and formalized the
result.

## Verification

The project pins:

- Lean `v4.27.0`;
- Formal Conjectures `e751934294a381afd2d5fc1124c5953c8e25f9fa`;
- PrimeNumberTheoremAnd `00737ce40d3ba12a58e63d7eca65563fb9860f7c`;
- Mathlib `a3a10db0e9d66acbebf76c5e6a135066525ac900`.

With `elan`, `git`, and `curl` installed:

```sh
./scripts/verify.sh
```

The first run downloads the pinned dependencies and Mathlib cache. The
verification script builds the complete root module, rejects proof
placeholders in this repository, and checks Lean's reported dependency set for
the final theorem. The expected result is:

```text
'Erdos700PNT.erdos_700_ii' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

In particular, the theorem does not depend on `sorryAx` or on the upstream
open-conjecture wrapper.

The included Nix development shell supplies the command-line dependencies:

```sh
nix develop
./scripts/verify.sh
```

GitHub Actions runs the same verification on every push and pull request.

## Repository map

- `Solution.lean` assembles the exact infinitude theorem.
- `Erdos700PNT.lean` is the root build and dependency-audit module.
- `PNTWork/` proves the required prime-counting lower bound.
- `DominanceWork/` closes the asymptotic inequality used by interval packing.
- `PackingWork/` extracts an asymmetric triple of nearby primes.
- `StructuralWork/` contains the Lucas-theorem omission arguments.
- `Assembly.lean`, `FEquality.lean`, and `Reduction.lean` turn the structural
  facts into the exact target.
- `docs/` contains the human-readable proof and statement audit.
- `../docs/methodology.md` records the Nanocodex-assisted research process and
  attribution boundary.

## License

Apache-2.0.
