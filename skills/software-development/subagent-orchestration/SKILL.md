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

## Direct-profile worker completion marker

When launching a durable profile worker with `hermes chat --profile <name> -q ...`,
redirect its full output to a file and require a fixed terminal marker (`DONE`,
`BLOCKED`, etc.). A shell/background process that exits after printing only the
query, `Initializing agent`, or a few tool calls has **not returned a result** even
if the process wrapper reports completion. Inspect the captured log before acting.
If there is no marker and no verified side effect, retry the smallest unfinished
slice as a bounded foreground run; this preserves full tool output and prevents a
silent background exit from being mistaken for success. If side effects did land,
salvage and verify them rather than rerunning blindly.

This applies equally to **background reviewer/critic CLI runs** that redirect stdout to a
file (for example `copilot --model … > critique.txt`). A process can exit and leave a file
that contains only tool-read traces or a partial transcript, with NO actual verdict. For
review/critique lanes, require a fixed verdict marker such as `Verdict: SEND` /
`Verdict: REVISE`. If the file lacks that marker, treat the lane as incomplete even if the
process wrapper says `exited`; rerun the smallest critique slice in the foreground and use
that result, not the partial file.

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

## Timeout-without-summary: salvage, never trust, never re-run blind

A leaf delegate that hits its wall-clock cap returns **status=timeout with NO summary** — the worker died mid-task, so there is no self-report to act on. This is distinct from `BLOCKED` (a clean stop with a reason). The hard cap is `delegation.child_timeout_seconds` (commonly **1200s / 20 min** for leaf workers — NOT arbitrary multi-hour runtimes). A prompt that says "work continuously for 2 hours" in one leaf delegate WILL hit the cap and time out with work stranded mid-flight.

When a delegate times out:
1. **Do NOT trust any prior self-report** — on timeout there is none. Do NOT assume the task failed *or* succeeded.
2. **Salvage from disk directly**, then verify: `git status --short` (what files changed), run the test suite (did its edits stay green), `ls -newermt '<dispatch time>'` / search for artifacts (what measurement/output actually landed). Partial work is usually real and reusable — the worker may have finished early phases (code edits, tests) before dying on a later phase (long measurement, end-to-end runs).
3. **Re-dispatch only the UNFINISHED phases**, not the whole task. Pre-completed phases are on disk; re-running them wastes the next budget too.

**Prevention — match the work to the cap:**
- For long multi-phase work, either **raise the cap** (`hermes config set delegation.child_timeout_seconds <N>`; verify it persisted as a real int with `yaml.safe_load`) **before** dispatching, or **split into parallel independent leaf delegates** (each ≤ the cap, own output dir) rather than one serial long-runner.
- For genuinely durable multi-hour work that must outlive the turn, prefer a **cronjob or `terminal(background=True, notify_on_complete=True)`** over a single long leaf delegate — delegates are not durable and are wall-clock-capped.
- Scope each delegate so its slowest phase fits comfortably inside the cap with headroom; "it might take 60–120 min" against a 20-min cap is a guaranteed timeout.

Full salvage recipe, the disk-forensics commands, and the phase-split dispatch pattern: `references/delegate-timeout-salvage.md`.

## Background delegate that never returns in time: don't block, self-verify the load-bearing claim

`delegate_task` runs in the **background** — its result re-enters the conversation as a *later*
message, on the worker's own clock, with no guarantee it arrives before you reach the step that
needed it. This is distinct from a timeout (worker died) and from BLOCKED (clean stop): the lane
is simply still in flight, or its completion message lands after you've already had to act. The
trap is treating a dispatched verification lane as a dependency you must wait on.

Rule: **when you delegate verification of a claim you yourself can check at primary source, the
delegate is an optimization, not a gate.** Dispatch it, keep working, and if you reach the
load-bearing moment (e.g. send time) before it returns, verify the highest-stakes claims yourself
with a direct `web_extract`/`web_search`/`gh api`/`curl` and proceed. The deliverable must never
depend on an unreturned subagent self-report.
- Only the claims that are *both* load-bearing *and* not independently checkable justify actually
  waiting on a delegate. For everything else, the controller's own primary-source check is faster
  and more trustworthy than the subagent summary would have been anyway.
- Don't re-dispatch a still-running lane because it's "quiet" — that just doubles the work. Either
  verify it yourself or note it as unconfirmed-but-non-blocking in the run note.
- Worked example: a momentum-brief run dispatched two background source-verification lanes
  (paper venue, npm publication); neither re-entered before send. The controller verified the two
  highest-stakes claims directly (fetched the ACL Anthology page; hit the npm registry) and the
  two council critics independently re-verified the rest, so the unreturned lanes cost nothing.

## Standing-goal / session re-entry: prior background lanes are GONE — reconcile from disk

