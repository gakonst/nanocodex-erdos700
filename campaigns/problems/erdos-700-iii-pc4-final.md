# Erdős 700(iii): prove or refute exact four-component pair capture

This is one branch of the Carmichael final stretch. Work only on the exact
statement below; do not relaunch AQG, primorial cubic support, DFC, or generic
common-index brainstorming.

For composite `n`, put

```text
D_n(k)=n/gcd(n,binomial(n,k)),
D(n)=max_{2<=k<=n/2} D_n(k).
```

Recover all worker reports from `math-1784935021-3712996`, especially reports
5, 9, 12, 13, 14, and 19. Never inspect `events.jsonl`, snapshots,
credentials, or telemetry.

Let

```text
q_i=p_i^a_i,  q_1<=q_2<=q_3<=q_4=P,
n=q_1*q_2*q_3*q_4.
```

Prove or refute:

```text
PC4:
if lambda(n)>P^3, some admissible k has q_i*q_j | D_n(k)
for two distinct i,j.
```

The exact six-system form is: for some `i<j`, with
`m=n/(q_i*q_j)`, there is `1<=t<=m/2` such that

```text
q_j*t <=_{p_i} q_j*m,
q_i*t <=_{p_j} q_i*m,
```

where `<=_p` is digitwise domination in base `p`; then
`k=q_i*q_j*t`. Reprove this equivalence.

For squarefree four-prime `n`, a PC4 falsifier is an actual `H_lambda`
falsifier, because every `D_n(k)` then has singleton support and `D(n)=P`.
Direct products (`t=1`) are known false, including an unconditional infinite
family. Adaptive `t` is essential.

Launch a clean, independent worker batch covering:

1. a proof from the private prime-power atoms forced in the `lambda(q_i)`;
2. simultaneous digit-submask least representatives/product formula;
3. multiplicative-order or character-sum input tied to the `q_i-1`;
4. determinant/height obstruction to all six systems being empty;
5. an explicit unbounded all-six-empty counterfamily;
6. a blind proof/disproof and quantifier audit.

Each worker must state a falsifiable theorem, prove its implication to PC4,
and attack it immediately on the retained direct-index falsifiers. Finite
enumeration is only regression evidence. Return a complete proof, an
unbounded counterfamily with an all-index certificate, or the first exact
missing lemma and its smallest falsifier.

Do not claim Part (iii) from PC4 alone: PC4 settles the first
`omega(n)=4` case and is a testbed for the global weighted theorem.
