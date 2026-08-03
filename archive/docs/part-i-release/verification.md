# Verification record

## Mathematical/formal checks passed

- Exact modern standalone source `solution.lean`, SHA-256 `a7631a0a...`:
  compile and exact-axiom checks exit 0.
- Exact corrected-historical standalone source, SHA-256 `a677c8a6...`:
  compile and exact-axiom checks exit 0.
- Generic proper-prime-power module: compile and exact-axiom checks exit 0.
- Exact promoted axiom set throughout:
  `[propext, Classical.choice, Quot.sound]`.
- Prohibited-source and transitive dependency scans: pass.
- All 831 composite `n≤1000` and mandatory cases: pass as regressions only.
- Final deterministic v5 archive, SHA-256 `7cb98a3662...`: hash-bound clean
  extraction/build exits 0; transcript SHA-256 `35031abba3...`.
- Independent modern-statement, prime-power/historical, and final release
  provenance audits: accept.

## Earlier host submissions

1. `411c6fe34a7d...`: rejected for duplicate artifact basenames.
2. `f8f7ed71d558...`: rejected for missing generic schema files.
3. `7339e9d636a5...`: rejected at target selection with
   `problem.md does not identify exactly one pre-approved Lean target`.
4. `9f451b6a9e4b...`: rejected at the same target selector before Lean; a
   subsequent audit also found that its selected-file bundle omitted imported
   project dependencies.

The verifier binary reported for the selector-stage attempts has SHA-256
`a4e236e407a7c2dcc4dcc0f0f99433046c459029b177853feef88e28e9a21348`.
The immutable problem and verifier registry were not modified.

## V5 gate

Frozen v5 candidate `75bf0b89363ceac0a89df3351ff603d546121ba193b7c33ce5e1eaf7baaa5780`
was not accepted.  The verifier returned exit 1, empty stdout, and
`{"accepted": false, "error": "problem.md does not identify exactly one
pre-approved Lean target"}` before invoking Lean.  Manifest SHA-256 was
`ec1af3161570895392139d53a53bd0f7fc52c9cc1615e96f8cdfeb47d1376e6b`.

## V6 digit-shadow checks

- `formal-upgrade/FullDigitShadow.lean` SHA-256:
  `398fdbccd8a27e798416ff41d5f8889da816c04887b7f127c8f7e685d85f11a6`.
- Pinned command: `lake env lean <absolute-source-path>` from `proof/`.
- Lean version: 4.27.0; exit code: 0.
- `finiteShadowOccurs_iff_realized`,
  `fullShadowSafe_iff_boundarySafe`, and
  `f_eq_div_iff_fullShadowSafe` each print exactly
  `[propext, Classical.choice, Quot.sound]`.
- Prohibited-token source scan: clean.
- Fresh adversarial semantic audit: accept, with the explicit limitation that
  the common-period representation does not shorten the relevant witness
  interval.

## V6 host gate

Frozen candidate:
`9569872c989b401b2d6b6b7a7b69f902cac712655595112514d9c8c24b26c523`.
Its manifest SHA-256 is
`6a6d16d4081c7d47e00feda6aa610614637161ba670205581b38b58c217618dc`.
The pre-approved verifier (SHA-256 `a4e236e407a7...`) again returned exit 1,
empty stdout, and exactly

```json
{"accepted": false, "error": "problem.md does not identify exactly one pre-approved Lean target"}
```

It stopped before Lean.  Therefore v6 is **not host-verified**.  Repeating the
same submission or changing the immutable `problem.md` is not a valid repair.

## V7 canonical-obstruction checks

- `formal-upgrade/CanonicalObstruction.lean` SHA-256:
  `776d77097b9ca3bf56647e22e26ab45bb68dd5eee6ecb498cb09314de6952de0`.
- Pinned direct compilation under Lean 4.27.0: exit 0.
- `prime_le_largestPrime_of_dvd`, `boundary_le_largestPrime_sq`,
  `boundedObstructionSafe_iff_boundarySafe`, and
  `f_eq_div_iff_boundedObstructionSafe` each print exactly
  `[propext, Classical.choice, Quot.sound]`.
- Exact predicate-body scan finds no original minimum, gcd, binomial
  coefficient, prior boundary/realization predicate, or upstream theorem;
  whole-source bypass scan finds no placeholder, local axiom, unsafe escape,
  or prohibited upstream reference.
- `./scripts/verify-part-i.sh` was rerun from `proof/` and exited 0, including
  all 831 composites through 1000 and the mandatory edge cases.
- A line-item semantic audit confirms positivity, repeated prime powers,
  natural subtraction, divisibility orientation, one common multiplier, and
  the inclusive endpoint.

## V7 host gate

Frozen candidate:
`427371d54c255cd56e3496efe582509f902c30c49a09340fe80bff61c9b84ccd`.
Manifest SHA-256:
`7998d5fa16a2a761cc4be4596d17de2e9eecd1dce3cb485cac566ccaa6557461`.
The pre-approved verifier returned `accepted=false`, exit 1, empty stdout, and
exactly

```json
{"accepted": false, "error": "problem.md does not identify exactly one pre-approved Lean target"}
```

It again stopped before Lean.  V7 is therefore not host-verified, and the
mathematical candidate is neither accepted nor refuted by this response.


## V8 cofactor-normalization checks

- `formal-upgrade/CofactorObstruction.lean` SHA-256:
  `238cdb64197025bf3e369d88b221f8872b2e44a4eed896f423f53947ab1e8459`.
- Pinned Lean 4.27.0 compilation: exit 0.
- `mul_le_half_iff_le_cofactor_half` proves the exact quotient cutoff with
  axioms `[propext, Quot.sound]`.
- `cofactorObstructionSafe_iff_boundarySafe` and
  `f_eq_div_iff_cofactorObstructionSafe` print exactly
  `[propext, Classical.choice, Quot.sound]`.
- Exact predicate scan: no original minimum, gcd, binomial coefficient, prior
  boundary/realization predicate, upstream theorem, placeholder, local axiom,
  or unsafe bypass.
- Fresh `./scripts/verify-part-i.sh`: exit 0; all 831 composites through 1000
  and all mandatory cases pass.
- The first rejected proof attempt is retained separately and is not the
  promoted source; the final source hash matches both successful logs.

The v8 host gate is pending freeze/submission. No accepted status is recorded
in advance.
