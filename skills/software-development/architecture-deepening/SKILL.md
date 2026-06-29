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

## Source-pointer operational UIs

When a UI is a control surface over a private/source-of-truth workspace, treat the projection boundary as an architectural seam. The browser should send typed allowlisted intents to a server-owned middleware/agent layer; the UI should show receipt-backed outcomes, not optimistic completion. Operational facts must come from source files, runtime records, queue config, scheduler state, or verified receipts; missing facts stay absent instead of being invented. See `references/source-pointer-operational-ui.md`.

For filesystem-native agent apps, the source vault/filesystem is durable truth, HTML is a projection, browser actions are typed intents, and the backend should be framed as an authority kernel around Gate/Episode/receipts/reprojection rather than the domain brain. Use `references/filesystem-native-agent-apps.md` for vocabulary, proof path, and anti-overclaiming guidance.

## Refactor gate

Don't refactor until:

- Existing behavior is captured by tests or a loop.
- The target interface has a current consumer need.
- The diff can remain surgical.
- You can explain what complexity the interface hides.

## Product-truth UI modernization

When a user says a redesign/prototype directory is "the truth" or "the production UI," preserve that UI as the product surface. Modernization means deepening the behavior behind it, not replacing it with a different-looking minimal shell.

For browser-triggered local agent control planes, use `references/browser-triggered-local-agent-actions.md`: typed browser action -> authenticated server endpoint -> server-owned prompt/command -> local agent run -> run receipt. This lets buttons be real without allowing arbitrary browser-supplied shell or prompts.

For projection surfaces where the workspace remains the source of truth and changes independently from the browser, use `references/source-of-truth-reindex.md`: scheduled reindex job -> generator rereads source workspace -> source-pointer-safe UI/data -> health packet exposes cadence/mechanism. This prevents the control surface from hardening stale browser state into apparent truth.

When adapting browser-triggered local agent controls to a 2D canvas/whiteboard, preserve the authority separation but use a canvas-native loop: `Canvas Scene -> Viewport -> Spatial Intent -> Gate -> Agent Episode -> Patch Stream -> Checkpoint -> Replay`. The canvas patch stream is the conversation; do not degrade it into a chat sidebar with drawing side effects. See `references/canvas-agent-episodes.md`.

After simplifying or implementing a source-vault operational UI, run the seam audit in `references/source-vault-gate-audit.md`. In particular, verify the production server bootstrap exposes the current projection revision to the Gate, path containment uses real path APIs rather than string prefixes, receipt vocabulary matches the persisted file contract, nested payload schemas cannot smuggle authority, and debug/runtime status cannot masquerade as checked projection truth.

When evaluating LM-generated HTML as a live app/control-surface substrate, use `references/lm-native-live-html-apps.md`: source vault -> semantic projection -> typed intent packet -> server-owned action bridge -> bounded agent execution -> receipt/ledger -> verifier -> reindex. Preserve the novelty without overclaiming: old web mechanisms remain, but the stable contracts move to source identity, projection provenance, intent, authority, receipts, privacy, and verification.

For source-vault operational UIs where an agent writes receipts, use `references/checked-receipt-projection-loop.md`: split raw execution receipts from verifier-owned checked receipts; projection reads only checked receipts; a user-facing done claim requires checked receipt plus successful reprojection. If the UI needs a real-time feel, add a metadata-only lifecycle event stream and keep durable browser-visible state receipt/reprojection-backed.

When the user asks for elegant simplification of LM-native/source-vault projection architecture, use `references/simplified-lm-native-live-html-spine.md`: `Vault -> Projection -> Intent -> Gate -> Episode -> Checked Receipt -> Reprojection`. Prefer one noun per irreducible responsibility; demote runtime records to debug cache, ledgers to audit trace unless they have real hash-chain semantics, and browser state to pending overlay only.

When the user pushes away from rich app APIs/polling and toward agent-native operation, use `references/invoked-agent-projection-architecture.md`: source vault -> source-pointer-safe projection -> typed intent packet -> server-owned action bridge -> bounded agent execution -> receipt/ledger -> verifier/evaluator -> reindex. Treat browser endpoints as thin mailboxes/invocation membranes, not business-state APIs. The browser submits intent, not authority; receipts and verifier reports are app state; completion requires verifier-backed reindex visibility when the user-facing claim depends on projected state.

