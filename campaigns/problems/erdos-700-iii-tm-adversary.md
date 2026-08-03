# Erdős 700(iii): adversarial audit of the top-component mass route

Work only in
`runs/erdos700-iii-tm-adversary-20260728/`. Do not edit canonical
documentation, proof files, benchmark/verifier code, or another run
directory. Never inspect an `events.jsonl`.

Read completely:

- `docs/part-iii-exploration-map.md`;
- `runs/erdos700-iii-audited-max-20260727/report.md`;
- `runs/erdos700-iii-audited-max-20260727/two-digit-spacing-proof.md`;
- `runs/erdos700-iii-audited-max-20260727/candidate-lemma.md`.

Adversarially decide the proposed top-component mass deficit

\[
\exists C,x_0\ \forall n>1\text{ multiprime with }x=D(n)\ge x_0,\qquad
\sum_{\substack{p^a\parallel n\\p^a>\sqrt x}}a\log p
\le Cx/\log x. \tag{TM}
\]

Try hardest to disprove it. A genuine disproof requires an unbounded explicit
family, exact control of \(D(n)\) for every legal row, and top-component mass
larger than every constant multiple of \(x/\log x\). A finite packet, shallow
CRT lock, or counterexample to a sufficient lemma is not a disproof.

If no genuine family exists, attack the proposed proof mechanisms instead:

- determine whether `(AS2)/(PW2)` has any valid depth-growing iteration;
- determine whether low prefix width plus
  \(n\mid\operatorname{lcm}(1,\ldots,x)\) can constrain the least positive
  mixed-depth CRT representative;
- search for a growing smooth packet that satisfies every bounded-prefix
  conclusion while retaining large top mass, and state exactly which
  additional all-row condition it fails;
- audit whether `(TM)` is materially weaker than Erdős 700(iii) or has hidden
  equivalence to the same-row frontier.

Use exact computation only against a named universal claim. Respect every
K1--K58 failure certificate and the P4/P6/P7 all-row values.

Write `report.md` with either a complete scalable disproof or the strongest
proved obstruction to the route. If incomplete, end with exactly one first
unproved quantified statement; do not substitute a method counterexample for
the target.
