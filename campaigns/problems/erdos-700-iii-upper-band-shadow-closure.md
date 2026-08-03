# Erdős 700(iii): close the upper-band disjoint-shadow alternative

Work on the exact squarefree upper-band reduction.

Assume `n` is squarefree, every prime `p|n` lies in `(sqrt(x),x]`, and
`D_n(k)<=x` for all admissible `k`. Then the proper Lucas shadows are
pairwise disjoint and `tau(n)=omega(n)`.

For `n=pqR`, pairwise disjointness is exactly the nonexistence of
`1<=t<=R/2` satisfying

```
q t <=_p q R
p t <=_q p R
```

digitwise. Existing work proves a two-digit spacing theorem: a polynomially
large disjoint family forces a polynomially large packet with normalized
residues `(n/p mod p^e)/p^e` shrinking polynomially, for a common
`e in {1,2}`.

Close this alternative:

1. Prove that the simultaneous shrinking-residue packet is impossible at
   polynomial size, using determinant/product-formula/spacing/CRT methods; or
2. Construct an explicit unbounded packet and prove every pair of full Lucas
   shadows is disjoint.

A positive impossibility theorem yielding `omega(n)=x^o(1)` proves DFC in
this hard upper-band regime. A construction with `omega(n)>=x^c` refutes DFC.

Every claimed construction must certify the all-pairs, all-digit condition;
every impossibility theorem must quantify packet size and prime spread.
Finite examples and rich-digit subclasses are regression evidence only.
Return one complete theorem/counterfamily or the first strictly narrower
quantified determinant/residue lemma plus an implication and falsification
audit.
