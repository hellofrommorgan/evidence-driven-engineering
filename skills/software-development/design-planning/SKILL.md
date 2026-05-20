---
name: design-planning
description: "Use before editing multi-step changes, features, migrations, config changes, or refactors; produces a brief design pass and 2-5 minute vertical-slice execution plan."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [planning, design, vertical-slice, execution]
    related_skills: [intent-alignment, falsifiable-goals, subagent-orchestration, test-driven-development]
---

# Design Planning

## Overview
Every project gets design, but not every project gets ceremony. The plan should be as small as the risk allows and exact enough for a context-free worker with poor taste to execute.

## Design pass

Before code, capture:

```markdown
# [Change] Plan

Goal: [one sentence]
Recommended approach: [one paragraph]
Alternatives considered: [1-3 bullets with tradeoffs]
Vocabulary: [project terms to use]
Scope: [allowed]
Non-goals: [forbidden adjacent work]
Feedback loop: [command/check]
```

For tiny changes, this can be a short message. Tiny does not mean implicit: the message must still name Goal, Scope, Non-goals, and Verification. For multi-step work, save it under `docs/plans/` or the project's established plan location.

## Vertical-slice rule

Plan end-to-end slices, never horizontal batches.

Bad:
1. Add all database changes.
2. Add all backend changes.
3. Add all UI changes.
4. Add all tests.

Good:
1. One test for one behavior through the public interface.
2. Minimal schema/backend/UI needed for that behavior.
3. Verify it.
4. Repeat for the next behavior.

A slice is valid when it is narrow but complete: it crosses every necessary layer and is demoable on its own.

## Task format

Each task must be 2-5 minutes of focused work when possible:

```markdown
### Task N: [specific behavior]

Objective: [one sentence]
Files:
- Create: `path`
- Modify: `path:lines if known`
- Test: `path`
Steps:
1. Write failing test: [exact test or test name]
2. Run: `[command]` → expected failure: `[message]`
3. Implement minimal code: [specific function/file]
4. Run: `[command]` → expected pass
5. Diff audit: every changed line traces to [goal]
6. Commit/checkpoint: `[command]` if appropriate
```

## Requirement coverage matrix

For multi-step work, include:

| Requirement | Task(s) | Test/loop | Non-goal risk | Verification evidence |
|---|---|---|---|---|
| [req] | [task ids] | [command/check] | [scope creep to avoid] | [expected proof] |

## Execution checkpoint

After each vertical slice, run its verification before starting the next slice. If a plan contains horizontal batching, stop and rewrite it.

## Plan self-review

Before execution, check:

- [ ] All user requirements appear in exactly one or more tasks.
- [ ] No task says "similar", "etc.", "TBD", or "handle edge cases" without specifics.
- [ ] Every code task has a verification command.
- [ ] Vertical slices, not horizontal layers.
- [ ] Non-goals block obvious scope creep.
- [ ] The plan names the exact skill sequence to use during implementation.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "This is too simple for design." | Use a smaller design pass, not zero design. |
| "I'll plan as I go." | That hides scope decisions inside code changes. |
| "All tests first is efficient." | Bulk tests verify imagined behavior. Use one test → one implementation. |
| "The implementer can infer paths." | Exact paths prevent context loss and noisy edits. |

## Handoff sentence

When plan is ready:

```text
Plan ready. Execute with `test-driven-development`, `surgical-changes`, `verification-honesty`, and `two-stage-code-review`; use `subagent-orchestration` for independent tasks.
```
