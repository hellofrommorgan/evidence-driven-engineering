---
name: subagent-orchestration
description: "Use when delegating implementation, investigation, review, or parallel work; specifies fresh-context workers, independence checks, status protocol, and reference-not-duplicate handoffs."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [subagents, delegation, parallel, handoff]
    related_skills: [design-planning, two-stage-code-review, verification-honesty, failure-vocabulary]
---

# Subagent Orchestration

## Overview
Use subagents to preserve controller context and get independent judgment. Delegation is not dumping. Each worker needs a crisp goal, full context, constraints, and expected output.

## When to delegate

Delegate when:

- Tasks are independent or context-heavy.
- A fresh reviewer is valuable.
- Multiple unrelated failures can be investigated in parallel.
- You need to protect the controller from implementation detail bloat.

Don't parallelize implementers on the same task or same files. That creates merge chaos and contradictory reasoning.

## Fresh-context rule

- Each delegated task gets a fresh worker context.
- Don't reuse a worker that has already formed conclusions about another task unless continuity is the explicit goal.
- Review workers must be independent from implementation workers.
- If a worker receives prior conclusions, label them as claims to verify, not facts.

## Worker prompt template

```text
Goal: [single task]
Context:
- User intent: [summary]
- Relevant artifacts: [paths/SHAs/issues/plans]
- Scope: [allowed files/commands]
- Non-goals: [forbidden work]
Process: [skills/process to follow]
Verification: [exact evidence required]
Output format: DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT with evidence.
```

## Status protocol

- `DONE`: include files changed and verification evidence.
- `DONE_WITH_CONCERNS`: include completed work, concern severity, and recommendation.
- `BLOCKED`: include exact blocker, attempts, and recommended next action.
- `NEEDS_CONTEXT`: ask the smallest question and include a recommended answer.

Bad work is worse than no work. Workers may stop instead of improvising.

## Parallelism gate

Parallel only when all are true:

- Failures/tasks are genuinely independent.
- Workers will not edit the same files.
- Each worker can verify without waiting for another.
- Outputs can be merged or compared by the controller.

## Controller reconciliation

Worker outputs are claims until independently inspected. The controller must:

- Reconcile worker output against the original goal, not worker confidence.
- Re-run or inspect the verification evidence when feasible.
- Enforce file ownership or worktree strategy before dispatch.
- Reject overlapping write paths unless explicitly serialized.
- Resolve incompatible worker findings with a new focused review, not a guess.

## Handoff docs

For long context transfer, write a handoff doc to OS temp dir, not the repo, unless the project explicitly wants it persisted.

Rules:
- Reference existing artifacts; do not duplicate plans, diffs, ADRs, issues, or logs.
- Include paths/URLs/SHAs, not pasted blobs.
- Redact secrets.
- List suggested next skills.

Template:

```markdown
# Handoff: [task]

Current state: [brief]
Repo root: [path]
Branch/SHA: [branch and commit]
Git status: [clean/dirty summary]
Artifacts:
- Plan: [path]
- Diff/branch/SHA: [reference]
- Verification: [commands/results]
Open decisions:
- [decision + recommendation]
Suggested skills: [list]
```

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "More agents means faster." | Only independent work parallelizes safely. |
| "The worker can read the whole repo." | Give curated context; do not force rediscovery. |
| "I'll paste everything into the handoff." | Reference, don't duplicate. |
| "Self-review is enough." | Fresh context review catches different failures. |

## Verification checklist

- [ ] Independence gate passed before parallel dispatch.
- [ ] Each worker has scope, non-goals, and verification.
- [ ] Status protocol required.
- [ ] Implementation and review used separate fresh contexts when review was needed.
- [ ] Controller reconciled worker output against the original goal, not just worker confidence.
- [ ] Handoff references artifacts and redacts secrets.
