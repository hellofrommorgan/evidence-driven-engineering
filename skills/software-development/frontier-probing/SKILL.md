---
name: frontier-probing
description: "Use when exploring what a frontier model can do, building agent scaffolding, or fanning out parallel agents; spike raw agency before scaffolding, gate completion on a checked invariant, and instrument orchestration instead of trusting it."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [frontier, capability, spike, orchestration, verification]
    related_skills: [falsifiable-goals, verification-honesty, subagent-orchestration, diagnostic-debugging]
---

# Frontier Probing

## Overview
Exploring frontier capability fails the same way every time: generation and delegation outrun the verification loop, so the model's *claim* of progress stands in for *checked* progress. The fix is not to reach higher — it is to close the loop autonomously at three moments: **before** you scaffold, **at** the word "done," and **across** parallel runs. Hand the model maximal agency; trust nothing it says; believe only what a check proves.

## Iron law

```text
NEVER LET A MODEL'S CLAIM STAND IN FOR A CHECKED TRUTH —
NOT BEFORE BUILDING, NOT AT "DONE," NOT ACROSS RUNS.
```

Dispatch is not completion. A green status, a receipt, a "succeeded" toast, or an agent reporting `DONE` is a claim. The only completion is two sources of truth agreeing (intended vs. actual; source vs. screen; expected count vs. observed count).

## The three gates, in order

### Gate 1 — Spike the ceiling before you scaffold
Before writing *any* determinism (receipts, honesty machinery, worktrees, schemas), run the throwaway maximal-agency spike in a sandbox with none of that machinery:

1. Hand the model the whole problem in one prompt. Run it 3-5x.
2. Observe the raw ceiling. Where did unaided agency already succeed?
3. Ask the model directly: **"Where is my scaffolding capping you?"** It often diagnoses your architecture better than your debugging does.
4. Build only the determinism that the spike proved is actually missing. Port nothing you did not see fail.

Rationale: scaffolding built for a model weakness that turns out not to exist is the single largest waste in capability work. Capability discovery and production hardening are different activities — do not entangle them.

### Gate 2 — Write the invariant before you dispatch; gate "done" on it
Before any build/fix/dispatch, write one falsifiable sentence:

```text
I'll know it worked when ____ (a check comparing two sources of truth).
```

- No status, toast, receipt, or self-reported `DONE` counts. Only the comparison counts.
- The adversarial / seeker / disprove pass runs **as the entry condition for the word "complete," not as a cleanup round after it.** Invert the order: the check gates the claim.
- Specify the **stopping condition** ("until a seeker run finds zero new findings"), never the throttle ("maximize parallelism").

This is `verification-honesty` and `falsifiable-goals` applied at probe time. The single check "source and screen agree, show me the diff" closes most recurring loops.

### Gate 3 — Bound blast radius, then measure the swarm
Before fanning out parallel agents:

1. Ask: **"What is the smallest reversible unit, and what is the stopping condition?"** — not "maximize parallelism / max subagents."
2. Pin a frozen base ref for the batch and quiesce any cron/background writers, so worktree agents do not race a moving `main`.
3. Point at least one agent at **verification, gated before merge** (did the loop fire? did source actually change?) — not only at labor.
4. Treat integration (merge + rebase + verify) as the bottleneck, not agent count. Build it as a pipeline, not a manual diff-against-base queue.
5. Periodically run a **blinded experiment on your own topology**: does the swarm converge faster than serial-with-verification? Measure it; do not assume wider fan-out is more frontier. Past the integration ceiling, fan-out is negative-yield.

## Anti-rationalization table

Mined from real failure transcripts.

| Rationalization | Correction |
|---|---|
| "Extremely urgent, no corners cut, just fix all of them." | Intensity is not a spec. Write the invariant (Gate 2) first; urgency adjectives don't constrain output. |
| "I have unlimited free tokens, maximize parallelism." | Unbounded scope is how 701 cards happen. Specify the stopping condition, not the throttle. |
| "It's done — the receipt/toast is green." | Green is a claim. Show the diff between intended and actual. |
| "I'll verify once all the work is complete." | That inversion is the bug this skill exists to kill. The check gates "complete." |
| "Let me build the scaffolding first, then test the model." | Spike first (Gate 1). You may be hardening a weakness that doesn't exist. |
| "More agents will get there faster." | Integration is the bottleneck, not agent count. Measure convergence before widening. |
| "I caught the contamination by diffing by hand, so it's fine." | Manual catch means the loop isn't closed. Automate the eyeballs or cap fan-out. |

## Verification checklist

- [ ] A throwaway spike ran *before* any scaffolding, and the model was asked where it's being capped.
- [ ] A falsifiable "I'll know it worked when ___" sentence exists, comparing two sources of truth.
- [ ] The adversarial/verify pass gates the word "complete" — it did not run only as cleanup.
- [ ] A stopping condition is specified (not just a parallelism throttle).
- [ ] Before fan-out: smallest reversible unit named, base ref frozen, writers quiesced.
- [ ] At least one agent verifies before merge.
- [ ] No completion claim rests on a status/receipt rather than a checked diff.
