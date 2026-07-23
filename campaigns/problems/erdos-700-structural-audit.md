# Erdős 700(ii): adversarial audit of the prime-triple structural lemma

This is a focused verification campaign, not an invitation to restart general
discovery. The candidate to audit is retained at:

`runs/math-1784829651-1913239/worker-reports/agent-3-unconditional-number-theorist.md`

The original immutable problem and accumulated exact counterexamples are at:

- `runs/math-1784829651-1913239/problem.md`
- `runs/math-1784829651-1913239/ledger.md`
- `runs/math-1784829651-1913239/exact-jobs/`

## Candidate lemma

Let

`q = p + a`, `r = q + c = p + a + c`, and `b = a + c`,

where `p < q < r` are primes, `c > a > 0`, and `p > 4 b^3`.
For `n = p*q*r`, the candidate claims that for every integer
`0 < k <= n/2`, at most one of `p,q,r` fails to divide `binomial(n,k)`.
It concludes

`gcd(n, binomial(n,k)) >= p*q`

and hence the strict inequality required by Erdős 700(ii).

The proposed proof uses Lucas/Kummer digit containment and the expansions

```
q*r = a*b + (a+b)*p + p^2
p*r = (q-a*c) + (c-a-1)*q + q^2
p*q = b*c + (p-c)*r.
```

## Required work

1. Re-derive the exact criterion for a prime divisor of squarefree `n` to be
   absent from `binomial(n,k)`. Check every divisibility and range condition.
2. Audit all three pair-omission cases independently. Check every base digit,
   carry, borrow, coefficient range, use of `k <= n/2`, and implication of
   `p > 4b^3`. Do not inherit the worker's algebra without recomputation.
3. Use targeted exact computation to search for counterexamples to the lemma
   throughout its stated domain, concentrating near the weakest inequalities.
   Computation is a falsifier only and cannot prove the unbounded statement.
4. Determine whether `gcd >= p*q` and `(p*q)^2 > p*q*r` follow with the stated
   hypotheses, including all strict inequalities.
5. If any step fails, give the smallest exact counterexample or the precise
   repaired hypothesis. If it survives, write a publication-grade standalone
   proof with every digit calculation explicit.
6. Launch clean adversarial workers for the three omission cases, one
   counterexample search, and one independent reconstruction.

## Output contract

Write inside the assigned run directory:

- `structural-audit.md`: line-by-line verdict;
- `structural-proof.md`: repaired standalone proof if valid;
- `counterexample.json`: exact falsifier if invalid;
- `verification.md`: every deterministic command and result;
- `report.md`: final status and the exact remaining gap.

Do not claim that Erdős 700(ii) is solved. This campaign verifies only the
elementary structural lemma and its implication for one prime triple.
