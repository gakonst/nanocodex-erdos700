> Recovery note (2026-08-03): this is the dedicated Ubuntu campaign's retained verification record. Its host-gate status was caused by a missing target-registry entry; the promoted Lean modules are now checked directly by this repository's canonical verifier.

# Verification record

## Environment

The pinned environment report is math-env-report.log. The project uses Lean
4.27.0 and Formal Conjectures revision
e751934294a381afd2d5fc1124c5953c8e25f9fa. Raw output is retained under
verification-logs/.

## Complete proof checks

All of the following exited zero:

1. lake env lean PartIWork/BaselineBoundary.lean
2. lake env lean QWitnessProbe.lean
3. lake env lean PartIWork/HistoricalPrimePower.lean
4. lake build PartIWork.HistoricalPrimePower
5. lake build HistoricalPartI
6. lake env lean HistoricalPartIVerify.lean
7. proof/scripts/verify-historical-part-i.sh
8. standalone compilation of release/solution.lean from the pinned Formal
   Conjectures root
9. standalone exact-type and axiom audit.

The promoted source has no exact-token occurrence of sorry, admit, axiom, or
unsafe, no sorryAx dependency, and no invocation of the upstream open Part (i)
theorem. Campaign.result depends exactly on propext, Classical.choice, and
Quot.sound. The original dedicated script emitted the required verdict:

    HISTORICAL PART (i) FORMALLY VERIFIED

## Secure trusted-target check

An earlier proposed verifier design appended target syntax after candidate
source. That representation was rejected as unsound: a candidate-local
high-priority LT Nat instance can make a false target vacuous.

The repaired architecture uses three modules:

- HistoricalTarget.lean, containing the exact verifier-owned proposition;
- Candidate.lean, byte-identical to release/solution.lean;
- Check.lean, importing both and requiring Campaign.result to have Target.

Command:

    workspace/proof/scripts/verify-secure-historical-target.sh

Result:

    HistoricalTarget.lean: OK
    Candidate.lean: OK
    CANDIDATE_SOURCE_SCAN=PASS
    certificate axioms: [propext, Classical.choice, Quot.sound]
    SECURE_TARGET_MODULE_ISOLATION=PASS
    HISTORICAL PART (i) FORMALLY VERIFIED

Raw log: verification-logs/verify-secure-historical-target.log.

The focused negative test first compiled a textually similar theorem made
vacuous by a local false less-than instance, then attempted to assign it to the
already elaborated Target. Bridge compilation failed with the expected kernel
type mismatch and the harness emitted ISOLATION_TEST=PASS. Raw log:
verification-logs/secure-target-isolation-test.log.

Two independent retained workers returned ACCEPT on statement alignment,
definitional equality, import order, namespaces, instance isolation, forbidden
constructs, and axiom closure.

## Exact regression

historical-regression/regression.py used arbitrary-precision integer binomials.
summary.json records 831 composite inputs through 1000, zero historical target
mismatches, and zero mismatches among 512,108 carry/valuation comparisons.
This is explicitly non-universal corroboration.

## Host gate history

Frozen candidate v1:
d76ea2a166acfe5ab8264ba45e0f304f849e4617ed592d67ed9345ce672f0d07.

Host attempt 1 returned exit code 1 and accepted=false with:

    problem.md does not identify exactly one pre-approved Lean target

Inspection of the retained verifier established that its registry contains
700(ii), 156, 579, and 700(iii), but no historical 700(i). Dispatch reads
immutable problem.md independently of candidate artifacts. It reads and scans
`solution.lean` first, but target selection is unaffected by those bytes and
occurs before Lean elaboration, so candidate-side reformatting cannot repair it
honestly. Full output is verification-logs/host-verifier-result.json.

The revised frozen bundle supplies a fully checked application-registration
reference, but production registration remains host-owned. Until the
pre-approved verifier selects and accepts this exact target, the campaign must
not claim host-verified status.

## Revised frozen candidate and host attempt 2

Revised candidate ID:

    5b380d7f8e18dcd2417dcce056f6c4c7a57e9a6b6c28d54a392d4d4bff88f6a2

Manifest SHA-256:

    e6bbe90e16f5decc9aeecd94e3a10ff92d876498b1d37c392b250990681c5952

The pre-approved verifier again returned exit code 1 and accepted=false with
the identical target-selection error. Full structured output is
verification-logs/host-verifier-v2-result.json. It hash-validated and scanned
the required solution artifact, but it did not invoke Lean or check the new
target/bridge proof.

Post-freeze audit found no proof defect. The final adversarial referee rejected
host promotion for exactly one reason: a candidate-supplied target cannot
create a host trust anchor. No mathematical lemma remains unproved. The exact
missing certificate is a host-owned registration of the frozen historical
Target followed by accepted=true bound to the revised candidate manifest.

## Closure disposition

