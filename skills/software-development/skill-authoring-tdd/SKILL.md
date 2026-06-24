---
name: skill-authoring-tdd
description: "Use when creating or editing agent skills, process docs, prompts, or behavioral rules; requires trigger-only descriptions, pressure tests, rationalization mining, and minimal progressive disclosure."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [skills, authoring, tdd, evaluation]
    related_skills: [using-evidence-driven-engineering, verification-honesty, failure-vocabulary]
---

# Skill Authoring TDD

## Overview
Skills are executable behavior, not essays. Write them with the same discipline as code: failing behavioral test first, minimal fix, refactor for clarity.

## Description rule

The description is what the agent sees when deciding whether to load the skill. It must state triggering conditions, not summarize the workflow.

Good:

```yaml
description: "Use when debugging bugs, flaky tests, failed builds, or surprising behavior; builds a feedback loop before any fix."
```

Bad:

```yaml
description: "A four-phase debugging process with root cause, patterns, hypotheses, and implementation."
```

Workflow summaries tempt agents to skip the body.

## RED: pressure test without the skill

Before writing the skill, create a RED pressure-test artifact with 3-5 adversarial scenarios. If an agent runner is available, run the scenarios and capture output. If no runner is available, write predicted failure transcripts and label them `simulated`. The skill is not complete until each scenario has an expected post-skill response that blocks the rationalization.

```markdown
Scenario: user says "quick fix, no tests needed"
Observed rationalization: "Since this is small, I'll patch directly."
Skill must block with: TDD/verification gate.
```

## GREEN: minimal skill

Write the smallest skill that changes behavior:

- Trigger conditions.
- Iron law or hard gate.
- Step-by-step runnable process.
- Anti-rationalization table mapping observed excuses to corrections.
- Verification checklist.
- One excellent example if useful.

## REFACTOR: close loopholes

After testing the skill, patch it to close new rationalizations. Prefer specific prohibitions over motivational prose.

## Skill structure

```markdown
---
name: skill-name
description: "Use when [specific triggers]; [behavioral promise]."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [...]
    related_skills: [...]
---

# Title

## Overview
## When to Use / Hard Gates
## Procedure
## Anti-rationalization table
## Verification checklist
```

## Progressive disclosure

Keep SKILL.md focused. Move long examples, scripts, or domain references to `references/`, `scripts/`, or `templates/` only when they are genuinely reusable.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "This is just documentation." | Behavior-shaping docs need tests because agents rationalize. |
| "The description should explain the skill." | It should trigger loading; the body explains. |
| "More examples are better." | One sharp example beats five diluted examples. |
| "This rule is obvious." | Obvious rules are the ones agents skip; name the loophole. |

## Cross-profile skill updates

When Morgan asks to update a skill "across all profiles," treat that as explicit authorization to edit profile-local skill copies, not just the active profile. Preserve profile-specific additions while applying the shared rule. See `references/cross-profile-skill-updates.md` for the exact procedure and receipt shape.

## Verification checklist

- [ ] Description states trigger conditions.
- [ ] A RED pressure-test artifact exists with 3-5 scenarios.
- [ ] Each scenario maps to a specific rule in the skill.
- [ ] Post-skill expected behavior is stated for each scenario.
- [ ] Verbatim rationalizations addressed.
- [ ] Hard gates are agent-runnable.
- [ ] Skill is shorter than necessary but no shorter than effective.
- [ ] Cross-profile skill update requests enumerate and verify every target profile copy.
