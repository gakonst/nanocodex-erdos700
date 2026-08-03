# Erdős 700(iii): prove the lossy boundary/dual capture lemma

Work only on the positive DFC bridge. The lossless simultaneous-boundary
baseline is false at `(n,x)=(546,13)` and must not be relaunched.

Let `q_p = p^v_p(n)`, let `B_x(n)` be the divisibility-minimal divisors of
`n` exceeding `x`, and let `d_1,...,d_m` be an inclusion-maximal
pairwise-coprime subfamily with supports `P_i`. Under

```
n | lcm(1,...,x)
D_n(k) <= x for every 2 <= k <= n/2,
```

the exact deepest-column LP dual is

```
tau(n) = max sum_p y_p
```

over `y_p >= 0` with

```
sum_{p : q_p | D_n(k)} y_p <= 1
```

for every admissible `k`.

Find and prove the strongest uniform lossy replacement for the false baseline:
for arbitrary block probabilities `mu_(i,p)`, some admissible `k` should
capture at least

```
(1 / L(x)) * sum_i 1/|P_i|
```

of the normalized block score, where `L(x)=x^o(1)` (polylogarithmic is ideal).
Any such bound must explicitly survive `(546,13)`.

Prove line by line that the proposed lemma implies `tau(n)=x^o(1)` by the
dyadic dual-mass argument. Then attack the lemma from both sides:

- construct the row using exact Lucas/Kummer residue positions, not marginal
  density or abstract hypergraph assumptions;
- attempt an unbounded family forcing loss `x^c`;
- run targeted exact pilots with primal/dual LP certificates;
- identify the optimal necessary loss on all discovered examples.

Success is a proved quantified lossy lemma sufficient for DFC, or an explicit
unbounded certified obstruction. A restatement of DFC, a finite obstruction,
or another approach list is not success.
