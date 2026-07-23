# Structural Lean status

Three complete simultaneous-omission theorems have been kernel checked:

- `PROmission.lean`: `not_p_and_r_omitted`
- `PQOmission.lean`: `not_p_and_q_omitted`
- `QROmission.lean`: `not_q_and_r_omitted`

Each was compiled independently with exit status zero in the pinned integrated
FC/PNT project. Each has the axiom set
`[propext, Classical.choice, Quot.sound]`.

`Combined.lean` supplies:

- `prime_triple_pairwise_not_omitted`, the conjunction of all three results
  for every `1 < k <= p*q*r/2`;
- `prime_triple_f_square_gt`, obtained by passing that result to
  `Assembly.prime_triple_f_square_gt_of_pairwise_not_omitted`.

The final combined module and root `Erdos700PNT.lean` module were subsequently
compiled successfully in the pinned local environment.

The files contain no `sorry`, `admit`, candidate `axiom`, or reference to the
open theorem `Erdos700.erdos_700.parts.ii`.
