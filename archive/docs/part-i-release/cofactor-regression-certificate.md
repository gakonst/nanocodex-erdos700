# Cofactor normalization regression certificate

The universal proof is the kernel-checked equivalence in
`CofactorObstruction.lean`; this file records finite regressions only.

For every positive divisor `d|n`, the proved cutoff identity replaces
`d*m<=n/2` by `m<=(n/d)/2`. Hence the existing direct-versus-boundary scan of
all 831 composite `n<=1000` also covers the cofactor criterion without a
sampling assumption. A fresh run of `cd proof && ./scripts/verify-part-i.sh`
ended:

```text
Part (i) finite audit passed: 831 composite integers through n=1000 and all mandatory cases.
Part (i) verification passed.
EXIT_CODE: 0
```

Focused endpoint calculations are exact:

- `78/39/2=1`, so `(78,39,1)` is included;
- `8/4/2=1`, so `(8,4,1)` is included;
- `136/34/2=2`, so `(136,34,2)` is included;
- `450/10/2=22`, so the first accepted multiplier `13` is included.

These cases respectively guard the inclusive endpoint, repeated powers,
failure of the `m=1` simplification, and failure of several small-multiplier
heuristics.
