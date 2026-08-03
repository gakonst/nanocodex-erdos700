# Erdős 700(iii): squarefree comparable-cluster incidence

## Exact objective

For

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n) = max_{2 <= k <= n/2} D_n(k),
```

attack the squarefree many-component core of Erdős 700(iii).

Recover all non-event artifacts from:

```text
runs/math-1784843263-47602/
runs/math-1784854035-150609/
```

Never inspect an `events.jsonl`. In particular retain:

- the exact full-component Lucas-shadow criterion;
- the fact that pairwise compatibility does not imply joint compatibility;
- the exact `n=210` result: compatible pairs exist but no compatible triple;
- the isolated-component classification
  `p || n isolated iff n/p = p^s + 1` in its proved range;
- the failure of uniform first-moment averaging.

## Target lemma: SCLO

Prove or refute the following squarefree cluster Lucas-overlap statement.

For every integer `r >= 2` and real `B > 1`, there are integers `H` and
`N_0` such that every squarefree `n >= N_0` having at least `H` prime
divisors in one interval `(X,2X]`, where

```text
log(n)/12 < X <= (log n)^B,
```

admits an integer `2 <= k <= n/2` for which at least `r` of those primes
divide `D_n(k)`.

Equivalently, for

```text
S_p = { k : p | k and k/p is a Lucas digit-shadow of n/p in base p },
```

prove that sufficiently many comparable sets `S_p` have a nonempty
`r`-fold intersection.

A uniform proof for every fixed `r` closes the squarefree hard regime by
choosing `r` as a function of the desired logarithmic power. A refutation
must construct a scalable family consistent with one integer `n`, not an
abstract hypergraph.

## Independent roles

1. **Exact incidence algebraist.** Derive exact sizes, intersections, and
   codegrees for the sets `S_p`, including the half-interval reflection.
   Start with an audited formula for the second factorial moment
   `E[binom(X(k),2)]`.
2. **Isolation-to-codegree specialist.** Upgrade the exact isolated-prime
   classification into a lower bound on the number or diversity of additional
   witnesses, then determine what extra hypothesis forces shared witnesses.
3. **Realizable hypergraph specialist.** Apply zero-sum, container, dependent
   random choice, sunflower, or Ramsey machinery only after proving that its
   hypotheses hold for Lucas-shadow hypergraphs arising from one `n`.
4. **Biased-distribution specialist.** Abandon uniform `k`. Construct a
   divisibility-biased distribution and estimate factorial moments or rare
   tails with all cross-base dependencies explicit.
5. **Scalable nonedge constructor.** Seek squarefree integers with
   unbounded comparable clusters but bounded compatibility rank. Prove
   realizability and asymptotics, or identify the exact obstruction.
6. **Blind adversarial referee.** Attempt to falsify the strongest claimed
   incidence lemma and audit every conversion from overlap count to
   `D(n) >= (log n)^A`.

Use retained follow-ups on the strongest incidence lemma and a fresh
adversary.

## Failure gates

- `n=210`: pair witnesses exist but no triple.
- `n=2310`: five vertices do not force the proposed triple phenomenon.
- Pairwise-to-joint, marginal-density, or independent-base assumptions are
  rejected.
- Uniform `E[X]` is already too small on products of primes in `(y,2y]`;
  use factorial moments, biased sampling, or tails.
- A finite empty hypergraph only raises `H(r)`; it does not refute SCLO.
- A disproof requires cluster size tending to infinity with compatibility
  rank below one fixed `r`.

Inference is the main compute. Exact jobs may test a named formula or
smallest obstruction, never run a generic census. If blocked, return one
precise incidence inequality whose proof would close the regime.
