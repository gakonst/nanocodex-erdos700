# Adversarial referee: focused direct-classification attempt

## Verdict

**Accept the negative closure verdict.  Reject every proposed positive endpoint
that stops at `BoundarySafe`, quotient spectra, a cylinder cover, a least-CRT
minimum, `FactorTableau`, `ExplicitG`, automaton reachability, or solver
feasibility.**

No exhaustive factor-readable branch theorem eliminating the shared multiplier
was produced.  The new predecessor identity and CRT normal form are correct,
but neither is the requested classification.

## Corrections required before acceptance

1. The quotient-spectrum equivalence needs the witnessed-baseline hypotheses.
   It applies in particular to a proper prime-power divisor, hence to the
   maintained largest prime for a composite and to the historical greatest
   exact component away from prime powers.  It is false for an arbitrary
   divisor: at $n=30$ and $q=6$, all spectrum intersections have only their
   endpoints, but $f(30)=6\ne30/6$.
2. The token-refinement lemma must state $0\le x\le N$.
3. A request to “evaluate the short-CRT minimum explicitly” is a completion
   contract, not yet a proved lemma.  Success requires the evaluator's actual
   clauses, a decreasing measure, and an exhaustive proof.
4. The 1978 greatest-prime-power baseline must remain primary, and $n=12$
   must continue to separate it from the maintained largest-prime baseline.
5. The public map must call `FactorTableau` and `ExplicitG` exact feasibility
   encodings, not a completed direct classification, and must expose the
   short-CRT evaluator obligation.

The research report and public map incorporate all five corrections.  A final
adversarial reread returned **ACCEPT** with no remaining objection.

## Formula audit

For $n=dc$, $p^e\mathrel{\Vert}d$, and $D=d/p^e$, the following chain is
correct for $1\le m<c$:

\[
v_p\binom n{dm}
=v_p\binom{Dc}{Dm}
=v_p(c)-v_p(m)+v_p\binom{Dc-1}{Dm-1}.
\]

Consequently the base-$p$ boundary condition is exactly

\[
v_p\binom{Dc-1}{Dm-1}\le v_p(m).
\]

The accepted local conditions are periodic digit cylinders with pairwise
coprime prime-power periods.  Taking the least positive CRT representative of
a tuple of accepted residues is therefore exact, and a boundary is realized
exactly when that least representative is at most $\lfloor c/2\rfloor$.
Computing that minimum by searching residue tuples is nevertheless the banned
shared-witness test.

## Independent finite checks

The focused checker confirms:

- $n=40,d=10$: $A_2=\{2\}$ and $A_5=\{1\}$;
- $n=120,d=12$: $A_2=\{2,3,4\}$ and $A_3=\{1,3\}$, with unique common
  multiplier $3$;
- $n=136,d=34$: unique common multiplier $2$;
- $n=195,d=15$: unique common multiplier $2$, coprime to $195$, with prime
  cofactor $13$;
- $n=1470,Q=49,d=70$: every pair among the three displayed local sets
  intersects, but their triple intersection is empty (another boundary still
  makes $1470$ a failure, so this is only a local non-Helly example);
- $n=1694,Q=121$: boundaries $154,242,847$, of which only the
  three-active-prime boundary $154$ is realized;
- $n=10605,Q=101$: all four boundaries are unrealized, although the three
  local sets for $d=105$ intersect pairwise;
- $n=210,d=10$: unique multiplier $8$, lost after either indicated inactive
  cofactor component is deleted;
- $n=31\cdot47\cdot1307,d=31\cdot47$: unique multiplier $652$ in a range
  ending at $653$;
- $n=180880,Q=19,d=20$: unique multiplier $4100$, while every proper divisor
  of $4100$ fails.

These are exact finite regressions, not an asymptotic or unboundedness theorem.

## Accepted frontier

The one remaining proof obligation is to exhibit a concrete well-founded
digit evaluator $\mathsf L(F,e)$, with no multiplier or residue-tuple search,
and prove that it equals the least-CRT quantity $\lambda(n,d(e))$.  Once such
an evaluator exists, the checked boundary theorem immediately yields the
historical classification (with the prime-power failure branch) and then the
maintained specialization.  Until its clauses and proof exist, Part (i) is not
closed under the stricter reviewer standard.