When an LM-native/source-vault projection surface starts accumulating HTTP routes, API semantics, or a monolithic server file, use `references/surface-invocation-kernel-agentic-architecture.md`: keep the HTTP edge thin, introduce a Surface Invocation Kernel, make Operation Contracts the anti-sprawl unit, and treat MCP/A2A/function-calling/SKILL.md as adapters or episode guidance rather than the domain authority. For implementation, use `references/surface-invocation-kernel-implementation-slices.md`: proceed through small TDD extraction slices (protocol paths, intent writer/idempotency, Operation Contracts, Gate, events, Episode runner, reprojector) with compatibility wrappers until the thin edge can shrink safely. For the first Operation Contract slice specifically, use `references/surface-invocation-kernel-operation-contracts.md`: add `contracts/operations/*.json` plus a tiny tested loader/registry while deliberately leaving existing Gate logic unchanged until equivalence tests can convert it. For concrete extraction lessons from a real Macrohard Surface pass, use `references/surface-invocation-kernel-extraction-lessons.md`: add Contract/Gate equivalence tests before making contracts authoritative, extract Gate semantics and protocol models without hiding raw unknown fields, extract metadata-only events separately, do Episode planner-only before runner/check/reproject coordinator work, and verify with full tests, E2E, update/build, production-ish fake-Hermes smoke, and Playwright dogfood.

When positioning or documenting this architecture for fast comprehension, use `references/filesystem-native-agent-apps.md`: name it a filesystem-native agent app; make the filesystem map the front door; avoid overclaims like "no backend"; frame the server as an authority kernel; scrub user-facing "middleware/substrate" language; and show the proof path from source file to typed intent to checked receipt to reprojection.

When adapting these ideas to a live 2D canvas, do not copy static reprojection architecture blindly.

When adapting these ideas to a live 2D canvas, do not copy static reprojection architecture blindly. Use `references/2d-canvas-agent-authority.md`: Canvas Scene -> Viewport -> Spatial Intent -> Gate -> Agent Episode -> Patch Stream -> Checkpoint -> Replay. The durable artifact is a replayable spatial patch stream, not only a generated page or final receipt.

After implementing a first live-coworking canvas slice, run the hardening review in `references/live-coworking-canvas-hardening.md`. In particular, verify runtime journal exposure, one canonical board snapshot source, real scene hashes that include custom shape props/text/meta, boundary validators that accept malformed `unknown`, patch validation before canvas mutation, on-canvas gaze/focus artifacts, and no hardcoded stream counts.

When the runtime already streams deterministic patches but local playability is blocked by optimistic UI state, timer cancellation, or weak replay evidence, use `references/tldraw-runtime-receipt-replay-hardening.md`: make `stop()` return terminal runtime progress, journal human intervention plus cancelled/partial checkpoint, collapse stable-shape update patches in replay, and preflight patch streams before scheduling mutations.

For source-vault operational UIs where an agent writes receipts, use `references/checked-receipt-projection-loop.md`: split raw execution receipts from verifier-owned checked receipts; projection reads only checked receipts; a user-facing done claim requires checked receipt plus successful reprojection. If the UI needs a real-time feel, add a metadata-only lifecycle event stream and keep durable browser-visible state receipt/reprojection-backed.

When evaluating or simplifying CLI-first multi-agent systems, do not replace command/vocabulary sprawl with a new metaphor. Prefer obvious literal terms (`Workspace`, `Project`, `Task`, `Agent`, `Run`, `Message`, `Queue`, `Review`, `State/Receipt`) and treat agent skills as the preferred UX over a small deterministic operation kernel, not as a substitute for authoritative state mutation. See `references/agentic-system-simplification.md`.

When the user wants maximal simplification under the assumption that frontier coding agents will soon handle most supervision themselves, demote the system from “agent OS” to “folder harness”: the agentic CLI of choice supervises, while `.agent/tasks`, `.agent/runs`, `.agent/receipts`, `.agent/messages`, and `.agent/state` provide durable breadcrumbs, receipts, and 10-15 minute steering packets. Use `references/frontier-agent-folder-harness.md`. When that harness needs to graduate into weeks/months of real project progress, use `references/all-gas-no-brakes-macrohard-target.md`: prove the file-only loop first, add anti-churn task scoring and steering packets, then choose a real target and create an external checkable operation map before editing the target repo.

When extracting one shared module out of N "duplicate" copies (dedup floor/engine/config), use `references/shared-module-extraction.md`: re-measure the byte-identical claim yourself (audits go stale — they're often a superset, not equals), beware `Path(__file__).resolve()` following a symlink to the wrong sibling data file, and exercise the bare entrypoint import with no test scaffold so pytest-green can't hide a broken default path.

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
