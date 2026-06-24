---
name: intent-alignment
description: "Use when requirements, vocabulary, priorities, or user intent are not fully pinned down; surfaces ambiguity, recommends defaults, and maintains glossary/ADR-quality shared language."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [intent, requirements, glossary, adr]
    related_skills: [failure-vocabulary, design-planning, architecture-deepening, communication-integrity]
---

# Intent Alignment

## Overview
Human intent is the source of truth. The agent's job is not to silently guess, and not to interrogate the human with blank questions. Surface ambiguity, recommend an answer, and let the human override.

## Hard gates

1. If two reasonable interpretations exist, name them before editing. If ambiguity affects files, behavior, data shape, or public contract, do not edit until it is resolved or the user has accepted your recommended default.
2. Every question must include the agent's recommended answer and why.
3. If a question can be answered by reading code/docs/issues, retrieve it instead of asking.
4. Use the codebase's vocabulary. Don't import model-default words like "component", "service", "API", "boundary", "ticket", or "backlog" if the project uses better terms.
5. Create documentation lazily: glossary entries and ADRs only when the decision has durable value.

## The recommendation pattern

Use this shape:

```text
Decision: [specific decision]
Options:
1. [option] — [tradeoff]
2. [option] — [tradeoff]
Recommendation: [option] because [technical reason].
Please confirm or override.
```

For small choices, compress it:

```text
I recommend [choice] because [reason]. I will proceed unless you prefer [alternative].
```

Don't ask:

```text
What should I do?
```

Ask:

```text
I found two plausible meanings. I recommend A because it matches the existing tests; B would change the public contract. Confirm A?
```

## Vocabulary discovery

Before introducing a term or writing durable vocabulary, search sources in this order and cite the source path when available:

1. Existing glossary/`CONTEXT.md`.
2. README and docs.
3. ADRs and design notes.
4. Tests, fixtures, and examples.
5. Public identifiers/types and issue language.

Output for non-trivial terminology decisions:

```text
Vocabulary used: [term]
Rejected synonyms: [terms]
Source: [path or evidence]
```

## Glossary discipline

Maintain or propose `CONTEXT.md` only as a glossary:

```markdown
# Context

## Domain language

- **Term:** Meaning in this codebase. Use this term instead of [rejected synonyms].
```

Rules:
- No implementation details in glossary entries.
- No architecture decisions in `CONTEXT.md`; use ADRs.
- Challenge terms that conflict with existing glossary.
- Reuse terms in plans, tests, issue titles, comments, and reviews.
- When introducing or rejecting a term, include rejected synonyms explicitly so future agents do not drift back to model-default vocabulary.
- Before adding glossary/ADR entries, search existing docs/ADRs/glossary and cite matches.

## ADR gate

Write or propose an ADR only when all three are true:

1. The decision is hard to reverse.
2. The decision would surprise a future maintainer without context.
3. The decision came from a real tradeoff, not taste.

If any test fails, put the note in the current plan/issue or skip documentation.

## Ambiguity stop

If ambiguity blocks safe progress:

```text
Something is unclear: [specific ambiguity].
I can interpret it as A or B.
I recommend A because [reason].
Please confirm or override before I change files.
```

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "Asking slows us down." | Wrong work is slower; recommend a default to minimize interruption. |
| "The code is obvious." | If the code answers the question, cite the file/path and proceed. If not, ask. |
| "Documentation is overhead." | Glossary/ADR docs are engineering artifacts only when they prevent future ambiguity. |
| "The user said 'service', so I can use it everywhere." | Match project vocabulary unless the user is intentionally introducing a term. |

## Output quality checklist

- [ ] Ambiguities named, not hidden.
- [ ] Questions include a recommendation.
- [ ] Code/docs were searched before asking retrievable questions.
- [ ] Existing project vocabulary preserved.
- [ ] Glossary/ADR updates are lazy and justified.
