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

## Evidence examples

| Claim | Evidence |
|---|---|
| Tests pass | Exact command, exit code, relevant output. |
| Bug fixed | Reproducer fails before and passes after; ideally revert-fix red proof. |
| UI works | Browser/manual steps, screenshot/path if available, observed behavior. |
| Build ready | Build command and result. |
| Review complete | Files/SHAs reviewed and verdict with severity. |
| No debug logs remain | grep command for debug prefix returns no matches. |

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

## Final response template

```text
Changed: [files/behavior]
Verified: `[command]` → exit [code/status]; [relevant output]; proves [claim]; does not prove [limits]
Not verified: [anything omitted and why]
Notes: [risks/follow-up]
```
