# Erdős 700(iii): prove the top-component mass deficit

Work only in
`runs/erdos700-iii-tm-proof-20260728/`. Do not edit canonical documentation,
proof files, benchmark/verifier code, or another run directory. Never inspect
an `events.jsonl`.

Read these files completely before acting:

- `docs/part-iii-exploration-map.md`;
- `runs/erdos700-iii-audited-max-20260727/report.md`;
- `runs/erdos700-iii-audited-max-20260727/two-digit-spacing-proof.md`;
- `runs/erdos700-iii-audited-max-20260727/candidate-lemma.md`.

The exact target of this clean-room attack is the assertion `(TM)`:

\[
\exists C,x_0\ \forall n>1\text{ multiprime with }x=D(n)\ge x_0,\qquad
\sum_{\substack{p^a\parallel n\\p^a>\sqrt x}}a\log p
\le Cx/\log x.
\]

The retained argument proves that `(TM)` gives
\(D(n)\gg\log n\log\log n\), a genuine uniform advance. Recheck that transfer,
then either prove `(TM)` or identify its first false implication with a
scalable counterexample. Finite evidence is only a falsifier.

In the squarefree top packet, \(D(n)\le x\) makes every pair of full Lucas
supports endpoint-only. The new asymmetric theorem `(AS2)/(PW2)` controls only
the first two actual digits. A successful proof must grow with the true digit
depth and use both the actual common cofactor and
\(n\mid\operatorname{lcm}(1,\ldots,\lfloor x\rfloor)\). In particular, test:

1. whether the prime-gap common-row identity can be iterated through a growing
   sequence of digit blocks without changing the literal row; and
2. whether the resulting variable-depth residue boxes, together with the
   mixed-depth least-positive CRT representative, force the smooth cofactor
   above \(\operatorname{lcm}(1,\ldots,x)/Q\).

Do not return a fixed-depth theorem, marginal density statement, renamed
same-row conjecture, or the implication `(SD2)`. Every use of an external
theorem must be stated precisely and source-checked. Falsify proposed steps
against K1--K58 and the P4/P6/P7 certificates before promoting them.

Write `report.md` containing the exact theorem, proof, backward target audit,
adversarial audit, dependencies, and deterministic checks. If incomplete,
end with exactly one first unproved quantified statement and explain why it
is strictly stronger than the already open `(TM)` rather than equivalent to
it.
