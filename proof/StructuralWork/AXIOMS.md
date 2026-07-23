# Axiom audit

Pinned environment:

- Formal Conjectures `e751934294a381afd2d5fc1124c5953c8e25f9fa`
- Lean `v4.27.0`
- Mathlib `a3a10db0e9d66acbebf76c5e6a135066525ac900`

The remote Lean compiler printed:

```text
'Erdos700PNT.not_p_and_r_omitted' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos700PNT.not_q_and_r_omitted' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos700PNT.not_p_and_q_omitted' depends on axioms: [propext, Classical.choice, Quot.sound]
```

There is no `sorryAx`, candidate axiom, or dependency on
`Erdos700.erdos_700.parts.ii`.
