# Statement audit: Erdős Problem 700(ii)

## Original problem

Define

\[
f(n)=\min_{1<k\le n/2}\gcd\left(n,\binom nk\right).
\]

Part (ii) asks whether there are infinitely many composite integers \(n\)
such that

\[
f(n)>n^{1/2}.
\]

## Pinned Formal Conjectures encoding

The pinned source defines

```lean
noncomputable def Erdos700.f (n : ℕ) : ℕ :=
  sInf {m | ∃ k, 1 < k ∧ k ≤ n / 2 ∧
    m = Nat.gcd n (n.choose k)}
```

and represents the solved side of part (ii) as

```lean
{n : ℕ | ¬n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite
```

The translations are exact:

- natural-number `n / 2` is the integer floor implicit in the original range;
- `¬n.Prime ∧ 1 < n` means that `n` is composite;
- since `Erdos700.f n` is nonnegative, `(Erdos700.f n)^2 > n` is equivalent
  to the strict inequality `Erdos700.f n > √n`;
- `Set.Infinite` is the requested existence of infinitely many such integers.

## Proved theorem

`Solution.lean` proves exactly:

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

This is definitionally the solved mathematical side of the pinned
`Erdos700.erdos_700.parts.ii` statement. The proof does not invoke that open
theorem or its unspecified `answer` wrapper.

## Quantifier and boundary checks

- The proof treats every `k` satisfying `1 < k` and
  `k ≤ (p*q*r) / 2`.
- The constructed integers are products of three primes and are proved
  composite and greater than one.
- The prime-counting interval is `(8*T^3, 16*T^3]`, with its endpoint
  convention handled explicitly before interval packing.
- The products are unbounded, and the proof converts unbounded membership
  into `Set.Infinite`.
- The inequality is strict throughout; the easy equality family `n = p^2`
  is not used.

## Kernel audit

The local pinned build completed successfully. Lean reports:

```text
'Erdos700PNT.erdos_700_ii' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

There is no dependency on the upstream open theorem or on a proof
placeholder.
