# Adversarial audit of the boundary characterization

## Exact theorem

For every composite \(n>1\), Lean proves

```lean
Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

where `BoundarySafe` asserts that no divisibility-minimal divisor above
`P(n)` is realized by a positive admissible multiple satisfying the exact
carry budgets.

## Required regression cases

### \(n=30\): equality

Here \(P=5\), and the boundary divisors are \(6,10,15\). None is realized:

- at \(k=6,12\), the relevant base-\(3\) carry counts exceed the zero budget;
- at \(k=10\), the base-\(5\) carry count exceeds the zero budget;
- at \(k=15\), both the base-\(3\) and base-\(5\) tests fail.

Thus `BoundarySafe 30` holds and

\[
f(30)=6=30/5.
\]

### \(n=78\): strict failure at the endpoint

Here \(P=13\), and \(d=39\) is a boundary divisor because

\[
39/3=13,\qquad39/13=3.
\]

It is realized with \(m=1\) at the included endpoint \(k=39=n/2\):

\[
v_3\binom{78}{39}=v_{13}\binom{78}{39}=0.
\]

Hence

\[
\gcd\!\left(78,\binom{78}{39}\right)=2<6=78/13.
\]

This case requires `≤` in the carry budget and `≤ n/2` in the admissible
range.

### Repeated prime powers

For \(n=8\), \(P=2\), and \(d=4\), the multiplier \(m=1\) gives

\[
v_2\binom84=1=v_2(8)-v_2(4).
\]

Thus \(d\) is realized and \(f(8)=2<4=8/2\). This checks that the theorem is
not squarefree-only and that equality in the carry budget is accepted.

For \(n=136\), the boundary divisor \(34\) is not realized at \(m=1\) but is
realized at \(m=2\). Therefore testing only the boundary divisor itself is
incorrect.

## Simplifications known to be false

The following changes invalidate the characterization:

- dropping `d ∣ n`;
- allowing `m = 0`;
- testing only `m = 1`;
- replacing a carry-budget `≤` by `<`;
- replacing `dm ≤ n/2` by a strict inequality;
- replacing `d/p ≤ P(n)` by a strict inequality;
- treating natural truncated subtraction as integer subtraction;
- exchanging the numerical minimum over indices with componentwise minima.

The finite audit checked every composite \(n\le500\) against the carry
formulas and every composite \(n\le1000\) against the final equivalence.
These computations are regression evidence; the universal result is supplied
by the Lean proof.

## Formal dependency gate

`PartIVerify.lean` prints the transitive axioms of every promoted bridge.
The expected dependency set of the final theorem is

```text
[propext, Classical.choice, Quot.sound]
```

The verification script rejects `sorry`, `admit`, local `axiom`
declarations, `sorryAx`, and any unexpected final dependency set.
