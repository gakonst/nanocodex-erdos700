# Mathematical referee report

## Verdict

**Accepted for the immutable modern statement.** I found no invalid
declaration or missing implication. The complete argument is in
`complete-prose-proof.md`; the checked formal statement is

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

where `Erdos700.P` is the largest prime divisor.

## Line-item audit

| Item | Finding |
|---|---|
| Positivity | `residueCarryWeight` is a product of positive prime powers; every cancellation is by a positive number. |
| Nonempty minimum | Composite (n>1) has (P(n)\le n/2), so (k=P(n)>1) is admissible and attains the baseline gcd. |
| Divisibility orientation | Exactness gives (W_k\mid n); the binomial identity gives the separately needed (W_k\mid k). Neither direction is reversed. |
| Order | The bridge uses ordinary numerical inequalities (W_k\le P), not coordinatewise valuation order. |
| Natural subtraction | The weight correctly uses (a\dotminus c). In the realization budget, (d\mid n) guarantees (v_p(d)\le v_p(n)). |
| Prime quantifiers | Every natural prime divisor of (d) is quantified; multiplicity is retained by `factorization`. |
| Multiplier quantifier | `Realized` quantifies over every (m>0), not only (m=1). |
| Endpoint | The bound is non-strict, so (dm=n/2) is included. |
| Boundary minimality | Prime deletion (d/p\le P) is exactly divisibility-minimality among divisors above (P), including repeated powers. |
| Independence | `Boundary`, `Realized`, and `BoundarySafe` do not mention (f), gcd, binomial coefficients, or the open upstream theorem. |
| Local-to-global step | The common multiplier is obtained from (d\mid W_k\mid k); it is not assembled independently prime by prime. |

## Direction audit

1. If (f(n)=n/P), exact complementary weights satisfy (W_k\le P) for
   every admissible (k). A realized boundary would give
   (P<d\le W_{dm}\le P), impossible.
2. If `BoundarySafe n` and some admissible (k) had (W_k>P), a least
   overweight divisor (d\mid W_k) would be a boundary. Since (W_k\mid k),
   write (k=dm); the primewise valuation equivalence makes (d) realized,
   a contradiction. The largest-prime witness then forces the minimum to be
   exactly (n/P).

## Adversarial regressions

- (n=30): safe, with boundary divisors (6,10,15), so the equality holds.
- (n=78,d=39,m=1): realized at (39=78/2); a strict endpoint would be
  wrong.
- (n=8,d=4,m=1): repeated power and equality in the carry budget.
- (n=136,d=34): (m=1) fails but (m=2) realizes the boundary.
- Omitting (d\mid n) creates foreign-prime false obstructions; restricting
  to squarefree cores or replacing non-strict inequalities also fails.
- (n=450,d=10) is first realized at (m=13), refuting bounds
  (m\le P(n)), (m\le d), and divisor-only multiplier lists.

The direct scan through all 831 composite (n\le1000) found no mismatch, but
is explicitly classified as regression evidence rather than the universal
proof.

## Scope

This acceptance concerns the modern largest-prime-factor proposition. The
separate historical audit finds a different 1978 definition of (P(n)), so
this report does not upgrade the candidate to a publication-grade solution of
the verbatim 1978 task.

## Addendum: independent digit-shadow predicate

`FullShadowSafe` has now been proved extensionally equal to `BoundarySafe`.
Its expanded definition contains only the boundary divisor conditions and a
finite system of base-prime remainder comparisons.  The carry/digit bridge,
common-period argument, positive representative, repeated powers, common
witness, natural subtraction, and inclusive endpoint were independently
audited and accepted.  The exact Lean source compiles with only the standard
three axioms.  The period does not thin the admissible multiplier range, so
this addendum supports a clearer characterization but no complexity claim.
