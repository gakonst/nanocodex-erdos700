# Erdős Problem 700(iii): arbitrary logarithmic saving

## Immutable target

For

```text
f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k)),
```

prove or disprove:

```text
for every real A > 0, there is C_A > 0 such that
for every composite n > 1,
f(n) <= C_A * n / (log n)^A.
```

The constant may depend on `A` but not on `n`. A proof for density-one
integers, squarefree integers, a fixed number of prime factors, or one value of
`A` is partial. A counterexample must negate the uniform statement for one
fixed positive `A`, not merely produce large finite ratios.

## Current status and pinned sources

The canonical page still marked this question open on 23 July 2026 and records
the Erdős--Szekeres bound

```text
f(n) <= (1 + o(1)) * n / log n.
```

Pinned sources:

- <https://www.erdosproblems.com/700>
- <https://www.erdosproblems.com/forum/thread/700>
- Erdős--Szekeres (1978):
  <https://www.renyi.hu/~p_erdos/1978-46.pdf>
- Formal Conjectures statement:
  <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean>

Perform a new primary-source search. Do not confuse this function with the
different binomial-coefficient function in Erdős Problem 684.

## What part (ii) contributes

Read:

- `proof/docs/proof.md`
- `proof/Assembly.lean`
- `proof/FEquality.lean`
- `proof/StructuralWork/`
- `proof/Solution.lean`

The part-(ii) construction gives `n = p*q*r` with comparable primes and
`f(n)=p*q`, hence `f(n)` is of order `n^(2/3)`. This is compatible with the
target because, for each fixed `A`,

```text
n^(2/3) = o(n / (log n)^A).
```

It is therefore neither a counterexample nor a direct proof. Its useful
content is the omission viewpoint: `f(n)` is controlled by finding one
admissible `k` whose binomial coefficient omits enough prime-power mass from
`n`.

## Discovery policy

Inference is the main compute. Reconstruct the original `A = 1` proof before
trying to iterate it. Build both proof and disproof portfolios.

Priority proof routes:

1. **Rough/smooth dichotomy.** If `P(n)` is large, seek a witness giving
   `f(n) <= n/P(n)` or a comparable saving. If all prime factors are small,
   use many available p-adic digit/carry constraints to omit a product larger
   than any prescribed power of `log n`.
2. **Iterated witness construction.** Determine whether the 1978 witness can
   be applied at several scales without incompatible conditions on the same
   `k`.
3. **Probabilistic/CRT selection of k.** Choose an admissible `k` whose base-p
   digits force simultaneous low valuations for a controlled collection of
   prime powers; prove positive probability or construct it by a sieve.
4. **Entropy of carry patterns.** Show that the interval
   `2 <= k <= n/2` contains a digit pattern omitting sufficient prime-power
   mass, with uniform constants.
5. **Reduction to an extremal factorization theorem.** Identify the
   factorizations maximizing `f(n)/n` and prove they already have
   super-polylogarithmic saving.

Priority disproof routes:

1. Search for a structured sequence with
   `f(n)/n >= 1/(log n)^B` for some fixed `B`.
2. Examine smooth, primorial, high-prime-power, and tightly clustered
   factorizations; use exact computation only to infer a scalable obstruction.
3. Attack every local-to-global step in a proof candidate, especially
   simultaneous congruence and carry compatibility.

Do not spend the campaign on a generic census. Every nontrivial exact job must
state a mathematical hypothesis, an enriched family, both decision outcomes,
the smallest pilot, checkpoint policy, and kill rule.

## Required audits

- Exact dependence of `C_A` on `A`; no dependence on `n`.
- Uniform treatment of all composite integers and small exceptions.
- Logarithm domain, positivity, and real/natural coercion audit.
- Quantifier-order audit.
- Separate asymptotic, p-adic, counterexample, statement-alignment, and novelty
  reviewers.
- Lean dependency and placeholder audit for any formal result.

## Completion artifact

If true, write a complete proof of the exact uniform statement. If false,
write one fixed `A > 0` and an unbounded counterexample family proving that no
constant `C_A` works.

Required files:

- `research-note.md`: complete proof or disproof;
- `route-map.md`: all attempted mechanisms and concrete failure certificates;
- `source-audit.md`: literature searches, primary sources, and closest prior
  result;
- `statement-audit.md`;
- `candidate.json`: exactly `{"answer":"true"}` or
  `{"answer":"false"}`;
- `solution.lean`: define `Campaign.result` with exactly the corresponding
  type

  ```lean
  answer(True) ↔
    (∀ A : ℝ, 0 < A → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
      ¬ n.Prime → 1 < n →
        (Erdos700.f n : ℝ) ≤ C * (n : ℝ) / (Real.log n) ^ A)
  ```

  or the same type with `answer(False)`;
- `compile.log` and `axioms.log`.

Do not use `sorry`, `admit`, new axioms, or
`Erdos700.erdos_700.parts.iii`. If blocked, return the strongest uniform bound
proved, the largest class covered, and the single precise global obstruction.
