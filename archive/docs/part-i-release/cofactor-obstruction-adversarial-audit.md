# Adversarial audit: cofactor-normalized obstruction theorem

**Audited source:** `CofactorObstruction.lean`, SHA-256
`238cdb64197025bf3e369d88b221f8872b2e44a4eed896f423f53947ab1e8459`.

## Line-item checks

- **Division orientation:** the cutoff lemma assumes both `0<d` and `d|n`.
  Forward division is order preserving; reverse multiplication uses the exact
  identity `d*(n/d)=n`. No false cancellation for nondivisors occurs.
- **Nested floor division:** `(n/2)/d=n/(2d)` and `(n/d)/2=n/(d2)` are equal
  because `2d=d2`. This is numerical equality, not componentwise valuation
  order.
- **Endpoint:** all bounds are nonstrict. In particular `dm=n/2` remains
  included.
- **Positivity:** a boundary has `d>P(n)>0`; the reverse direction obtains
  `d>=P(n)+1`, while `m>=1` comes from `Finset.Icc`.
- **Divisibility orientation:** `p|d` and `d|n` are composed as `p|n`, never in
  reverse. The public predicate explicitly retains `d|n`.
- **Prime powers:** the budget is natural subtraction
  `n.factorization p - d.factorization p`; no integer-subtraction rewrite is
  used. Repeated powers are preserved.
- **Quantifiers:** negating the local existential rejection produces carry
  budget inequalities for every prime divisor of `d`, all for the same fixed
  `m`. There is no swap between `exists m, forall p` and `forall p, exists m`.
- **Divisor completeness:** every boundary lies between `P+1` and `P^2`; the
  proof chooses an actual prime divisor of `d`, proves it divides `n`, and
  combines `p<=P` with `d/p<=P`.
- **Multiplier completeness:** equation (1) is an iff, so quotient
  normalization discards no admissible multiplier and adds none.
- **Independence:** the exact predicate-body scan finds no `f`, gcd, binomial,
  `Boundary`, `Realized`, `BoundarySafe`, or upstream Part-(i) theorem.
- **Formal hygiene:** compilation exits 0; no `sorry`, `admit`, local axiom,
  unsafe bypass, or upstream conjecture reference occurs. The final theorem's
  transitive axiom set is exactly `[propext, Classical.choice, Quot.sound]`.

## Mandatory edge cases under the new interval

| case | cofactor cutoff | audit result |
|---|---:|---|
| `n=30,d=6,10,15` | respectively `2,1,1` | all relevant witnesses retained; all three boundaries remain unrealized |
| `n=78,d=39,m=1` | `(78/39)/2=1` | included at `dm=39=n/2`; remains unsafe |
| `n=8,d=4,m=1` | `(8/4)/2=1` | repeated-power equality budget retained |
| `n=136,d=34,m=2` | `(136/34)/2=2` | `m=2` included at the upper endpoint; the `m=1` simplification still fails |
| `n=450,d=10,m=13` | `(450/10)/2=22` | nontrivial multiplier retained |

## Verdict

No mathematical defect was found. The new representation strictly removes
the redundant product-cutoff test from the criterion and normalizes each
multiplier interval by its cofactor. It does not claim that only `m=1` or only
a prime-factor-bounded number of multipliers suffices.
