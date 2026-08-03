# Erdős 700(iii): global weighted Carmichael-Lucas cover

This is the positive branch of the Carmichael final stretch. Prove

```text
H_lambda: lambda(n) <= D(n)^3
```

for every composite `n`, where

```text
D_n(k)=n/gcd(n,binomial(n,k)),
D(n)=max_{2<=k<=n/2} D_n(k).
```

Together with the audited minimal-order theorem for the Carmichael function,
`H_lambda` implies the exact arbitrary-logarithmic-saving statement in Erdős
700(iii), including all finite exceptions. Recheck that implication and its
quantifier order.

Recover every worker report from `math-1784935021-3712996`, especially reports
3 and 12--19. Never inspect `events.jsonl`, snapshots, credentials, or
telemetry.

Write `n=product q_i`, with `q_i=p_i^a_i` exact prime-power components.
Assign every maximal prime-power atom of `lambda(n)` to one component realizing
it, and let `L_i` be the product of atoms assigned to `q_i`. Then

```text
gcd(L_i,L_j)=1,
product L_i=lambda(n),
L_i | lambda(q_i).
```

For an admissible row define

```text
S(k)={i:q_i | D_n(k)}.
```

The three-bin lemma is exact: if loaded components partition into three sets,
each contained in some actual `S(k)`, then `H_lambda` follows.

Prove either the arithmetic `LC3` statement above or the weaker sufficient
statement

```text
if product L_i>X^3, some actual S(k) contains B with product_{i in B} q_i>X.
```

The proof must use the simultaneous Lucas digit systems arising from the one
integer `n`. It must survive:

- the seven-component abstract load obstruction in report 15;
- `n=183744=64*9*11*29`, which kills naive three-row cover;
- `n=493955=5*7*11*1283`, which kills universal weighted fractional
  three-cover;
- `n=546`, which kills unweighted probability;
- deletion failure `D(90)<D(45)`.

Abstract set cover, marginal density, pairwise gluing, fractional-cover
renaming, and finite census are forbidden. Launch matched proof and
falsification workers against exactly the same quantified lemma. A negative
result must be an unbounded arithmetic family with an all-index support
certificate, not an abstract incidence graph.

Return a complete proof of `H_lambda`, an actual unbounded counterfamily, or
the narrowest surviving quantified arithmetic lemma together with a rigorous
implication and adversarial falsification audit. Begin Lean only after the
mathematical chain is complete.
