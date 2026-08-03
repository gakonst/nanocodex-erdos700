# Erdős Problem 700(iii): concentrated breakthrough campaign

## Immutable target

For

```text
f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k)),
```

prove or disprove the exact uniform statement

```text
for every real A > 0, there is C_A > 0 such that
for every composite n > 1,
f(n) <= C_A * n / (log n)^A.
```

The constant may depend on `A` but not on `n`. A density-one result, a fixed
number of prime factors, one fixed `A`, or finite computation is partial. A
disproof must fix one `A > 0` and construct an unbounded family on which no
constant works.

This is a concentrated continuation, not a fresh generic survey.

## Mandatory recovery

Before assigning work, use `inspect_research_artifacts` and read every retained
worker report and exact-job result in:

```text
math-1784843263-47602/
```

especially:

- `worker-reports/agent-1-erdos-szekeres-reconstructor.md`;
- `worker-reports/agent-2-padic-structuralist.md`;
- `worker-reports/agent-7-extremal-factorization.md`;
- `worker-reports/agent-9-compatibility-hypergraph-specialist.md`;
- `worker-reports/agent-10-smooth-carry-entropy-specialist.md`;
- `worker-reports/agent-11-high-order-giuga-specialist.md`;
- `primorial-pilot/results.json`;
- `monotonicity/results.json`;
- `giuga-allk-verification/results.json`.

Read the other retained reports too. Never inspect any `events.jsonl`.

Also read the checked part-(ii) and part-(i) structural machinery:

- `proof/PartIWork/BoundaryAntichain.lean`;
- `proof/PartIWork/boundary-antichain.md`;
- `proof/Assembly.lean`;
- `proof/FEquality.lean`;
- `proof/StructuralWork/`;
- `proof/Solution.lean`.

Do not repeat a route already killed by a retained counterexample.

## Checked state to build from

