# Evidence-Driven Engineering

A compact autonomous software-engineering skill library for evidence-first, intent-aligned coding agents.

Core idea: agents earn trust with evidence, small diffs, falsifiable goals, and honest stops — not confidence.

## Skill map

Start with `using-evidence-driven-engineering`.

| Phase / risk | Skill |
|---|---|
| Routing | `using-evidence-driven-engineering` |
| Intent, ambiguity, vocabulary, falsifiable goals | `intent-alignment` |
| Specs and vertical-slice plans | `design-planning` |
| Small scoped diffs | `surgical-changes` |
| RED/GREEN/REFACTOR | `test-driven-development` |
| Bugs and failed builds | `diagnostic-debugging` |
| Refactors and seams | `architecture-deepening` |
| Completion claims, anti-sycophancy | `verification-honesty` |
| Delegation and handoffs | `subagent-orchestration` |
| Review | `two-stage-code-review` |
| Git safety | `git-safety-and-guardrails` |
| Issue queues | `triage-queue-management` |
| Skill writing | `skill-authoring-tdd` |
| Uncertainty / capability stops | `failure-vocabulary` |


## Operational invariants

1. If a skill plausibly applies, load it before responding.
2. If intent is ambiguous, recommend a default or stop before editing.
3. Convert vague work into a failing test, reproducer, metric, or explicit verification loop.
4. Every changed line must trace to the user's request.
5. No speculative abstraction, config, seam, or impossible-case error handling.
6. Production code starts with a failing test when feasible.
7. Debugging starts with a feedback loop, not a hypothesis.
8. Completion claims require fresh evidence in the same turn.
9. Review spec compliance before code quality.
10. Destructive git needs hooks or explicit typed confirmation.

## Files

- Skills: `skills/software-development/*/SKILL.md`
- Git guard script: `skills/software-development/git-safety-and-guardrails/scripts/block-dangerous-git.sh`
- Manifest: `manifest.json`
