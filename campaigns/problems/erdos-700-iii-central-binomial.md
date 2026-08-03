# Erdős 700(iii): central-binomial hard-family decision

## Exact objective

For

```text
N_M = binomial(2M,M),
D_n(k) = n / gcd(n, binomial(n,k)),
D(n) = max_{2 <= k <= n/2} D_n(k),
```

decide the canonical hard family `N_M`. Its exact prime-power components are
all `O(log N_M)`, so the known largest-component argument gives only one
logarithmic power.

Recover every non-event artifact from the retained Part-(iii) campaigns,
especially the central-binomial report and falsifiers. Never inspect an
`events.jsonl`.

## Target theorem

Prove:

> For every integer `r >= 1`, there exist `c_r>0` and `M_r` such that for
> every `M >= M_r`,
>
> ```text
> D(N_M) >= c_r M^r.
> ```

Since `log N_M` is asymptotic to `2M log 2`, this gives arbitrary
polylogarithmic saving on the family.

Equivalently, construct one admissible `k` with

```text
sum_p
  [v_p(N_M) - v_p(binomial(N_M,k))]_+ log p
    >= r log M + log c_r.
```

If false, seek a fixed degree `B` and an unbounded subsequence with a rigorous
all-`k` upper bound `D(N_M) <= M^B`. Such a result would disprove Part (iii),
not merely this proof route.

## Independent roles

1. **Factorial-unit specialist.** Express the p-adic unit and carry structure
   of `N_M` using factorial-unit residues and derive exact congruences useful
   for choosing `k`.
2. **Prime-interval selector.** Use primes and prime powers in controlled
   intervals of `M` to build several layers whose simultaneous omission can
   be proved rather than assumed.
3. **Partial-carry witness architect.** Construct explicit formulas for `k`
   exploiting the binary/base-p structure of `N_M`; full omission is not
   required.
4. **Factorial-ratio theorem scout.** Search primary literature for exact
   theorems on prime divisors, p-adic valuations, or digit statistics of
   factorial ratios that quantitatively imply the target.
5. **All-k upper-bound adversary.** Try to make the family a genuine
   counterexample by bounding every `D_{N_M}(k)`. State precisely where
   uncontrolled partial layers defeat the argument.
6. **Symbolic and asymptotic referee.** Audit every formula, constants,
   quantifier order, admissibility, and the conversion from `M` to `log N_M`.

Follow the strongest explicit witness with an adversarial audit. Any exact
job must test a named symbolic formula and stop on its first mismatch.

## Failure gates

- `M=5`, `N_M=252`, `k=56` gives `D=28>2M`; therefore
  `D(N_M)<=2M` is false.
- Smooth exact components do not upper-bound `D`; partial layers can combine.
- Full-component witnesses alone are incomplete.
- Finite tables are not asymptotic evidence.
- An upper-bound disproof must control all admissible `k` along an unbounded
  subsequence for one fixed degree.

If neither direction closes, return one exact factorial-ratio/carry theorem
whose proof would decide the family.