Write

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n) = max_{2 <= k <= n/2} D_n(k).
```

The target is equivalent, up to explicit small exceptions, to

```text
for every A > 0, D(n) >= c_A (log n)^A.
```

The retained campaign established or sharply justified:

1. `D_n(k) | gcd(n,k)`.
2. If `q=p^a || n` and `n` is not a prime power, then `D_n(q)=q`.
3. Prime powers satisfy `f(p^a)=p`.
4. The target holds for `0 < A <= 1`, for bounded `omega(n)`, and whenever
   the largest exact prime-power component is at least `(log n)^A`.
5. In the hard regime, for every fixed `R`, the top `R` exact components are
   eventually at least `log(n)/12`.
6. Full simultaneous omission of selected components is an exact
   multi-base Lucas condition. Pairwise compatibility does not imply joint
   compatibility (`n=210`), naive witness multiplication fails (`n=30`),
   useful witnesses need not divide `n` (`n=858`), and partial prime-power
   layers can be essential (`n=72`).
7. The bounded-depth full-component correlation assertion `(BD)` in the
   retained smooth-carry report is sufficient but unproved; marginal entropy,
   ordinary CRT, and an off-the-shelf local lemma do not prove it.
8. The exact extremal reformulation is:

   ```text
   H(x) = max {log n : n composite and D(n) <= x};
   target iff for every epsilon > 0, H(x) = O_epsilon(x^epsilon).
   ```

   For non-prime-powers with `D(n) <= x`, `n | lcm(1,...,x)`, but the sublevel
   set is not monotone in the divisor lattice.
9. The global higher-order Giuga route is impossible: if squarefree composite
   `n/p = 1 mod p^h` for every `p|n`, then `h=1`.
10. A concrete hard family exists:
    `n_M = binomial(2M,M)` has every exact component `O(log n_M)`.

These are starting evidence, not permission to assume any unproved
compatibility conjecture.

## Required breakthrough portfolio

Launch a clean batch of the following independent roles. Use all available
concurrency. Each worker must return a theorem with hypotheses and proof, a
counterexample family with proof, or the smallest exact obstruction.

1. **Partial-layer probabilist.** Abandon binary “omit a full component”
   language. Starting from

   ```text
   v_p(D_n(k)) =
     [min(v_p(n),v_p(k)) - H_p(n,k)]_+,
   ```

   seek an expectation, second-moment, entropy, or averaging argument for the
   aggregate weight `log D_n(k)` over a deliberately chosen distribution on
   admissible `k`. Account for dependence across bases. The goal is one
   `k` with aggregate saving, even when no large set of full components is
   jointly omitted.

2. **Additive-combinatorics/zero-sum specialist.** Attack the top-component
   compatibility hypergraph using minimal zero-sum sequences, Olson/Davenport
   type bounds, containers, dependent random choice, or a genuinely relevant
   hypergraph theorem. Either prove a fixed-size edge among sufficiently many
   comparable components or construct a scalable nonedge hypergraph
   consistent with a single integer `n`. Pairwise graph Ramsey is already
   refuted.

3. **Recursive-repair architect.** Start from the exact failure of naive
   witness multiplication. Develop an adaptive recursion or density-increment
   scheme in which a multiplier repairs the new base while preserving a
   quantified fraction of previous `p`-adic weight. Prove a multi-step
   invariant strong enough for arbitrary fixed logarithmic power, or return a
   finite obstruction showing why every such invariant must lose too much.

4. **Extremal-lcm specialist.** Work on the exact statement
   `H(x)=x^{o(1)}`. Use the fact that `n | lcm(1,...,x)` together with the
   boundary-antichain/feasible-pair characterization. Seek a structural
   counting, compression, forbidden-configuration, or container argument
   showing that any divisor with `log n > x^epsilon` realizes a weight
   exceeding `x`. Do not assume monotonicity.

5. **Hard-family analyst.** Analyze
   `n_M = binomial(2M,M)` and other provably all-component-smooth families
   symbolically. Either prove super-polylogarithmic `D(n_M)` through an
   explicit witness mechanism that plausibly generalizes, or turn the family
   into a rigorous disproof sequence. Small computations may test a specific
   formula, but a larger census is not a result.

6. **Hostile-family constructor.** Try to make the isolated-component
   construction `p^a(p^L+1)`, Zsigmondy factors, CRT digit hostility, or
   related recurrences hostile for *all* components and all admissible `k`.
   You must simultaneously prove smoothness of every new exact component and
   a uniform upper bound on `D(n)`. Otherwise record precisely where other
   components force a large witness.

7. **Theorem-transfer scout.** Re-read the 1978 Erdős--Szekeres proof and
   search primary literature for later theorems whose actual quantitative
   hypotheses imply an iterated logarithmic saving: simultaneous Lucas
   conditions, binomial gcds, smooth divisors, carry statistics, zero-sum
   sequences, or divisors of lcm. Give exact citations and verify the theorem
   statements. The lead performs current web search and supplies URLs.

8. **Blind proof/counterproof closer.** Ignore the favored full-component
   route. Attempt the original statement from scratch using the retained exact
   identities only. Spend the report closing one load-bearing chain, not
   listing speculative ideas.

After the first batch, synthesize conflicts and use retained follow-up turns
on the two most promising workers. At least one follow-up must be an
adversarial attempt to falsify the best candidate lemma.

## Inference and computation policy

Model inference is the main compute. Do not launch a generic census or merely
increase prior bounds. A computation is allowed only when it tests a named
symbolic claim, has an enriched family, and has a decision rule that changes
the proof route. Preserve resumable compact checkpoints.

The existing exact jobs already rule out naive monotonicity, naive
full-component iteration, and high-order Giuga. Do not spend jobs repeating
them.

## Completion and formalization

If a complete mathematical candidate appears:

1. write a complete `research-note.md` with every constant and small exception;
2. launch independent correctness, quantifier, and novelty audits;
3. formalize the exact theorem in `solution.lean` using the pinned Lean
   environment;
4. reject `sorry`, `admit`, local axioms, unsafe bypasses, and
   `Erdos700.erdos_700.parts.iii`;
5. retain `compile.log` and `axioms.log`;
6. freeze the candidate and run the configured verifier.

The exact Lean result is:

```lean
answer(True) ↔
  (∀ A : ℝ, 0 < A → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
    ¬ n.Prime → 1 < n →
      (Erdos700.f n : ℝ) ≤ C * (n : ℝ) / (Real.log n) ^ A)
```

or the same proposition with `answer(False)`.

If the complete target is still blocked, do not bluff. Return the strongest
new theorem, a proof-quality failure certificate for the best global route,
and one exact next lemma. But use the available lead turns and worker budget
to push that lemma before declaring blockage.