Background `delegate_task` workers are **not durable across a session boundary**. When a
standing-goal prompt re-enters (a fresh session continuing the same objective), `/new` is run,
or the parent process exits, every still-in-flight background delegate is **discarded** — it will
never re-enter the conversation, even though you dispatched it last turn. This is distinct from
"returns late" (same session, worker still alive) and from timeout (worker died mid-task): here
the lane simply no longer exists.

Rule on any standing-goal/continuation re-entry: **treat all previously-dispatched background
lanes as gone until disk proves otherwise.** Do not wait on them. Reconcile actual state from
primary sources before taking the next step:
- `git ls-remote origin '<expected-branch>'` and `gh pr list --state open` — did the lane push a
  branch / open a PR, or leave nothing?
- A discarded delegate often leaves a **created-but-empty branch** (it ran `git checkout -b` before
  being killed). `git log main..<branch> --oneline` empty + no target file on the branch = discarded
  with zero work. Delete the empty branch and rebuild.
- If the discarded lane was on the **critical path** (blocks everything downstream), **build that
  one module directly yourself** rather than re-dispatching — a single well-specified blocker is
  faster first-hand than another dispatch+verify round-trip, and it unblocks the next fan-out
  immediately. Re-dispatch is for the independent, non-blocking lanes.
- For work that MUST survive across sessions, don't use `delegate_task` at all — use a cronjob or
  `terminal(background=True, notify_on_complete=True)`, which outlive the turn.

## Wave-based dependency-DAG builds (issue→PR tracked)

For a multi-module build with a real dependency DAG (a package + modules, or a core lib + vertical
apps on top), don't fan out everything at once and don't serialize everything. Dispatch in **waves**,
where a wave = the set of modules whose dependencies are already **merged and green**:

1. **Wave 0 — foundations.** Dispatch the dependency-free modules (data loaders, value types) in
   parallel. Modules in *sibling* repos that don't yet depend on each other are also Wave 0.
2. **Merge gate between waves.** A downstream module cannot start until its deps are on `main`. So
   the controller acts as a **verifying reviewer**: for each returned PR, checkout the branch,
   re-run the real suite, confirm the code is real (not a stub) and the issue is linked, then
   squash-merge. Only then does the next wave's dependency set expand.
3. **Wave N — fan out the newly-unblocked independent middle layer in parallel**, then finish with
   the **sequential capstone** (compose/integration modules that depend on everything).

Discipline that makes this work unattended:
- **One issue → one branch (`feat/<slug>`) → one PR that `Closes #N`.** Open all issues up front,
  1:1 with the module DAG cards, in dependency order, so delegate prompts can reference stable issue
  numbers and the merged history is auditable.
- **Every delegate prompt carries the same spine:** read the vision/goal docs first; the exact
  files it may touch (module + its test + the `__init__` re-export, nothing else); the exact test
  command incl. the project's own interpreter/venv; and the full issue→branch→PR→`Closes #N` flow
  with real pytest output pasted in the PR body.
- **Fold council/architecture refinements into the issue as a comment BEFORE the module builds** —
  `gh issue comment <n>` — so the binding design change reaches the worker that implements it.
- **Verify from a clean clone using the project's OWN toolchain.** Re-running the suite from HEAD in
  a fresh clone is correct discipline, but it MUST use the project's interpreter/venv (e.g. the repo's
  `uv venv --python 3.12`), not an ad-hoc `python3 -m venv` — a wrong interpreter produces a *false*
  failure (e.g. `dataclass() got an unexpected keyword` on `slots=True` under an older Python) that
  looks like a real bug and wastes a debugging cycle. Match the harness to the project before trusting
  a red result.

Full worked sequence (3-repo legal-screened build: toolmaker core + two vertical apps, 25 issues,
foundation→parallel-middle→capstone waves, the session-boundary discard recovery, and the
clean-clone false-failure): `references/wave-based-dependency-dag-builds.md`.

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
- **A reviewer/critic's flag is ITSELF a claim — a single critic can raise a false positive that DELETES correct work if applied blindly.** Reviewers, including LM council critics that run their own tools (`gh api`/`curl`/web), sometimes read a truncated or summarized source and flag a TRUE, source-attributable statement as "unverified/invented." Do not treat critique items as automatic edits. Rule: converge-both-reviewers OR source-confirmed flags mutate the artifact; a lone flag that contradicts a source you can re-read does NOT — re-check it at primary source first (`gh api …/README.md | base64 -d | grep -i <phrase>`, refetch the page, re-read the file), keep the claim if confirmed, and record the false positive in the run note. Worked example: one critic asserted a repo README "says no such thing" about an emailed newsletter via a shared Teams channel, but re-grepping the actual README showed the exact phrasing present — the correct move was to KEEP the line, not cut it, while still applying that same critic's other valid catches.
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
