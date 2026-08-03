# Erdős 700(iii): try to kill or validate UHFL on the decisive hard families

Audit the exact UHFL(A) statement in
`runs/erdos700-iii-upper-half-first-layer-frontier-20260725/report.md`.
Never inspect `events.jsonl`, snapshots, credentials, or telemetry.

Try to disprove UHFL, not merely a stronger full-depth, Carmichael, MR, LAMI,
or fixed-row statement. A valid disproof fixes one A>1 and gives an unbounded
explicit multiprime family satisfying UHFL's Q and high-height-mass
antecedents, with an all-k proof that every legal row supports fewer than
m=ceil(A) first layers from U.

Start with:

    n = (product_{y<p<=2y} p)^2

and rigorously chosen balanced subfamilies. Reconstruct the first-layer
predicate before using any full-depth signed-digit result. Also test whether
the Maynard/geometric-shift construction that kills b=1 can be strengthened
to every adaptive multiplier without introducing a component already larger
than the target scale.

Launch independent workers on:
- exact all-k first-layer support for balanced squares;
- global factorial-ratio/gcd bounds for arbitrary reduced slope;
- linked cross-prime p-adic phase constraints;
- unconditional construction mechanisms and their factorization/load taxes;
- proof that any proposed counterfamily necessarily creates an adaptive
  winning row;
- hostile scope audit separating a UHFL counterexample from an original
  Erdős 700 counterexample.

A finite example, bounded multiplier packet, controller prime violating the
Q-bound, or p^2 full-depth obstruction is failure. Use at most two tiny
hypothesis-driven computations. If no family survives, extract the strongest
quantified no-go theorem and feed it into a positive UHFL proof route.
