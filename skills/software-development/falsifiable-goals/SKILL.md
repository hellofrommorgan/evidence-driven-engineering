---
name: falsifiable-goals
description: "Use when a request is imperative, vague, or outcome-oriented; converts it into tests, feedback loops, and success criteria the agent can verify independently."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [goals, tests, feedback, success-criteria]
    related_skills: [intent-alignment, test-driven-development, verification-honesty]
---

# Falsifiable Goals

## Overview
Confidence is not a deliverable. A falsifiable goal is. Convert the user's words into a loop that can fail, then make it pass.

## Transform imperatives into checks

| User says | Agent goal |
|---|---|
| "Add validation" | Write failing tests for invalid inputs, then make them pass. |
| "Fix the bug" | Create a reproducer that fails, then make it pass. |
| "Refactor X" | Capture current behavior, change structure, verify behavior is unchanged. |
| "Make it faster" | Capture baseline metric, set target, improve, re-measure. |
| "Clean this up" | Define allowed cleanup scope and diff audit, then edit. |
| "Support Y" | One vertical slice that proves Y works through the public interface. |

## Success criteria template

For every non-trivial task, write this before editing:

```text
Goal: [observable outcome]
Loop: [command/manual check that fails before and passes after]
Scope: [files/features allowed to change]
Non-goals: [nearby tempting work explicitly excluded]
Verification: [fresh command/evidence required before completion claim]
```

## Feedback-loop hierarchy

Choose the fastest deterministic loop that proves the goal:

1. Single unit/behavior test.
2. Focused integration test.
3. CLI command or script with expected output.
4. Browser/API check with exact steps.
5. Repro script for flaky/nondeterministic behavior that improves reproduction rate.
6. Human-in-the-loop script only when automation is not possible.

If no loop can be built, that is a finding. Escalate to `architecture-deepening` or `failure-vocabulary`; do not guess.

## Goal quality test

A goal is ready when:

- A fresh agent can run it without session history.
- It has a pass/fail result or measurable threshold.
- It excludes adjacent work.
- It can be used as review input.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "I'll know it when I see it." | Then you do not have an agent-runnable goal yet. |
| "The test would be hard." | Build the loop first; if impossible, report the seam problem. |
| "This is just a refactor." | Refactors require before/after behavior evidence. |
| "The user didn't ask for tests." | The user asked for working software; tests are the proof when feasible. |

## Verification checklist

- [ ] Imperative rewritten into an observable outcome.
- [ ] Fastest viable loop selected.
- [ ] Scope and non-goals explicit.
- [ ] The loop can fail before the fix and pass after.
