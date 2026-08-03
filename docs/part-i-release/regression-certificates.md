# Regression certificates

These checks are evidence against implementation and statement-alignment
errors; they are not the universal proof. Full machine-readable rows are in
`regression-certificates.json` and `alternative-shadow-crt/result.json`.

## Mandatory cases

| case | exact outcome | obligation exercised |
|---|---|---|
| $n=30$ | $P=5$, $f(30)=6=30/P$; boundaries $6,10,15$ are all unrealized | positive characterization case |
| $(n,d,m)=(78,39,1)$ | $dm=39=n/2$; carry vector $(0,0)$ equals budgets $(0,0)$ | inclusive endpoint; hence unsafe |
| $(8,4,1)$ | $\kappa_2(8,4)=1=v_2(8)-v_2(4)$ | repeated prime powers and equality budget |
| $(136,34,2)$ | $m=1$ fails with carries $(4,0)$ against budgets $(2,0)$; $m=2$ passes with $(2,0)$ | refutes testing only $m=1$ |

The focused structural pilot also gives $(n,d)=(450,10)$, where the first
accepted multiplier is $m=13$. This refutes the additional proposals
$m\le P$, $m\le d$, and “$m$ divides $d$ or $n/d$.”

## Exhaustive bounded regression

For every one of the 831 composite integers $n\le1000$, the audit compared:

1. direct evaluation of the gcd/binomial minimum;
2. the exact `BoundarySafe` predicate; and
3. the periodic digit-shadow/CRT representation.

It checked 1503 boundary cores and 512108 local shadow pairs and found zero
mismatches. The release verifier independently repeats the direct versus
boundary scan and reports:

```text
Part (i) finite audit passed: 831 composite integers through n=1000 and all mandatory cases.
```

## Historical separator

For $n=12$, direct values for $k=2,\ldots,6$ are
$6,4,3,12,12$. Thus $f(12)=3=12/4$ for the 1978 greatest-prime-power
baseline, but $f(12)\ne12/3$ for the modern largest-prime baseline.
