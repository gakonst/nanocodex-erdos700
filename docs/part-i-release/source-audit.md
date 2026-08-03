# Source and statement audit

## Statement provenance

The retained 1978 Erdős--Szekeres paper defines the denominator using the
greatest **prime power** dividing `n`.  The maintained Problem 700 page, the
pinned Formal Conjectures file, and immutable `problem.md` instead use the
largest **prime factor**.  They are different: direct evaluation gives
`f(12)=3`, while the two baselines are `Q(12)=4` and `P(12)=3`.

The candidate's required entry point proves exactly the immutable modern
statement.  A separate stronger theorem in the bundle handles the literal
1978 statement, including its prime-power exception; the two claims are never
conflated.

## Exact standalone source audit

`solution.lean` has SHA-256
`a7631a0a76fd15d5ec4ec44550e29e9821208cadd853171607a26f7d83b0e555`.
It imports only the pinned Formal Conjectures statement and four Mathlib
modules, reproduces every local definition and bridge lemma needed for the
proof, and ends with exactly one promoted `Campaign.result` of the requested
type.  It does not import the repository's Part-I work files.

The retained scanner reports no `sorry`, `admit`, local `axiom`, `constant`,
`opaque`, `unsafe`, syntax/elaboration bypass, `sorryAx`,
`set_option google.answer`, or reference to
`Erdos700.erdos_700.parts.i`.  Compilation of the exact bytes and a separate
axiom-printing copy both exit 0.  The only transitive axioms printed are
`[propext, Classical.choice, Quot.sound]`.

The historical standalone source has SHA-256
`a677c8a62a18ceaa5327944550500ede916020df92d98a0e48a959c6db80108c`.
Its modern and historical promoted results both have the same standard axiom
set and no prohibited open-theorem reference.  It uses the independently
proved prime-power evaluation only to discharge the genuine `Q(n)=n`
exception.

Compilation proves the encoded terms, not novelty or social acceptance.  The
primary-source wording comparison and characterization judgment remain
separate in `historical-characterization-report.md`.

## Canonical bounded-obstruction source

`formal-upgrade/CanonicalObstruction.lean` has SHA-256
`776d77097b9ca3bf56647e22e26ab45bb68dd5eee6ecb498cb09314de6952de0`.
The exact definition body of `BoundedObstructionSafe` was separately scanned:
it contains no `Erdos700.f`, gcd, binomial coefficient, `Boundary`,
`Realized`, `BoundarySafe`, or upstream open theorem.  A whole-file bypass
scan also found no placeholder, local axiom, unsafe mechanism, or prohibited
open-theorem reference.  Direct compilation exits 0 and prints exactly the
standard three axioms for all four promoted declarations.  The scan transcript
is `formal-upgrade/canonical-obstruction-source-audit.log` and the compile
transcript is
`formal-upgrade/canonical-obstruction.compile-and-axioms.log`.
