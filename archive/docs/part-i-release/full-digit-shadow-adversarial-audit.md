# Adversarial audit: finite digit-shadow theorem

## Audited bytes

- Source: `FullDigitShadow.lean`
- SHA-256: `398fdbccd8a27e798416ff41d5f8889da816c04887b7f127c8f7e685d85f11a6`
- Pinned compile: exit 0 under Lean 4.27.0
- Axioms of all promoted declarations:
  `[propext, Classical.choice, Quot.sound]`

## Verdict

Retained adversarial agent 12 returned **ACCEPT** after checking the exact
source.  It found no counterexample or semantic mismatch in:

1. the `Nat.log` range and the case `p>n`;
2. positivity of the common period, the empty-product case `Q=1`, and
   exclusion of `d=0` under `n>0` and `d|n`;
3. repeated prime powers;
4. preservation of one common witness, rather than separate primewise
   witnesses;
5. natural truncated subtraction;
6. inclusion of `d*r=n/2`;
7. the least-positive representative and the proof `r<=m`; or
8. independence of the expanded public predicate from `f`, gcd, binomial
   coefficients, `Realized`, `BoundarySafe`, and the upstream open theorem.

## Material limitation discovered by the adversary

The common period does **not** compress the relevant multiplier search.  If
`p|d` and `h=floor(log_p n)`, then

\[
 Q_n(d)\ge p^h>n/p\ge n/d,
\]

while a realization witness satisfies `m<=floor(n/(2d))<n/d`.  Therefore the
positive representative modulo `Q_n(d)` equals `m` throughout the admissible
range.  The result is a clearer, directly finite digit/factorization
characterization, not a stronger complexity bound.  This limitation is
carried into the candidate and report rather than suppressed.
