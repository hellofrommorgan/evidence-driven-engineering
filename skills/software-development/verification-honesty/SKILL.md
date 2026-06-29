---
name: verification-honesty
description: "Use before reporting completion, success, readiness, or passing status; requires fresh verification evidence in the same message and forbids unverified completion language."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [verification, honesty, completion, evidence]
    related_skills: [falsifiable-goals, test-driven-development, diagnostic-debugging]
---

# Verification Honesty

## Overview
Claiming completion without verification is dishonesty, not efficiency. Completion is not a feeling; it is evidence.

## Iron law

```text
NO COMPLETION CLAIM WITHOUT FRESH VERIFICATION EVIDENCE.
```

If you did not run or inspect the verifying check in this message/turn, you cannot claim it passes.

## Forbidden completion language without evidence

Don't write these unless immediately backed by fresh verification:

- done
- fixed
- works
- passing
- ready
- should work
- should now work
- probably
- seems to
- looks good
- great/perfect as a substitute for evidence

Use honest alternatives:

```text
Implemented. Verification not run because [reason]. Next required check: [command].
```

or

```text
Verified with `[command]`: [result].
```

## Gate function

1. Identify the claim you want to make.
2. Identify the minimum evidence that would make it true.
3. Run or inspect that evidence now.
4. Read the output, not just the exit code.
5. State the claim with the evidence: exact command, exit code/status, relevant output excerpt, what it proves, what it does not prove, and whether it was produced in the current turn.

If verification cannot be run, the final response must start with `Not verified:` before any completion-adjacent claim.

## UI-to-receipt completion claims

For UI controls that trigger server-owned agent/Hermes work, `POST accepted`, `run_id returned`, or a local optimistic UI flag is not completion evidence. Completion requires a durable receipt/status record and, when the UI is generated from a source-of-truth repository, a regeneration/projection check that shows the receipt or changed source state is visible in generated data/history. State this distinction explicitly: accepted/queued proves dispatch only; receipt ingestion proves outcome projection.

## Evidence examples

| Claim | Evidence |
|---|---|
| Tests pass | Exact command, exit code, relevant output. |
| Bug fixed | Reproducer fails before and passes after; ideally revert-fix red proof. |
| UI works | Browser/manual steps, screenshot/path if available, observed behavior. |
| Build ready | Build command and result. |
| Review complete | Files/SHAs reviewed and verdict with severity. |
| No debug logs remain | grep command for debug prefix returns no matches. |
| Per-run ledger correct | Multi-run/manual ledger count by run key, not just generated receipt counts. For stable entity IDs, verify `(entity_id, run_date)` or equivalent scoped uniqueness. |
| Local choice processor idempotent | Re-run the same choice and compare byte hashes/snapshots of ledgers and artifacts; event count alone is insufficient because timestamps can churn. |
| Local approval state machine safe | Attempt a different choice after a prior local choice and attempt terminal-state regression (e.g. archived → watched); both must fail before mutation with ledgers unchanged. |

## Regression test proof

For a new regression test, passing once is insufficient when feasible. Prove it detects the bug:

1. Red without fix.
2. Green with fix.
3. Red after reverting/disabling fix.
4. Green after restoring fix.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "I know it passes." | Then proving it should be cheap. Run the check. |
| "The change is small." | Small unverified claims are still unverified. |
| "The command is expensive." | State what was verified and what remains unverified. |
| "No output means success." | Record command and exit status; inspect logs when relevant. |
| "166 tests pass." | Did they pass only because I hand-set an env var/cwd/flag? Re-run as the real entrypoint runs. Rig-green ≠ real-green — see `references/test-rig-vs-real-path-green.md`. |

## Audit-report truth filtering

When the user asks to review an audit/report and "only implement the truths":

1. Treat each report claim as a falsifiable item, not as authority.
2. Probe or inspect current code before editing.
3. Add confirmed items to the active goal/QA log before or alongside fixes.
4. Implement only claims proven true or intentionally accepted as desired behavior.
5. If a claim is false or stale, do not argue midstream unless the user asked for an immediate verdict; reserve it for the final summary if requested.
6. For vocabulary/architecture ambiguities that are true concerns but not safe to resolve locally, track them as deferred decisions instead of silently changing contracts.

## Local health/autonomy harness claims

When asked whether a local-first health/autonomy harness is "working now," do not rely only on an older receipt or passing tests. Use `references/local-health-harness-verification.md`: read project-local operator docs, run fresh runner/dashboard/auth/sync/test checks, and distinguish **system health** from **domain health**. A `degraded` health report can be the correct product output rather than an infrastructure failure; inspect the report before summarizing.

For More Life autonomy hardening details — cron Python path, command-job receipt evidence, pipeline JSON recovery, and SQLite experiment projection — also use `references/more-life-autonomy-hardening.md`.

## Cron-backed local observer / harness status claims

When Morgan asks how a local project, observer, watchdog, or receipt-based harness is "running," do not stop at a cron row, one manual script run, or a stale receipt. Use `references/cron-backed-local-observer-verification.md`: verify the scheduler is alive, inspect the installed script/wrapper, check scheduler output records, inspect project-local receipts/artifacts, and when practical wait through one real scheduled tick. Report runtime health, loop behavior, domain findings, safety boundary, repo state, and limits as separate claims.

For Mind Seed / mind-vault multi-source ingest reviews, also use `references/mind-seed-runtime-review.md`: identify the active vault, enumerate source hooks, separate collection from drain/surface metabolism, inspect heartbeat/backpressure flags, and report git state separately. The common bottleneck is collection working while `_ingested` is above threshold, meaning `/surface` and promotion need attention rather than scheduler/auth/qmd changes.

## Allowlisted operational mutation claims

When a local observer/governor has already classified an operation as allowlisted and Morgan is pushing for execution rather than more proposal artifacts, do not hide behind approval-packet language. Use `references/allowlisted-operational-mutation-governor.md`: confirm the allowlist scope, take the smallest reversible mutation, write a receipt, and verify live state. If you choose not to mutate, state the specific boundary being crossed (credentials, memory, gateway auth, destructive delete, outbound send, etc.), not a vague safety concern.

## Allowlisted operational mutation claims

When a local observer/governor has already classified an operation as allowlisted and Morgan is pushing for execution rather than more proposal artifacts, do not hide behind approval-packet language. Use `references/allowlisted-operational-mutation-governor.md`: confirm the allowlist scope, take the smallest reversible mutation, write a receipt, and verify live state. If you choose not to mutate, state the specific boundary being crossed (credentials, memory, gateway auth, destructive delete, outbound send, etc.), not a vague safety concern.

## Final response template

```text
Changed: [files/behavior]
Verified: `[command]` → exit [code/status]; [relevant output]; proves [claim]; does not prove [limits]
Not verified: [anything omitted and why]
Notes: [risks/follow-up]
```
