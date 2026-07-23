# Stretched Littlewood–Richardson negativity

Find integer partitions `lambda`, `mu`, and `nu` such that:

- every partition is nonempty, weakly decreasing, and has positive parts;
- every partition has length at most 7 and weight at most 30;
- `|lambda| = |mu| + |nu|`; and
- the stretched Littlewood–Richardson coefficient
  `c^(t lambda)_(t mu,t nu)`, as a polynomial in the nonnegative integer
  stretch factor `t`, has at least one negative coefficient.

The decisive candidate artifact must be named `candidate.json` and contain
exactly these keys, with no extras:

```json
{"lambda":[...],"mu":[...],"nu":[...]}
```

The host-preapproved verifier is the only success gate. It independently
validates the partitions, computes exact LR coefficients with `lrcalc`,
interpolates through the length-seven degree bound, performs held-out checks,
and tests the exact rational coefficients. Focus discovery on lengths 5–7,
while allowing the checker to decide the full stated range.

Use multiple genuinely different routes: exact Sage/lrcalc enumeration,
hive/Ehrhart or polyhedral structure using Normaliz/LattE where useful, and
structural or literature-guided candidate generation. Record the exact tool
environment with `math-env-report`. Web search is enabled for discovery and
must also be used for the final novelty/status audit. Partial results are
valuable evidence but never count as resolution.