All 18 worker prompts and all 3 supervised exact-job slots have been used.
Both honest candidate-side representations have been exhausted: appending
target syntax is unsound, while separate elaboration is sound but cannot alter
pre-dispatch. Since the mandatory host gate did not pass, closure status is
blocked despite the complete kernel-accepted theorem.

## Turn 3: verifier-contract normal form

Host attempt 2 falsified the candidate-side registration assumption but also
exposed a separate interface issue: v1/v2 exported Statement, whereas every
live verifier template has shape answer(candidate-answer) ↔ Statement.
Candidate v3 changes only the final export to answer(True) ↔ the unchanged
historical theorem.

The following new checks exited zero:

1. separate builds of ContractTarget.lean and ContractCandidate.lean;
2. ContractCheck.lean, whose certificate has exactly the three allowed axioms;
3. ContractAlignment.lean, proving by Iff.rfl that the v3 right-hand statement
   is definitionally identical to the v2 audited target;
4. verify-historical-contract.sh, which hash-pins source and target, scans
   forbidden constructs, compiles, checks axioms, and emits
   HISTORICAL PART (i) FORMALLY VERIFIED;
5. reference-historical-verifier.py on the local v3 manifest;
6. run-contract-tests.sh, which rejected a mutated problem hash and a local
   false-less-than instance attack.

The reference verifier returned accepted=true for solution SHA-256
cecf2458..., immutable problem SHA-256 6e442a9d..., trusted target SHA-256
7389d4bf..., and exactly [Classical.choice, Quot.sound, propext]. This is strong
deterministic evidence but is not the application-owned host gate.

The current live verifier SHA-256 a4e236e4... still has zero historical-700(i)
registry matches. Candidate v3 will be frozen and submitted anyway so that any
host result is bound to the exact contract-normalized bytes.

## Frozen candidate v3 and host attempt 3

Candidate v3 was frozen as
`f50aad5de57152503dd3eff6ad5d7083e7eed2b25883e0f6315d5bdabbe62059`;
its manifest SHA-256 is
`a4f71dbec4533a79250120d9e9b875f8dcb7411f4656a33ae3fbed312bfad56f`.
The pre-approved verifier returned `accepted=false`, exit code 1, with the
same pre-Lean target-selection error:

    problem.md does not identify exactly one pre-approved Lean target

Full structured output is `verification-logs/host-verifier-v3-result.json`.
This establishes that contract normalization was not sufficient to overcome
the absent host registry entry. The live verifier scanned the source but did
not elaborate the proof. The formal candidate remains a strong candidate; the host-verifier
route is blocked on exactly one external certificate: a verifier-owned binding
from problem SHA-256 `6e442a...` to target SHA-256 `7389d4...`, followed by an
`accepted=true` run on the frozen manifest.

## Turn 4: universal fixed-pair feasibility certificate

Rather than submit a fourth proof-equivalent wrapper, turn 4 audited the exact
live verifier source and execution order. The fail-closed generator in
`verifier-feasibility/verifier_feasibility_certificate.py` pins the complete
verifier and problem hashes, parses but never imports the verifier, extracts
its literal target registry, and validates the relevant AST dataflow.

The resulting `verifier-feasibility/certificate.json` establishes that:

- all four registered marker-membership tests are false, so match count is 0;
- `select_target` requires match count exactly 1 and otherwise raises the
  error seen in all three host attempts;
- the problem comes from `manifest.parent.parent/problem.md`;
- candidate solution bytes are not an argument to target selection; and
- target selection is statement 9, strictly before the Lean subprocess in
  statement 13.

Thus malformed candidates fail earlier, while every candidate passing the
earlier artifact and source checks fails at dispatch. No candidate-side bytes
can receive `accepted=true` under this verifier/problem pair. The reproducible
test suite passed and rejected mutations of either trust anchor. This is a
verified application-gate impossibility result, not a proof or refutation of
the mathematical theorem. It justifies not freezing a fourth equivalent
candidate: the complete candidate of record remains frozen v3.

## Turn 5: alternate order-duality candidate v4

Turn 5 left verifier-interface work and proved a new direct bridge:

    gcd(n,choose(n,k)) < n/B
      iff
    B < residueCarryWeight(n,k)

for every positive divisor baseline `B` and admissible `k`.  Combining this
strict order reversal with the minimal boundary-divisor bridge gives

    HistoricalBoundarySafe_B(n)
      iff
    forall admissible k, n/B <= gcd(n,choose(n,k)).

The new complete theorem obtains `f(n)=n/Q(n)` from these lower bounds and the
exact `k=Q(n)` witness.  Its reverse direction uses the defining lower-bound
property of the minimum `f`.  The composite-prime-power branch remains
explicit.

Promoted source:

    release-v4/solution.lean
    SHA-256 0720960ed86834c8cf2dda9e7b4777d447a5bac07eefa0bb8821035905ef61eb

The standalone source scan passed and compilation exited zero.  The axiom
audit reports exactly `[propext, Classical.choice, Quot.sound]` for the strict
order lemma, obstruction existential, gcd lower-bound theorem, alternate main
theorem, and `Campaign.result`.

