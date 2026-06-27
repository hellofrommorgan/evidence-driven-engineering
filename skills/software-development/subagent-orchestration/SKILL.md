---
name: subagent-orchestration
description: "Use when delegating implementation, investigation, review, or parallel work; specifies fresh-context workers, independence checks, status protocol, and reference-not-duplicate handoffs."
version: 1.1.0
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

## Delegation config is separate from the main model

Subagents spawn on the `delegation.*` config block, NOT `model.*`. A working main
model does not guarantee working subagents. If an entire batch fails identically and
instantly (sub-second, `api_calls: 1`, zero tokens, empty `tool_trace`, often a 400
`unsupported_api_for_model`), the cause is delegation config/routing, not the task
prompts — do not rewrite prompts, fix the config. See
`references/delegation-model-routing-trap.md` for the Copilot GPT-5 `/chat/completions`
trap, the `hermes config set delegation.model/api_mode` fix, and the note that
`config.yaml` is write-protected from `patch`/`write_file` (use `hermes config set`).
Before a large parallel batch, confirm `delegation.model` is one you've seen succeed.

## MoA model as a delegate (not a subagent)

A separate delegation vehicle: run `hermes chat -q --provider moa --model <preset>`
to get a Mixture-of-Agents model (aggregator + reference) to produce a single
deliverable — useful for *model diversity on one artifact* or dogfooding the MoA
path. Key constraint: `hermes chat -q` is a **bounded one-shot turn** and MoA
makes two model passes, so **pure-generation shapes work** (inline the real
file/interfaces, ask for the full rewrite in one code block) but **multi-step
in-place tool edits get cut short** (you find an empty `git diff`). Background it
(runs >60s), extract the code block, apply it yourself, and verify with the real
compiler/tests — the MoA output is a claim until the gates pass. Full recipe,
the turn-loop limit, and the worked example: `references/moa-model-as-delegate.md`.

## Parallelism gate

Parallel only when all are true:

- Failures/tasks are genuinely independent.
- Workers will not edit the same files.
- Each worker can verify without waiting for another.
- Outputs can be merged or compared by the controller.

For LAUNCHING a large independent build fan-out (5–50 workers each producing an
artifact), follow `references/large-parallel-fanout-launch.md`: smoke-test one
agent before firing all N (confirms routing + returns a real path/schema the
batch needs), lay a shared scaffold first (one umbrella dir, one module subdir
per agent, pre-written shared tokens/AGENTS.md, agents barred from git so the
controller commits once), require a per-worker verification bar + fixed greppable
output marker, reconcile on disk and re-fire only failed lanes, then build the
capstone index the agents couldn't.

## Controller reconciliation

Worker outputs are claims until independently inspected. The controller must:

- Reconcile worker output against the original goal, not worker confidence.
- Re-run or inspect the verification evidence when feasible.
- Enforce file ownership or worktree strategy before dispatch.
- Reject overlapping write paths unless explicitly serialized.
- Resolve incompatible worker findings with a new focused review, not a guess.
- Treat `DONE_WITH_CONCERNS` as actionable: either verify and fix the concern before finalizing, or state the residual risk explicitly. Reviewers often catch ledger/idempotency bugs even when tests pass.
- For broad local autonomy / Athena-style work, use the receipt-batch pattern in `references/parallel-local-receipt-batches.md`: per-lane artifacts, per-lane receipt validation, controller verification, and one controller receipt.
- When a batch already ran in earlier sessions and you need to reconcile or synthesize their final outputs, recover them with SQL against `state.db` instead of re-running the fan-out. See `references/recovering-prior-subagent-outputs.md` (find agents by shared prompt prefix, map themes by grep, pull syntheses by output marker like `FINDINGS:`). This is also why worker prompts should end on a fixed, greppable marker.

## tldraw presentation-readiness worker slate

When orchestrating subagents for tldraw/2D agent-coworking presentation readiness, start with read-only workers for runtime state, browser acceptance, demo story, presenter UX, repo hygiene, build/perf, and presenter ops. See `references/tldraw-presentation-readiness-subagents.md`. Serialize implementation afterward in the order reset/seed → browser smoke → presenter mode → runbook/preflight.

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
