# Formal dependency and reproducibility report

## Promoted formal entry points

1. `Erdos700PartI.f_eq_div_iff_boundarySafe` has the exact immutable type.
2. Standalone `Campaign.result` repeats the complete modern proof without
   importing the local Part-I development.
3. `Erdos700PartI.f_eq_div_primePow_iff_boundarySafeAt` proves the proper
   prime-power strengthening.
4. `HistoricalPartIRelease.result` proves the corrected literal-1978 theorem.
5. `Erdos700PartI.f_eq_div_iff_fullShadowSafe` proves the independent finite
   digit-shadow formulation.

Every promoted declaration prints exactly

```text
[propext, Classical.choice, Quot.sound]
```

## Dependency audit

The complete transitive local Part-I closure was scanned for `sorryAx`,
`sorry`, `admit`, local axioms/constants, opaque or unsafe bypasses, forbidden
elaboration tricks, and use of `Erdos700.erdos_700.parts.i`; none occurs in the
candidate dependencies.  Mutation tests show that the scanner rejects each
prohibited class.  Unrelated placeholders elsewhere in Formal Conjectures do
not occur in the printed transitive axiom sets.

The standalone modern source SHA-256 is
`a7631a0a76fd15d5ec4ec44550e29e9821208cadd853171607a26f7d83b0e555`;
the historical source SHA-256 is
`a677c8a62a18ceaa5327944550500ede916020df92d98a0e48a959c6db80108c`.
Their retained compile/axiom and source-scan logs all exit 0.

The digit-shadow source SHA-256 is
`398fdbccd8a27e798416ff41d5f8889da816c04887b7f127c8f7e685d85f11a6`.
Its direct pinned compile exits 0; the bridge, predicate-equivalence, and final
theorem all print exactly the same standard axiom set.  A separate source scan
finds no `sorryAx`, `sorry`, `admit`, local axiom, unsafe declaration, or use
of `Erdos700.erdos_700.parts.i`.

## Deterministic v5 release

The v4 selected-file bundle was not artifact-only reproducible: an imported
`BaselineBoundary` module and pinned project/build files were absent.  V5
changes representation to one deterministic archive containing the entire
local dependency closure and verification surface.

| item | SHA-256 |
|---|---|
| `erdos700-part-i-release-v5.tar.gz` | `7cb98a3662c2815d8be59cdf977bdd0d6063e1cbc8f4dedf48107a4974a5f384` |
| bound fresh-rebuild transcript | `35031abba3d910f78c1e3523967052ef82ed89ff57b763921c4101d996986dcf` |
| exact rebuild command | `7b4bf20ff46a8b11f322e0d82fab6490b86cbac276391ef843d4df9135b73013` |
| evidence-binding manifest | `66a2db25063ece990e315ec8ceca44866f48beb839c41af39d0c676820f65de1` |

The bound transcript first validates the archive hash, then prints and checks
the extracted internal manifest (`3464d86f...`), workflow (`6a32fff8...`),
gate (`5ec226d9...`), and every listed file.  From that extraction it restores
the lockfile revisions, reports Lean 4.27.0/Lake 5.0.0, builds the modular and
standalone proofs, scans dependencies, and runs all 831 composite cases through
1000 plus the four mandatory regressions.  It ends
`BOUND_REBUILD_EXIT_CODE=0`.

An earlier hash-bound rerun stopped with `ENOSPC`; its separate failed log is
retained and is not success evidence.  After ephemeral build deletion, the
same exact command completed.  This distinguishes environmental failure from
the successful certificate.

## CI and independent release audit

The first v5 archive's workflow invoked an omitted Part-(ii) script.  The final
archive instead uses `leanprover/lean-action@v1`, points it at `proof/`, and
runs root `./verify-v5.sh`; it does not pretend to build an unrelated default
target.  Independent re-audit checked the exact final hashes and accepted the
archive-to-log binding, pinned environment, builds, regressions, and axiom
output.  No hosted GitHub run for these uncommitted bytes is claimed; the
fresh-extraction transcript is the executable release certificate.

## Host integration limitation

All host submissions so far, including frozen v5 after its three
content-addressed audits, were rejected before Lean because the verifier's
immutable target registry did not select Erdős 700(i).  That external target
selection result is neither kernel acceptance nor evidence against the proof.
The digit-shadow route changes the mathematics rather than repackaging, but it
cannot alter that external registry.  Host success is claimed only for an
exact final manifest receiving exit status zero.