The first dedicated-script run failed only because `pp.width` is not a Lean
4.27 option; removing that presentation setting left the mathematics
unchanged.  The corrected script exited zero and emitted
`ORDER_DUALITY_AXIOM_AUDIT=PASS` and the required historical verdict.  Raw log:
`verification-logs/verify-order-duality-historical-v2.log`.

The first two-olean target-alignment invocation used the wrong Lean package
root and was rejected before compilation.  The corrected isolated-root run
compiled byte-identical copies of canonical target SHA `7389d4bf...` and v4
source SHA `0720960e...`; the adapter
`Historical700iContract.Target := Campaign.result` compiled with exactly the
three permitted axioms.  Raw log:
`verification-logs/order-duality-target-alignment-v2.log`.

The GitHub Actions workflow now invokes the dedicated v4 script.  Candidate v4
is mathematically complete and ready to freeze, but host status remains pending
until the pre-approved verifier is called on its immutable manifest.

## Turn 5 host submission 1 (v4 full bundle)

- Candidate: `a1ab41b55c6037918214149540eec22389e08d1aa6d38d9e55066ae0ac8622cd`
- Manifest SHA-256: `44f5a0e65c27a6681dfbedc460e12a66fa6261d78644e1a9eb1df79ec42d065b`
- Host result: `accepted=false`, exit 1.
- Exact error: `duplicate frozen artifact basename: TargetAlignment.lean`.
- Scope: staging failed before target dispatch or Lean.  The mathematical
  candidate was not inspected.  A second frozen bundle will retain all
  load-bearing evidence while enforcing globally unique basenames.

## Turn 5 host submission 2 (v4 focused bundle)

- Candidate: `103ac0a9ae9b582e66169cd21c00c9d59c8f8d501d83db94d5993066965ec76b`
- Manifest SHA-256: `1728f4a8abc6b613bdb1457d8369d1ea57d2fd4684a5de52a0f7ad1a8495e266`
- Bundle audit: 47 artifacts, 47 distinct basenames.
- Host result: `accepted=false`, exit 1.
- Exact error: `problem.md does not identify exactly one pre-approved Lean target`.
- Interpretation: the staging repair worked and exposed the same
  candidate-independent registry failure as attempts 1--3.  The verifier did
  not invoke Lean.

## Turn 6: extremal admissible-carry candidate v5

Turn 6 changed mathematical representation.  It defines the finite supremum
`admissibleCarryMaximum n` of residue-carry weights over the half interval,
proves that carry safety is the inequality `M(n)<=Q(n)`, and uses the exact
`k=Q(n)` witness to upgrade that inequality to `M(n)=Q(n)`.  The parameterized
boundary theorem identifies the same equality with historical boundary
safety.  The final theorem explicitly excludes composite prime powers.

Promoted source:

    release-v5/solution.lean
    SHA-256 7ef86a9b24b5f03254e5bf7c1018a17fa4dbd24c4711bf910351d390ba618f30

The first fresh-project CI probe exposed a packaging precondition: direct
`lake env lean` cannot find an unbuilt FormalConjectures module.  Its transient
`.lake` tree was removed, and the workflow was repaired to run
`lake build ExtremalHistorical` before the dedicated audit script.  The
repaired script then exited zero against the pinned built environment and
printed both `EXTREMAL_AXIOM_AUDIT=PASS` and
`HISTORICAL PART (i) FORMALLY VERIFIED`.

The exact axiom reports for the new maximum, all bridge lemmas, the extremal
main theorem, and `Campaign.result` are
`[propext, Classical.choice, Quot.sound]`.  The source audit verifies fixed
hashes, forbidden-token absence, route independence, canonical-target
identity, and workflow exercise.  The isolated canonical target adapter also
compiles with exactly the allowed axioms.

The retained finite regression was not rerun: its compact summary was audited
and still records zero historical-target mismatches, zero carry/valuation
mismatches, and all mandatory outcomes through composite `n<=1000`.

Host submission remains pending.  The local verdict cannot be promoted above
strong-candidate unless the pre-approved verifier accepts the frozen v5
manifest.

### Host attempt 6

Frozen candidate:
`78d0f6ad8611f00746a1c8cd435f076e9e9d678f1fa599e2e3b0c97e666f03ad`.
Manifest SHA-256:
`419728ae76868afdc44742c5ad69a1f29be8d5a8f52e22c72b2b44be399e4fb5`.
Verifier SHA-256:
`a4e236e407a7c2dcc4dcc0f0f99433046c459029b177853feef88e28e9a21348`.

Result: `accepted=false`, exit code 1. Exact stderr payload:

    {"accepted": false, "error": "problem.md does not identify exactly one pre-approved Lean target"}

The failure occurred at immutable-problem target dispatch before Lean. It
neither ran nor rejected the formal proof. The retained fixed-pair
certificate records zero registered targets matching this problem hash.
Consequently no candidate-byte repair can pass the current host gate.
