# Final v5 release-audit summary

The initial v5 archive `ed2775e9...` was rejected as a release because its
workflow called an omitted Part-(ii) script.  The repaired archive is
`7cb98a3662c2815d8be59cdf977bdd0d6063e1cbc8f4dedf48107a4974a5f384`;
its workflow invokes the included root `verify-v5.sh` Part-(i) gate.

A second audit required the rebuild transcript itself to identify the archive
and decisive internal bytes.  The final transcript, SHA-256
`35031abba3d910f78c1e3523967052ef82ed89ff57b763921c4101d996986dcf`,
checks the archive hash, prints the extracted manifest/workflow/gate hashes,
checks all 31 internal hashes, and then performs the complete clean rebuild.
It finishes `BOUND_REBUILD_EXIT_CODE=0`.  The corresponding binding manifest
has SHA-256
`66a2db25063ece990e315ec8ceca44866f48beb839c41af39d0c676820f65de1`.

Independent Agent 8 rechecked these exact values and returned **RELEASE
ACCEPT**: archive/log provenance, pinned environment, modular builds,
831-composite regression, prime-power and standalone checks, exact axiom sets,
and successful exit were all present.  This acceptance concerns reproducible
release provenance; mathematical and statement correctness are covered by
separate audits.
