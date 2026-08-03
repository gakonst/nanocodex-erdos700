> Recovery note (2026-08-03): preserved as the campaign-time report. Its provisional `strong-candidate` label has been superseded by direct canonical verification in this repository; it described a missing host registry binding, not a failed proof.

# Research report: historical Erdős Problem 700(i)

## Provisional result

The formal candidate proves, for every composite natural `n>1`,

    f(n)=n/Q(n)
      iff
    not IsPrimePow(n) and HistoricalBoundarySafe(n),

where `Q(n)` is the greatest exact prime-power component.  The promoted v5
proof is locally formalized and independently aligned to the canonical target.
Its status is **strong-candidate** until the host verifier accepts its frozen
manifest.

## Proof architecture

Define `M(n)` as the maximum residue-carry weight over `2<=k<=n/2`.  Exact
factorization of every admissible binomial gcd converts the defining minimum
for `f` into the upper-bound condition `M(n)<=Q(n)`.  For non-prime-powers,
`k=Q(n)` is admissible and has weight exactly `Q(n)`, so the condition is
equivalent to `M(n)=Q(n)`.  The parameterized minimal-boundary bridge proves
that this equality is equivalent to `HistoricalBoundarySafe(n)`.

If `n=p^a` is composite, `Q(n)=n` and the checked formula gives
`f(n)=p>1=n/Q(n)`.  This branch is explicit in the final theorem.

## Load-bearing witness

When `Q(n)=p^a`, exactness gives `p` coprime to `n/Q(n)`.  The formal source
uses Lucas recursion and exact binomial identities to show both that `p` does
not divide `choose(n,Q(n))` and that `n/Q(n)` divides it.  Therefore

    gcd(n,choose(n,Q(n))) = n/Q(n),
    residueCarryWeight(n,Q(n)) = Q(n).

Off prime powers, `Q(n)<=n/2`, so the witness is admissible.

## Formal evidence

- Lean 4.27.0; Formal Conjectures revision
  `e751934294a381afd2d5fc1124c5953c8e25f9fa`.
- v5 source SHA-256:
  `7ef86a9b24b5f03254e5bf7c1018a17fa4dbd24c4711bf910351d390ba618f30`.
- canonical target SHA-256:
  `7389d4bf90f6ca7eb0b1a21618d2be8a61091bd937eadc6c5d8f6b70f70eb564`.
- exact axioms: `[propext, Classical.choice, Quot.sound]`.
- Dedicated compile/hash/forbidden-token/axiom script: pass.
- Isolated canonical-target adapter: pass.
- GitHub Actions explicitly builds and audits the dedicated root.
- Promoted-route audit confirms no call to the earlier final theorem or v4
  order-duality route.
- Exact finite regression over every composite `n<=1000`: zero target and
  carry/valuation mismatches; this is corroboration, not the universal proof.

Mandatory cases are correct: `8` fails; `12` has historical equality but not
modern equality; `18` uses `Q=9`; `30` is an equality case; `78` preserves the
included endpoint obstruction; `136` requires multiplier two.

## Statement and adversarial alignment

The retained 1978 source uses the greatest prime power dividing `n`, not the
largest prime divisor.  `HistoricalRealized` retains a single multiplier for
all primes and the inclusive half-interval endpoint.  The canonical target was
compiled as an isolated module and accepted the byte-identical candidate
adapter with only the permitted axioms.  Prior blind and alignment auditors,
plus the new route-independence audit, found no quantifier or prime-power
substitution.

## Contributions

AI contribution: exact-component witness, generic exact-weight and boundary
bridges, extremal maximum representation, Lean proof, regression certificate,
and adversarial release audits.

Human/operator contribution: primary-source correction, immutable target,
mandatory cases, and release requirements.

Host contribution: worker isolation, supervised computations, immutable
freezing, evidence ledger, and pre-approved verifier.

## Novelty and limitation

Discovery-phase web search was disabled, so no novelty claim is made; a clean
novelty auditor is separate.

The pre-approved verifier's retained registry has no historical-700(i) target.
Prior candidates were rejected before Lean.  The exact external dependency is
a host-owned binding from immutable problem SHA
`6e442a9d9164075cfe02f0fd419c4a59f2246131abcaf9401d10c87d3ea80fc7`
to canonical target SHA `7389d4bf...`, followed by `accepted=true` on this
frozen candidate.  Local formal success alone does not satisfy that gate.


## Final host disposition

The v5 extremal bundle was frozen as
`78d0f6ad8611f00746a1c8cd435f076e9e9d678f1fa599e2e3b0c97e666f03ad`.
Attempt 6 again failed at pre-Lean target dispatch with exit code 1. Therefore
the campaign verdict is **strong-candidate**, not verified. The complete
formal proof is retained, but the mandatory host gate did not pass.
