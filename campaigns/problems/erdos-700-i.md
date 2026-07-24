# Erdős Problem 700(i): characterize every equality case

## Immutable target

For

```text
f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k))
P(n) = the largest prime factor of n,
```

give an explicit, mathematically informative characterization of every
composite integer `n > 1` satisfying

```text
f(n) = n / P(n).
```

The characterization must be an iff theorem with a predicate stated
independently of `f(n) = n / P(n)`. A tautological rename, a decision procedure
that simply recomputes every binomial coefficient, an infinite family, or a
classification only for squarefree numbers does not solve the target.

## Current status and pinned sources

The canonical page still marked the characterization open on 23 July 2026:

- <https://www.erdosproblems.com/700>
- <https://www.erdosproblems.com/forum/thread/700>
- Erdős--Szekeres (1978):
  <https://www.renyi.hu/~p_erdos/1978-46.pdf>
- Formal Conjectures statement at the pinned commit:
  <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean>

The site warns that its open label is not a literature guarantee. Perform a
fresh primary-source and citation-neighborhood audit before claiming novelty.

## New foothold from the solution of part (ii)

Read these artifacts before opening new routes:

- `proof/README.md`
- `proof/docs/proof.md`
- `proof/FEquality.lean`
- `proof/StructuralWork/Combined.lean`
- `proof/Solution.lean`
- `docs/methodology.md`

The checked work proves an exact-value mechanism for structured prime triples.
For primes `p < q < r`, a uniform lower bound

```text
p*q <= gcd(p*q*r, binomial(p*q*r,k))
```

for every relevant `k`, together with the witness `k = r`, yields

```text
f(p*q*r) = p*q = (p*q*r) / P(p*q*r).
```

The Lucas omission lemmas provide this lower bound for an unbounded family of
nearby asymmetric prime triples. Treat this as structural data for the full
classification, not as the classification itself.

Also use the previously known anchors:

- products of two primes are equality cases;
- for prime powers `p^a`, `f(p^a)=p`, so equality holds exactly at `a=2`;
- `n=30` is a further classical example.

## Retained evidence from the interrupted first campaign

The first live portfolio was interrupted by a transport watchdog before its
workers could synthesize reports. Import only its compact checked artifacts;
never inspect any `events.jsonl`:

- `runs/math-1784840756-35224/exact-jobs/job-1.json` tested 15,180 squarefree
  prime triples. A pair-omission criterion selected 1,673 equality cases and
  agreed with direct binomial/gcd evaluation on 100 manageable triples.
- `runs/math-1784840756-35224/exact-jobs/job-3.json` found the first squarefree
  three-prime obstruction `n=78`, `k=39`. Independent recomputation in
  `runs/math-1784840756-35224/operator-note-n78.md` proves
  `gcd(78, binomial(78,39))=2`, hence `f(78)=2<6=78/P(78)`. Lucas digit
  containment simultaneously omits `3` and `13`.

Treat `n=78` as a mandatory regression test. Repair and formalize the exact
squarefree-triple pair-omission iff before proposing the all-composite
generalization.

## Discovery policy

Inference is the primary compute. Start from Kummer/Lucas and the complete
prime-power factorization

```text
n = product p_i ^ a_i.
```

Derive a finite structural object that records which prime-power factors can be
simultaneously absent from `binomial(n,k)` for `1 < k <= n/2`. Search for an
iff criterion in terms of digit containment, carry patterns, factorization
geometry, or a minimal admissible omission hypergraph.

Run genuinely different routes:

1. **Exact p-adic characterization.** Express every
   `v_p(gcd(n, binomial(n,k)))` using Kummer carries and identify the condition
   forcing the numerical minimum to equal `n/P(n)`.
2. **Omission hypergraph.** Generalize the pair-omission method from part (ii)
   to all prime-power factors and characterize when every admissible omission
   pattern has gcd at least `n/P(n)`, with one attaining equality.
3. **Minimal counterexample.** Assume a proposed classification fails and use
   the smallest factorization/digit obstruction to repair it.
4. **Factorization strata.** Completely solve prime powers, semiprimes,
   squarefree triples, and then test what invariant survives at four primes or
   repeated exponents.
5. **Theorem composition and literature.** Reconstruct the 1978 argument and
   search later work for equivalent carry or divisibility classifications.

Small exact computations may map equality cases for bounded factorizations or
falsify a proposed iff. Before every computation record its hypothesis,
enriched search family, decision rule, smallest pilot, and stopping rule. A
larger census is not a route change.

## Required audits

- Quantifier and boundary audit for every `1 < k <= n/2`.
- Numerical-order versus divisibility audit: `f` is a numerical minimum of
  gcd values, so componentwise p-adic minima cannot be interchanged without
  proof.
- Repeated-prime-power and small-`n` audit.
- Fresh agents for necessity, sufficiency, counterexamples, statement
  alignment, and novelty.
- Exact checks of every claimed finite reduction.

## Completion artifact

Write:

- `characterization.md`: one explicit iff theorem and complete proof;
- `necessity.md` and `sufficiency.md`: independently auditable directions;
- `examples.md`: recovery of semiprimes, prime squares, `30`, and the new
  unbounded `p*q*r` family;
- `literature-audit.md`: searches, primary sources, and closest prior result;
- `statement-audit.md`: proof that the predicate is non-tautological and
  answers the historical question;
- `solution.lean`: a direct formal theorem defining the explicit predicate and
  proving its equivalence to
  `Erdos700.f n = n / Erdos700.P n` for every composite `n > 1`;
- `compile.log` and `axioms.log`.

Do not use `sorry`, `admit`, new axioms, or
`Erdos700.erdos_700.parts.i`. If the complete characterization is not reached,
return the strongest fully proved factorization stratum and the single exact
missing lemma needed for the general case.
