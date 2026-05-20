---
name: diagnostic-debugging
description: "Use for bugs, flaky tests, failed builds, incidents, and surprising behavior; builds the feedback loop first, ranks falsifiable hypotheses, instruments with unique tags, and fixes only after root cause."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [debugging, diagnosis, root-cause, feedback-loop]
    related_skills: [falsifiable-goals, test-driven-development, verification-honesty, architecture-deepening]
---

# Diagnostic Debugging

## Overview
Build the right feedback loop and the bug is mostly fixed. Debugging without a loop is guessing with extra steps.

## Iron law

```text
NO FIX WITHOUT A FEEDBACK LOOP AND ROOT-CAUSE INVESTIGATION.
```

## Phase 1: Build the loop

Choose the sharpest loop available:

1. Focused failing test.
2. Minimal reproducer script.
3. One command that fails deterministically.
4. Browser/API repro with exact steps.
5. For nondeterministic bugs: a loop that increases reproduction rate and records attempts.
6. Human-in-the-loop script as last resort.

Make the loop fast, deterministic, and specific. If you cannot build it, stop and report that as the finding.

## Phase 2: Rank hypotheses

Before changing code, list 3-5 falsifiable hypotheses:

```text
1. [Most likely] because [evidence]. Test by [minimal check].
2. [Next] because [evidence]. Test by [minimal check].
...
```

Change one variable at a time. Don't stack fixes.

## Phase 3: Instrument carefully

When adding debug logs:

- Prefix every log with one unique tag, e.g. `[DEBUG-a4f2]`.
- Record the exact grep cleanup command before adding logs.
- Log boundaries and state transitions, not noise.
- Remove all instrumentation before completion unless explicitly intended.

Cleanup:

```bash
grep -R "\[DEBUG-a4f2\]" -n .
```

## Phase 4: Find root cause, then fix

A root cause statement has this form:

```text
Root cause: [specific mechanism] caused [observed failure] because [violated assumption].
Evidence: [loop/log/test proves it].
Fix: [minimal change].
Regression: [test/check that fails without fix and passes with it].
```

If three attempted fixes fail, stop. Question the architecture, the loop, or the premise. Don't try a fourth tweak.

A stopped debugging attempt must produce a `BLOCKED` report containing: loop command, last three hypotheses tested, observed evidence, and the recommended next diagnostic step.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "I see the bug; I'll patch it." | Seeing a symptom is not root cause. Build the loop. |
| "This log will be useful later." | Untagged logs become garbage. Tag and remove. |
| "One more fix might work." | Three failed fixes means stop and re-evaluate architecture/loop. |
| "The repro is flaky, so no test." | Improve reproduction rate; nondeterminism is measurable. |

## Verification checklist

- [ ] Loop exists and was run.
- [ ] Hypotheses ranked before code changes.
- [ ] One variable changed at a time.
- [ ] Debug logs uniquely tagged and removed.
- [ ] Recorded grep cleanup command was run before claiming completion, and its result is included in verification evidence.
- [ ] Root cause written with evidence.
- [ ] Regression proof added or seam problem escalated.
