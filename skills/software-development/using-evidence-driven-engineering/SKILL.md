---
name: using-evidence-driven-engineering
description: "Use before software-engineering tasks involving code, tests, docs, repo state, debugging, planning, review, communication, or git; routes to the right EDE skill before responding."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [bootstrap, routing, discipline]
    related_skills: [intent-alignment, falsifiable-goals, verification-honesty, failure-vocabulary, communication-integrity]
---

# Using Evidence-Driven Engineering

## Overview
This is the bootstrap. It prevents the first and most common failure: answering from vibes when a specialized process should run.

Before answering or acting on any software-engineering request that may involve code, tests, docs, repo state, debugging, planning, review, communication, or git, perform routing first. If there is at least a 1% plausible match to any EDE skill, load that skill before responding. Don't answer from memory when a skill may apply. The cost of loading a skill is small; the cost of skipping the right process is corrupted work.

## Routing table

| Situation | Load |
|---|---|
| User asks for a change and intent has >1 plausible interpretation | `intent-alignment` |
| User gives an imperative like "fix", "add", "refactor", "make it work" | `falsifiable-goals` |
| Multi-step implementation, config change, migration, feature, or refactor | `design-planning` |
| Editing existing code | `surgical-changes`; if abstraction/seam/refactor is tempting, also load `architecture-deepening` |
| Any production-code change where tests are possible | `test-driven-development` |
| Bug, flaky test, failed build, incident, surprising behavior | `diagnostic-debugging` |
| Refactor, architecture complaint, testability complaint, pass-through modules | `architecture-deepening` |
| About to claim completion | `verification-honesty` |
| Receiving correction, agreeing/disagreeing, responding to praise/blame, or review communication | `communication-integrity` |
| Delegating work or preserving controller context | `subagent-orchestration` |
| Reviewing code or receiving review feedback | `two-stage-code-review` |
| Git branch/worktree/cleanup/destructive operation | `git-safety-and-guardrails` |
| Issue queue or bug/enhancement classification | `triage-queue-management` |
| Writing or modifying skills/process docs | `skill-authoring-tdd` |
| Probing what a frontier model can do, building agent scaffolding, or fanning out parallel agents | `frontier-probing` |
| Unclear, too hard, or decision needs human input | `failure-vocabulary` |

## Iron law

If a skill applies, you do not summarize it from memory. Use it.

## Skill stacks and precedence

Use the smallest stack that covers the work, in this order:

- Feature/change: `intent-alignment` if ambiguous → `falsifiable-goals` → `design-planning` → `test-driven-development` → `surgical-changes` → `verification-honesty` → `two-stage-code-review`.
- Bug/failed test: `diagnostic-debugging` → `test-driven-development` for regression → `surgical-changes` → `verification-honesty`.
- Refactor/architecture: `falsifiable-goals` → `architecture-deepening` → `test-driven-development`/behavior capture → `surgical-changes` → `verification-honesty`.
- Delegated work: `design-planning` → `subagent-orchestration` → `two-stage-code-review` → controller `verification-honesty`.
- Git operation: `git-safety-and-guardrails` before any mutating git command; `verification-honesty` before reporting branch readiness.
- Communication/review response: `communication-integrity`; for code review also `two-stage-code-review`.
- Frontier capability probe: `frontier-probing` → `falsifiable-goals` → `subagent-orchestration` if fanning out → `verification-honesty` before any completion claim.

For non-trivial work, final responses include either `Skills used: [...]` or `Skills not used: [reason]`.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "This is too small for a process." | Small tasks still need the smallest matching process: surgical diff, verification, and maybe one design paragraph. |
| "I know what the user means." | If two interpretations exist, name them or recommend one. |
| "Tests can come after." | Tests-after explain what code does; tests-first specify what code should do. |
| "I'll verify later." | Later does not exist. Verify in the message where you claim completion. |
| "The reviewer is probably right." | Review feedback is evidence to evaluate, not authority to obey blindly. |
| "A rule is enough for git safety." | Destructive git needs hooks/guards when available; a hook beats a rule. |

## Status protocol

When work is delegated or long-running, every worker/status update must be one of:

- `DONE`: requirements met, verification evidence included.
- `DONE_WITH_CONCERNS`: core task done, concerns listed with severity.
- `BLOCKED`: cannot proceed; includes exact blocker and recommended next action.
- `NEEDS_CONTEXT`: missing information; includes a recommended answer or retrieval plan.

## Verification checklist

- [ ] All plausibly relevant skills loaded before acting.
- [ ] The task has a concrete next skill or an explicit reason none applies.
- [ ] No response ends with only a promise to act later.
