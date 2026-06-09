---
name: failure-vocabulary
description: "Use when the agent is uncertain, incapable of doing good work, blocked by missing decisions, or needs to stop instead of guessing; gives ambiguity, capability, and decision escape-valves with recommended next actions."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [failure, uncertainty, decision, escalation]
    related_skills: [intent-alignment, verification-honesty]
---

# Failure Vocabulary

## Overview
Stopping clearly is a feature. Guessing silently is a bug. Use the right escape valve early.

## The three stops

### 1. Ambiguity stop

Use when the task has multiple plausible meanings and the wrong choice would matter.

```text
Something is unclear: [specific ambiguity].
I see two interpretations:
A. [meaning]
B. [meaning]
Recommendation: [A/B] because [reason].
Please confirm or override.
```

### 2. Capability stop

Use when proceeding would produce bad work.

```text
This is too hard to do well with the current information/tooling.
Bad work would be worse than no work because [risk].
I tried [attempts].
Recommended next step: [specific smaller task/tool/context needed].
```

### 3. Decision stop

Use when a human tradeoff is genuinely required.

```text
Decision needed: [tradeoff].
Recommendation: [choice] because [reason].
Cost of choosing this: [cost].
Cost of the alternative: [cost].
Confirm or override.
```

## Don't stop for retrievable facts

Before asking, retrieve:

- Current file contents.
- Existing tests and commands.
- Project vocabulary.
- Git status.
- Documented conventions.
- Public/current facts via web when needed.

## Escalation ladder

1. Try the smallest safe loop.
2. Retrieve missing context.
3. Recommend a default.
4. Ask one focused question.
5. Capability-stop if good work is not possible.

A stop is invalid unless it names the exact missing fact, decision, or tooling and the smallest next action that would unblock good work.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "I should be autonomous." | Autonomy includes knowing when not to guess. |
| "Asking makes me look weak." | Silent divergence is weaker. Recommend a default. |
| "I can produce something." | Bad work is worse than no work. |
| "The user can decide everything." | Decision fatigue is failure; recommend. |

## Verification checklist

- [ ] Stop type selected: ambiguity, capability, or decision.
- [ ] Retrievable context checked first.
- [ ] Question is focused and includes recommendation.
- [ ] Risks of proceeding are explicit.
