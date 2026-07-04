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

## Testing UI-bound conceptual primitives

When a new UI primitive is driven by deterministic scoring/classification/transformation logic, keep the logic in a pure `.ts`/non-UI helper and test that helper directly. This is especially useful when importing the full UI node/component into Node-based tests would pull in framework state, JSX, or circular initialization. Pair the focused helper test with the normal build/typecheck so registration and framework integration still get exercised.

For live tldraw / 2D agent-coworking canvas work, use `references/tldraw-coworking-test-seams.md`: test protocol validation, spatial planning, canonical board snapshots, journal/replay, script typechecking, and a bounded watcher smoke before claiming the canvas loop is sound. For operational board co-owner demos with request detection, loopback Gate server, adapters, receipts, replay, and duplicate/flakiness reports, also use `references/tldraw-operational-coowner-test-seams.md`. For live generated-UI browser QA scripts with multiple flows, use `references/live-generated-ui-browser-qa-reporting.md` so the report preserves complete-run evidence before reset/stop/replay flows overwrite the final UI state.

When implementing visible agent attention and ghost/candidate/committed layer semantics on a tldraw canvas, also use `references/tldraw-visible-attention-layer-contracts.md`: write protocol/render-contract tests first, emit `presence_update` before content, keep presence as transient overlay state, derive patch totals, and browser-smoke cursor/gaze-before-artifact plus stop semantics.

## Generated control-surface hardening tests

When a generated control surface sends typed intent to a server-owned runner and later trusts receipts/projections, add regression tests at the seam where the bug can hide:

- Production-ish startup path: construct the server the same way `main()` does and prove stale `projection_rev_seen` is rejected from generated `site/data/surface.json`; do not rely only on a manually configured `current_surface_rev` test.
- Receipt containment: test sibling-prefix escapes (`../Macrohard-evil/...`) and absolute outside paths; path checks must use `relative_to()`/common-path semantics, not string prefixes.
- Recursive gate closure: test authority keys inside allowed nested containers such as `selected_side_effects[0].command`, not just unknown top-level fields.
- Recent-run honesty: test that deterministic check/projection failure makes the top-level recent record `blocked`/`failed` even if the runner exited successfully.
- Lifecycle honesty: after runner return or exception handling, assert terminal lifecycle fields such as `invocation_phase` are no longer `running`.
- UI raw-output safety: inject sentinel raw receipt/stderr strings and assert operator surfaces summarize checked outcome without rendering the raw strings.

## Full-loop UI middleware tests

When a browser action crosses a server-owned middleware/agent boundary, prefer an integration test that keeps the real browser, API client, HTTP server, auth checks, run-record persistence, and regeneration path, while replacing the external agent runner with a deterministic fake. See `references/full-loop-ui-middleware-testing.md` for a compact recipe and pitfalls. For generated control surfaces with Gate/Episode/Receipt/Reprojection semantics, also see `references/generated-control-surface-hardening.md` for receipt-lane splits, recursive Gate closure, live event metadata tests, stale-projection guards, and atomic deployment boundary checks.

## Source-of-truth UI projection tests

When a production UI is generated from an operational source of truth, add a contract test that proves absent facts stay absent instead of being filled with plausible synthetic defaults. Cover generated data plus UI null-tolerance: no fake effort/impact/follow-ons/history/cron timing, no `NaN` rendering warnings, and real provenance for every operational claim. See `references/source-of-truth-ui-projection-testing.md`.

For static/generated control surfaces with interactive browser controls, also test cross-page live state and visual honesty: mutate through a real control, navigate to the status/projection page, and assert it reflects the same local store; remove sub-day timelines if backend sub-day queueing is not durable; and test weave/graph readability via source cards, projected-unit cards, visible connective paths, and thread containers. See `references/generated-control-surface-ui-projection.md`.

When the user is judging quick-scan comprehension or asks whether a live surface "really changed," docs/generated packets are insufficient. Write or update a browser/E2E assertion against the actual visible page chrome/copy the user scans first, then regenerate/deploy and verify the served route includes the same visible strings. A framing pass should fail if the thesis only appears in README/docs/deck JSON but not in the live operator surface. See `references/filesystem-native-agent-surface-orientation.md` for a compact vault-state map, Episode prompt language, orientation packet shape, and test stack.

## Verification checklist

- [ ] Failing test observed before production code.
- [ ] Final response includes exact RED command/output and exact GREEN command/output for each behavior, or states why TDD was infeasible.
- [ ] Failure reason matches expected missing behavior.
- [ ] Minimal code made it pass.
- [ ] Refactor only while green.
- [ ] Regression tests proved by red/green/revert/red/restore/green when applicable.
