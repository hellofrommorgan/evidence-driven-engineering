---
name: test-driven-development
description: "Use for production-code changes where behavior can be tested; requires failing test first, one-test-to-one-implementation vertical slices, and delete-if-code-first enforcement."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [tdd, testing, red-green-refactor]
    related_skills: [falsifiable-goals, surgical-changes, verification-honesty, architecture-deepening]
---

# Test-Driven Development

## Overview
TDD is not "write tests eventually." It's a discipline for discovering the correct interface and preventing imagined behavior.

## Iron law

```text
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
```

If you wrote production code first, delete it. Delete means delete: do not keep it in a scratch file, do not adapt it, do not use it as reference.

## Cycle

For each behavior:

1. RED: write one test through the public/behavioral interface.
2. Run the focused command and watch it fail for the expected reason.
3. GREEN: write the smallest production code to pass.
4. Run the focused command and watch it pass.
5. REFACTOR: improve structure only while tests are green.
6. Run the focused command again.
7. Move to the next behavior.

## Vertical slice rule

One test → one implementation → repeat. Never write all tests, then all implementation.

Bulk tests are usually tests for imagined behavior. Vertical tests stay attached to what the software actually does.

## Test quality checks

A good test:

- Names behavior, not implementation.
- Exercises public interface or a real seam.
- Would fail on the bug/absence of feature.
- Would survive an internal refactor.
- Avoids mocks unless the real dependency is slow, nondeterministic, expensive, or unsafe.
- Uses existing test idioms.

## Regression proof

For bug fixes, prove the test is meaningful:

1. Test fails before fix.
2. Fix makes it pass.
3. Revert or disable the fix.
4. Test fails again.
5. Restore the fix.
6. Test passes again.

## Exceptions

If tests seem impossible, first spend focused effort finding existing test commands, examples, and seams. Record searched test locations and why no seam exists. Don't classify work as untestable until `diagnostic-debugging` or `architecture-deepening` confirms the seam problem.

If no correct seam exists for a test, do not force bad dependency injection. Report the seam problem, load `architecture-deepening`, and use `verification-honesty` with alternate evidence. Final output must include: reason tests were infeasible, attempted seam, risk, and the next testability improvement.

Throwaway prototypes can skip TDD only if clearly marked throwaway and their answer is captured before deletion/absorption.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "Tests after prove the same thing." | Tests after describe code; tests first specify behavior. |
| "The change is obvious." | Obvious code still needs a failing signal when feasible. |
| "I already wrote the code; deleting wastes time." | Keeping it rewards the violation and biases the test. |
| "Mocking is easier." | Prefer public behavior; mock only unavoidable slow/unsafe/nondeterministic dependencies. |

## Verification checklist

- [ ] Failing test observed before production code.
- [ ] Final response includes exact RED command/output and exact GREEN command/output for each behavior, or states why TDD was infeasible.
- [ ] Failure reason matches expected missing behavior.
- [ ] Minimal code made it pass.
- [ ] Refactor only while green.
- [ ] Regression tests proved by red/green/revert/red/restore/green when applicable.
