# Failure modes

## Mathematical failures

- silently replacing “for all” with “for infinitely many” or “almost all”;
- constants depending on variables from which they must be independent;
- a local construction that cannot be glued globally;
- invoking compactness without uniform estimates;
- optimizing an error bound that itself depends on the optimizer;
- proving a generic case while omitting degeneracies;
- treating numerical near-equality as an exact identity;
- hiding the target inside an allegedly simpler unproved lemma;
- reducing to a conjecture of comparable difficulty and declaring progress complete.

## Formalization failures

- mistranslated definitions;
- theorem statement edited during proof search;
- `sorry`, `admit`, new axioms, opaque escape hatches, or unsafe evaluation;
- test examples disagreeing with the intended sequence or object;
- a proof of an unintended finite or decidable specialization;
- a declaration compiling only because of an overpowered imported assumption.

## Computational failures

- solver tolerance mistaken for feasibility;
- an LP primal without an independent dual bound;
- floating-point witness not rationalized;
- randomized search without seed or retained candidate;
- verifier sharing the same bug as the generator;
- interval calculations using ordinary floating-point endpoints;
- unbounded output or subprocesses corrupting long-horizon runs.

## Research-process failures

- multiple agents sharing the same flawed context and appearing independent;
- majority vote used as proof;
- only successful runs published;
- search retrieving an old theorem but the result announced as a new proof;
- formal proof existence conflated with scientific importance;
- benchmark answers counted as discoveries;
- operator mathematical input omitted from the attribution record;
- prompt or web-search policy not retained.

## Mitigations

- clean-room workers for independent routes and audits;
- immutable target fingerprints;
- append-only route and failure ledger;
- exact certificates and separately written checkers;
- explicit web/search and attribution logs;
- formal target test lemmas;
- novelty audit performed after correctness, by a different worker;
- predetermined status vocabulary and acceptance gates;
- publication of failures and denominator statistics, not only wins.
