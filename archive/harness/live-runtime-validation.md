# Live runtime validation

This is an operational evidence snapshot, not a mathematical-result claim.

## Pro event-idle policy

Campaign `runs/math-1784772124-33565` was launched with GPT-5.6 Pro/Max and a
3,600-second whole-worker deadline from a Nanocodex build in which Pro has no
application event-idle timeout. As of 2026-07-22 21:37 PDT, its retained
`events.jsonl` contained:

- 18 completed model calls whose wall duration exceeded 300 seconds, all on
  attempt 1;
- a longest completed call of 2,494.96 seconds, with first output only after
  2,402.93 seconds;
- zero idle-timeout retries;
- two retries caused by actual WebSocket send failures, at lead event sequences
  1,077-1,078 and 6,487-6,488. Both are recorded as `failure_phase=send`,
  `error_class=send_transport`, `opens_new_socket=true`, and
  `replay_mode=full_history`.
- one later server-enforced connection rotation at sequences 8,158-8,160. The
  API returned `websocket_connection_limit_reached` with the explicit message
  that a WebSocket had reached its 60-minute connection limit; Nanocodex opened
  a replacement and used `replay_mode=full_history`. This is a server socket
  lifetime, not the removed five-minute event-idle watchdog.

This demonstrates the intended distinction: silence during Pro reasoning does
not restart paid work, while a concrete broken transport or server connection
rotation still reconnects and replays committed client-owned history. The
60-minute rejection occurred immediately at a new request boundary, so no
in-progress reasoning was discarded. Whole-worker and campaign deadlines remain
the caller-owned safety boundary.

## Bash and Code Mode

The same live campaign confirms that the lead can invoke native mathematical
tools from JavaScript Code Mode. At the snapshot above, the trace contained 11
model-authored Code Mode cells explicitly requesting
`shell: "bash", login: false`, 30 nested `exec_command` results, 22 immediate
exit-zero results, and seven long-lived shell sessions. Those calls produced
the retained Nix environment reports, Sage/lrcalc scripts, exact interpolation
records, and bounded shard logs in the campaign directory.

The newer `run_exact_job` application tool is separately covered by Rust tests
that execute `/bin/bash -c`, retain and hash its result, and kill a deliberately
stalled process group. The next full campaign should exercise that typed path
instead of raw long-lived shell sessions.

## Reproduce the trace counts

Run the following from the campaign directory:

```sh
jq -s '[.[] | select(.event.type == "model.call.completed"
  and .event.payload.attempt == 1
  and (.event.payload.duration_ns // 0) > 300000000000)] | length' events.jsonl

jq -s '[.[] | select(.event.type == "model.attempt.retrying")
  | {agent, seq: .event.seq, payload: .event.payload}]' events.jsonl
```

The campaign was still active at snapshot time, so these are lower bounds.
