# Erdős 700(iii): transfer an adaptive balanced-block row to general UHFL

Work on the exact UHFL(A) lemma in
`runs/erdos700-iii-upper-half-first-layer-frontier-20260725/report.md`.
Never inspect `events.jsonl`, snapshots, credentials, or telemetry.

The residual U contains the largest half of at least
X/(2A log X) low-height prime bases, each above delta_A X, but they need not
all lie in one short interval or share an exponent. Prove the weakest exact
structural reduction which makes the balanced adaptive-multiplier work
uniform:

Either:

1. extract a comparable fixed-height/dyadic packet large enough that a
   first-layer common-row theorem on that packet yields m=ceil(A) supports;
2. or construct one literal adaptive row spanning several packets, with exact
   right-closed phases and positive Kummer losses.

Recover the direct hard-sequence classification, Turn 4 balanced incidence,
and Turn 9 partial-layer tax from `runs/math-1784947385-3800908/`, plus the
frontier implication ledger. Also recover the adaptive cofactor-sum hint from
Sections 29--33 of `runs/math-1784972255-4031899/numbered-obstruction.md`.

Do not assume the balanced-square theorem that the other campaign is trying
to prove. State it as a parameter P(B), then prove exactly what strength and
uniformity of P(B) transfers to UHFL. Look for exponent splitting, dyadic
pigeonholing, reflection, and interpolation between component height and
first-layer mass.

Required outcome: a complete general-transfer theorem with constants and
endpoints, or an explicit residual configuration showing why every such
transfer fails and the strictly weaker replacement needed. This campaign
must not spend compute on full-depth MR bounds or a generic census.
