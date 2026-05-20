---
name: architecture-deepening
description: "Use for refactors, testability problems, pass-through modules, confusing interfaces, or seam decisions; applies deep-module language, deletion tests, and the two-adapters rule."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [architecture, interfaces, deep-modules, seams]
    related_skills: [intent-alignment, surgical-changes, test-driven-development]
---

# Architecture Deepening

## Overview
Architecture is a property of interfaces: how much complexity they hide, how local changes remain, and how cleanly behavior can be tested. Don't refactor for architecture vibes. Use concrete tests.

## Vocabulary

Use these words consistently:

- Module: a named unit that hides implementation decisions.
- Interface: the surface other code relies on.
- Seam: a place where behavior can vary or be tested independently.
- Adapter: a concrete implementation behind a seam.
- Depth: high leverage behind a small interface.
- Locality: ability to change one module without editing many callers.

Avoid vague defaults like "component", "service", "API", or "boundary" unless the project glossary uses them.

## Deepening tests

### Deletion test

If deleting a module makes the system simpler without losing behavior, it was a pass-through. Remove or deepen it.

### Two-adapters rule

One adapter = hypothetical seam. Two adapters = real seam.

Don't introduce dependency injection, interfaces, factories, or providers for one caller/adapter unless the task explicitly requires future extension and the user accepts the tradeoff.

### Interface-as-test-surface

A good interface is a good test surface. If tests must reach through internals, the interface may be shallow or wrong.

## Architecture report format

```markdown
# Architecture Deepening Report

Top recommendation: [specific change]

## Strong opportunities
- Module/interface: [name]
- Symptom: [pass-through, many callers, hard-to-test behavior]
- Evidence: [files/callers/tests]
- Proposed deeper interface: [sketch]
- Verification: [test/metric]

## Worth exploring
...

## Speculative / do not do yet
...

## Rejected recommendation
- Tempting abstraction: [name]
- Rejected because: [one-adapter/speculative/no current consumer]
- Revisit when: [second adapter/current need appears]
```

## Refactor gate

Don't refactor until:

- Existing behavior is captured by tests or a loop.
- The target interface has a current consumer need.
- The diff can remain surgical.
- You can explain what complexity the interface hides.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "Interfaces improve testability." | Only real seams improve testability; two adapters or real variation required. |
| "This module is small, so bad." | Small can be deep. Test leverage, not line count. |
| "This abstraction is standard." | Standard is not a requirement. Show the current pain. |
| "I need to refactor before fixing." | Capture behavior first; then refactor while green. |

## Verification checklist

- [ ] Project vocabulary used exactly.
- [ ] Deletion test considered.
- [ ] Two-adapters rule applied.
- [ ] Behavior captured before refactor.
- [ ] Speculative refactors marked as do-not-do-yet.
