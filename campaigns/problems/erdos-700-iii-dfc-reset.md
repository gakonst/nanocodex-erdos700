# Erdős 700(iii): close or refute the fractional-cover bridge

This is a reset campaign. Do not repeat the prior global brainstorming and do
not treat an equivalent reformulation as progress.

For composite `n > 1`, let

```
K_n = {2, ..., floor(n/2)}
A_(k,p,h) = 1[v_p(D_n(k)) >= h]
D_n(k) = n / gcd(n, binomial(n,k))
```

where `(p,h)` ranges over the exact prime-power layers
`p^a || n`, `1 <= h <= a`. Define the exact fractional cover number

```
tau(n) = min sum_k lambda_k
```

over `lambda_k >= 0` subject to

```
sum_k lambda_k A_(k,p,h) >= 1
```

for every layer `(p,h)`.

The remaining load-bearing statement is:

> DFC(delta): for every `delta > 0` there is `B_delta` such that whenever
> `n | lcm(1,...,x)`, `n` is multiprime, and `D_n(k) <= x` for every
> `k in K_n`, then `tau(n) <= B_delta x^delta`.

DFC closes the dense-escape residual and hence Part (iii). It is not presently
proved or disproved.

## Required attack

Run genuinely independent proof and counterexample programs against DFC:

1. Derive the strongest unconditional upper and lower bounds for `tau(n)` that
   use the exact Lucas/Kummer layer incidence, not merely `tau <= omega(n)`.
2. Combine the verified maximal pairwise-coprime boundary extraction with the
   LP dual. Isolate a single quantitative lemma which would imply DFC.
3. On the negative side, search for an unbounded structured family satisfying
   the all-index bound but with `tau(n) >= x^c` for some fixed `c > 0`.
   Finite examples such as `(n,x)=(30,5)` and `(2310,15)` are regression tests,
   not counterexamples.
4. Use exact computation only for hypothesis-directed pilots. Report complete
   certificates: the factorization, all relevant rows or a symmetry-reduced
   incidence description, and primal/dual LP witnesses.
5. If DFC is too strong, state and prove or refute the weakest quantitative
   replacement still sufficient for `log n = x^{o(1)}`.

## Acceptance

The campaign succeeds only with one of:

- a complete proof of DFC with all quantifiers and constants;
- an explicit unbounded counterfamily with verified all-index and LP bounds;
- a strictly narrower new lemma, not equivalent to DFC, accompanied by a
  rigorous implication to DFC and an exact falsification campaign which has
  survived adversarial review.

Do not return another list of approaches. Preserve failed routes and explain
precisely why they fail. Do not claim Erdős 700(iii) is solved without an
independently verified proof of the original quantifiers.
