# Adversarial audit: divisor-poset characterization

Audited source SHA-256:
`715913fbe5d8e4207845b3af7d155dbb99a7cc39904b011d4e9d35f6012e2b61`.

- `n>1` discharges the hidden `n≠0` condition in `Nat.mem_divisors`.
- `Nat.pos_of_mem_divisors` prevents division/cancellation by zero.
- Membership is used in the correct direction to obtain `d|n`; nondivisors
  never enter the public domain.
- The cofactor cutoff is an iff with inclusive endpoints and exact natural
  floors; no parity assumption is made.
- Negation preserves one common fixed `m` and converts `¬(budget<carry)` to
  `carry<=budget`; natural subtraction is not replaced by integer subtraction.
- Repeated prime powers and every prime divisor of `d` remain quantified.
- Mandatory cases remain in range: the cofactor upper endpoints are `1` for
  `(78,39,1)` and `(8,4,1)`, and `2` for `(136,34,2)`.
- Predicate-body scan finds no `f`, gcd, binomial coefficient, `Boundary`,
  `Realized`, `BoundarySafe`, or upstream theorem.
- Whole-source scan finds no placeholder, local axiom, unsafe bypass, or
  upstream conjecture use. Lean compilation exits 0; final axioms are exactly
  `[propext, Classical.choice, Quot.sound]`.

Verdict: accepted as an exact factorization/divisor-poset representation. It
removes all nondivisors and all product-inadmissible multipliers from the
finite candidate domain; no unsupported `m=1` simplification is asserted.
