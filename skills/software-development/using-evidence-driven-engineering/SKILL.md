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
| User explicitly says to use EDE/evidence-driven process at every step | Load this skill plus the concrete task skills; maintain a visible task list; collect evidence before and after edits; final must include verification commands/results and known concerns. |
| User asks to make an architecture/process real in code | `architecture-deepening` → `design-planning` → `test-driven-development` → `surgical-changes` → `verification-honesty`; delegate independent scouts if the scope is large. |
| About to claim completion | `verification-honesty` |
| Receiving correction, agreeing/disagreeing, responding to praise/blame, or review communication | `communication-integrity` |
| Delegating work or preserving controller context | `subagent-orchestration` |
| Reviewing code or receiving review feedback | `two-stage-code-review` |
| Git branch/worktree/cleanup/destructive operation | `git-safety-and-guardrails` |
| Issue queue or bug/enhancement classification | `triage-queue-management` |
| Writing or modifying skills/process docs | `skill-authoring-tdd` |
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

## Generated/static control surfaces

When working on a generated static UI that controls a source-of-truth repository or local automation system, use `references/generated-control-surface-closure.md` as a closure checklist. Treat named concerns as falsifiable work items, keep typed intent separate from durable receipt/projection truth, test source-pointer safety, and distinguish dispatch/scheduling from completion in both UI copy and final reports.

For Macrohard-style typed-intent → server-owned runner → checked receipt/projection systems, also use `references/macrohard-surface-simplification-hardening.md`. It captures hardening checks for production revision gates, receipt path containment, recursive authority-key denial, recent-run blocked status, terminal lifecycle fields, checked-receipt vocabulary, and raw-output UI exposure.

When a dispatched action succeeds but the originating card/control does not feel live, use `references/generated-surface-responsive-card-actions.md`: preserve action/unit identity in execution and checked receipts, then add a card-local ephemeral overlay from POST/SSE/run updates before durable reprojection.

When a Macrohard-style surface feels non-responsive after actions like Explain, or a run/toast succeeds without updating the originating card, use `references/macrohard-surface-realtime-receipt-overlays.md`. Preserve run identity into execution/checked receipts, then add a card-local ephemeral overlay fed by run subscriptions while keeping durable projection truth separate.

If the generated surface is technically correct but reads like operational metadata, also use `references/generated-control-surface-copy-cleanup.md`. Lead with operator decisions and demote cron/source/hash/receipt/stderr details into source or technical sections, then verify the generated assets and a live screenshot.

If a generated surface dispatches server-owned runs but feels stale or non-responsive — for example a toast says `explain_unit succeeded` while the originating card does not change — use `references/live-responsive-control-surface.md`. Preserve `unit_id`/`action` through runtime, execution receipt, checked receipt, and projection; add a card-local live overlay from events/status, and keep run IDs/receipt paths out of primary card copy.

## Verification checklist

- [ ] All plausibly relevant skills loaded before acting.
- [ ] The task has a concrete next skill or an explicit reason none applies.
- [ ] No response ends with only a promise to act later.
