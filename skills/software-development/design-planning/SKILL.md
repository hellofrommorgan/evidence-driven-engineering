---
name: design-planning
description: "Use before editing multi-step changes, features, migrations, config changes, or refactors; produces a brief design pass and 2-5 minute vertical-slice execution plan."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [planning, design, vertical-slice, execution]
    related_skills: [intent-alignment, falsifiable-goals, subagent-orchestration, test-driven-development]
---

# Design Planning

## Overview
Every project gets design, but not every project gets ceremony. The plan should be as small as the risk allows and exact enough for a context-free worker with poor taste to execute.

## Design pass

Before code, capture:

```markdown
# [Change] Plan

Goal: [one sentence]
Recommended approach: [one paragraph]
Alternatives considered: [1-3 bullets with tradeoffs]
Vocabulary: [project terms to use]
Scope: [allowed]
Non-goals: [forbidden adjacent work]
Feedback loop: [command/check]
```

For tiny changes, this can be a short message. Tiny does not mean implicit: the message must still name Goal, Scope, Non-goals, and Verification. For multi-step work, save it under `docs/plans/` or the project's established plan location.

## Vertical-slice rule

Plan end-to-end slices, never horizontal batches.

Bad:
1. Add all database changes.
2. Add all backend changes.
3. Add all UI changes.
4. Add all tests.

Good:
1. One test for one behavior through the public interface.
2. Minimal schema/backend/UI needed for that behavior.
3. Verify it.
4. Repeat for the next behavior.

A slice is valid when it is narrow but complete: it crosses every necessary layer and is demoable on its own.

## Task format

Each task must be 2-5 minutes of focused work when possible:

```markdown
### Task N: [specific behavior]

Objective: [one sentence]
Files:
- Create: `path`
- Modify: `path:lines if known`
- Test: `path`
Steps:
1. Write failing test: [exact test or test name]
2. Run: `[command]` → expected failure: `[message]`
3. Implement minimal code: [specific function/file]
4. Run: `[command]` → expected pass
5. Diff audit: every changed line traces to [goal]
6. Commit/checkpoint: `[command]` if appropriate
```

## Requirement coverage matrix

For multi-step work, include:

| Requirement | Task(s) | Test/loop | Non-goal risk | Verification evidence |
|---|---|---|---|---|
| [req] | [task ids] | [command/check] | [scope creep to avoid] | [expected proof] |

## Conceptual research vertical slices

When a user asks to advance a research/prototype workspace from both a conceptual and technical standpoint, do not default to docs-only strategy or code-only feature work. First choose the cleanest runnable substrate, convert the thought material into project vocabulary and non-goals, then build one tactile vertical slice that makes the concept manipulable in the product surface. See `references/conceptual-research-vertical-slice.md` for the pattern and tldraw/workflow-template pitfalls.

When Morgan asks to create a Workshop project/repo but explicitly requires a minimum research period before scaffolding, treat the time requirement as a hard artifact contract: create a research-only workspace now, write analysis/synthesis/plan artifacts, and install a tracked gated runner that creates scaffold files only after the gate opens. See `references/time-gated-research-before-scaffolding.md`.

When the substrate is an agentic/personal operating loop, prefer a tiny local runner with ledgers and receipts before apps, dashboards, or external integrations. Encode each DAG stage as local files/JSONL, keep Telegram as a card/control-surface artifact before API wiring, and test idempotent per-date ledgers plus explicit no-external-action boundaries. For local approval choices, follow-up queues, and renderer output-path safety, see `references/local-only-agentic-loop-runner.md`. When the loop becomes operational but still emits self-referential/bootstrap tasks, seed it from living local profile/report/cron evidence instead of adding web ingest; see `references/future-radar-profile-signal-seeding.md`. When Morgan wants a continuous Hermes/Profile evolution system closer to its manifesto, use quiet local metabolism plus novelty-gated local signals and trial packets rather than heartbeat-only receipts or direct mutation; see `references/hermes-orchard-novelty-gated-metabolism.md`.

When Morgan wants a creative/CAD/rendering/generative-tool harness and clarifies that Hermes is the agentic CLI driver, do not build a separate cockpit as the primary operator. Use `references/hermes-driven-creative-tool-harnesses.md`: Hermes is the orchestrator, model providers are behind Hermes, tools such as Rhino/Blender/ComfyUI are adapters behind contracts, and the v0 should work in degraded/mock mode with receipts even when those tools are absent.

When a user asks to deeply research and iterate a deck or narrative about filesystem-native agent apps, agentic control surfaces, source-vault projections, typed intents, receipts, or bounded agent episodes using Karpathy-style `autoresearch`, extract the class-level workflow pattern rather than merely summarizing the repo: markdown org code -> constrained mutable surface -> fixed-budget episode -> declared success metric -> keep/discard/crash ledger -> evidence-based branch/state advance. Use it to sharpen the deck around a verified loop over durable files, not "no backend" or generic AI-app claims. See `references/autoresearch-filesystem-native-agent-apps.md`.

If the audience or user feedback shifts the same deck toward a broad Microsoft/executive audience, do not keep the research anchor or internal architecture vocabulary on-slide. Reframe around the external article/idea and the second-/third-order business effect: AI outputs become usable HTML pages; if pages can be generated safely, many internal tools become smart folders/living workspaces instead of full three-tier apps. Use lay language and consult `claude-design`'s `references/executive-html-ai-artifact-decks.md` for the deck pattern and QA checklist.

When the next ask is to interact with that research live, extend the slice into a deterministic canvas control surface before reaching for model/API integration. Add a small live dock/panel, a programmatic seed map, stable ids/focus behavior, and a browser smoke loop. See `references/live-conceptual-research-canvas.md`.

For live realtime generative UI scaffolds where Morgan distinguishes reasoning models from fast rendering models, use `references/live-generative-ui-model-renderer-split.md`: GPT-5.5 owns reasoning/build/semantic critique, GPT-5.4-mini is only a fast UI rendering/component-delta layer, and the renderer should patch a keyed component graph with a dirty-set scheduler rather than rerendering the whole page/canvas on every event.

When the user says they added a new tldraw card, treat the card as an actionable request surface: inspect live editor shapes, infer/action the card, write a concise answer artifact back onto the canvas, and verify bounds/overlaps. See `references/tldraw-live-card-requests.md`.

When Morgan asks to develop a meta-Hermes concept around evolving profiles, crons, workflows, `/goal` loops, personal operating systems, or AI taking on more responsibility, create a repo-centered greenhouse rather than mutating live Hermes state. Use council seats, read-only profile/census snapshots, profile-specific scorecards, and v0 non-mutation guarantees; see `references/hermes-profile-evolution-concept-repos.md`.

When Morgan asks to analyze a proactive agent product, self-driving IDE, autonomous engineering workspace, or to map an external agent product onto Hermes, extract the reusable operating loop rather than cloning UI/marketing: opportunity discovery → bounded run → evidence dossier → review gate → closure → skill/memory distillation. Map claims to Hermes primitives first (Cron, Kanban, skills, memory, Desktop, gateway, computer_use), then propose one vertical Run Control slice. See `references/autonomous-run-control-product-pattern.md`.

When Morgan needs to compress a broad agent/workflow/control-surface idea into a short internal video or talk, especially a five-minute prerecorded showback, create a durable workspace first and make the message copyable rather than comprehensive. Use `references/five-minute-internal-agent-pattern-video.md`: start from shared pain, then show the shift from text answers to working artifacts, real proof, the chief-of-staff/operator-surface reveal, and a tiny reproduction recipe. For filesystem-native automation, do not over-center the folder: the folder is backstage machinery; the audience-facing payoff is the generated chief-of-staff surface and human decision.

When Morgan pushes that Hermes Orchard is only "closer" and must perfectly align with the manifesto/vision, keep hillclimbing the next missing rung rather than stopping at heartbeat/trial artifacts: quiet observer → detector → signal → novelty gate → trial → harvest → promotion approval packet → evaluator/replay → human-approved application → survival scoring. See `references/hermes-orchard-vision-aligned-hillclimb.md`.

When Morgan is "tempted by up-and-out" — wants the Orchard (or any self-modifying loop) to take on more autonomy — design the honest steelman, not a gate-drop: make autonomy a per-cell decision `f(mutation_class × blast_radius)` earned with survival evidence, and weld a tamper-evident constitutional floor (scorer/gate/rollback/trust-ledger/constitution/credentials = `never`) into a SEPARATE module the loop can read but never rewrite. Raise the gate one earned cell at a time; never flip the global live-mutation switch as part of the design. See `references/earned-autonomy-frontier-constitutional-floor.md`.

When the user wants the tldraw board to feel close to realtime without a 24/7 hot agent, build a gated local watcher before autonomous answering: canvas-reachable check, CDP board snapshot, stable hash, adaptive cadence, bounded smoke tests. See `references/tldraw-live-board-watcher.md`.

When the tldraw ask escalates from watcher/demo/status audit to truly operationalizing `@agent` requests or making the board an agent co-owner, plan the full loop: request detection, loopback Gate server, durable runtime store, deterministic + Hermes adapters, validated patch stream, on-canvas status/receipts, replay, cancellation, and fake-to-real e2e verification. See `references/tldraw-operational-board-coowner.md` and `references/tldraw-operational-board-coowner-session-notes.md`.

For canvas-native surfaces, text/API smoke is insufficient. Track object bounds, run overlap/layout QA, place generated/streamed objects in open regions, and include visual QA evidence before claiming usability. See `references/canvas-spatial-qa.md`.

When the user corrects that the need is more generalized than a single research model, step up one abstraction level: define the human+agent 2D coworking architecture, adapt—not copy—Macrohard-style Intent/Gate/Episode/Receipt ideas, and build a small continuous streaming canvas episode. Use `references/2d-agent-coworking-canvas.md`.

When a live 2D/tldraw coworking project has a deterministic episode skeleton and needs a roadmap toward “someone is live editing beside me,” define and build through Level 1 animated output → Level 2 visible attention → Level 3 interruptible collaboration. Use `references/live-2d-coworking-levels.md` for falsifiable requirements, completion definitions, and the recommended order: visible attention before real model adapter; adopt/reject/branch before Hermes integration.

When the next step is local demo playability/polish rather than new capability, use `references/tldraw-local-playability-hardening.md`: make the deterministic loop repeatable and trustworthy first with clear/reset controls, terminal stop receipts, visible journal/checkpoint inspection, patch-stream validation preflight, source/provenance copy, and a README/dock play loop. Do this before model adapters or autonomous answering.

When a tldraw co-owner demo already has the Gate/Patch/Checkpoint/Replay loop and needs final stage-readiness, use `references/tldraw-demo-reset-seed-browser-smoke.md`: implement scoped reset receipts, demo seed namespace metadata, packaged browser smoke, presenter copy/proof inspector, and strict-port preflight before UI polish.

When the user asks to make a tldraw/2D agent-coworking project production-presentation ready, or reports duplicated requests/flakiness/offline fetch errors in an operational board co-owner, use `references/tldraw-production-presentation-readiness.md`: make the workspace map, demo README, `AGENTS.md`, task tracker, per-run DAG, primitive API, trigger/replay idempotency, CORS, failure terminalization, deterministic demo command, and browser/CDP smoke explicit before claiming demo readiness. For the concrete council-to-execution lessons from the 2026-05-24 tldraw session, see `references/tldraw-production-presentation-readiness-session-2026-05-24.md`.

When the user wants to access and edit a tldraw/canvas agent surface from another device over Tailscale, do not stop at a static preview. Treat touch/phone editability as the requirement: expose `/draw` plus same-origin `/draw-agent`, preserve existing Serve routes, verify actual visible controls and pointer-drag behavior, and if the full tldraw runtime blanks remotely, build a purpose-specific remote editable board surface that still serializes to the project’s `BoardSnapshot` for agent submission. See `references/tldraw-remote-editable-tailnet-surface.md`. For full-featured remote tldraw specifically, prefer fixing the real Vite/tldraw route and use `dev-workstation-automation`'s `references/tldraw-full-remote-tailnet-editing.md`; do not treat a stripped-down fallback as completion.

When the user asks for an LM council/subagent plan for getting a tldraw/2D agent-coworking demo to MSFT/Scott-Hanselman-level presentation readiness, use `references/tldraw-presentation-council-pattern.md`: run issue-specific compact councils, synthesize into one no-shortcuts execution order, surface demo-contract decisions as blockers, and persist a tracked plan before implementing polish.

## Design-source fidelity

When a user identifies a design directory, mockup, prototype, screenshot, or named redesign as "the truth", make that source a first-class requirement before choosing frameworks or implementation substrates. Do not replace the design truth with a lower-fidelity conventional implementation just because it is easier to test, build, or make LLM-friendly. See `references/design-source-fidelity.md` for the failure pattern and concrete review assertions.

When Morgan provides a screenshot/concept diagram and asks for a new Workshop project with extensive research before scaffolding, use `references/screenshot-to-research-gated-scaffold.md`: preserve and deeply analyze the screenshot, research the implied stack, write project docs first, mechanically enforce the research-time gate before `README.md`/`pyproject.toml`/`src`/`tests`, test the gate boundary (`now >= gate_epoch`), and scaffold only a minimal Hermes-drivable harness with contracts/receipts after the gate opens.

When Morgan supplies a screenshot/mockup/system diagram, asks for a new `~/Workshop` project, and imposes a minimum research duration before repo scaffolding, use `references/screenshot-to-gated-workshop-scaffold.md`: create a research-only workspace first, copy/analyze the screenshot, fetch official tool/domain docs, write synthesis/plan docs, enforce the duration with a real gate runner, and only then scaffold narrow contract/receipt slices. If Morgan clarifies that Hermes is the agentic CLI driving the harness, make Hermes the top-level orchestrator and treat model names like Claude/Sonnet as provider options behind Hermes.

When the design truth is a deck or narrative artifact for a generated control surface, extract the product metaphor and first-glance semantics as requirements, not just styling. For smart-folder / filesystem-native surfaces, prefer sparse generated work pages over dense ops dashboards; keep diagnostics in an inspector. See `references/smart-folder-surface-product-fidelity.md`.

Required planning checks:

- Name the authoritative design source path/artifact in Goal or Scope.
- Add an explicit non-goal: "do not substitute a different UI shell/framework unless parity with the design source is proven."
- Include a visual/design parity task that compares the generated/deployed surface against the authoritative design source, not merely against a newly-created baseline.
- If proposing a framework migration, separate distribution/runtime improvements from visual replacement; preserve the design source as the production UI until the new implementation proves pixel/interaction parity.
- E2E tests must assert design-specific affordances and copy from the source design, not generic app smoke checks.

## Execution checkpoint

After each vertical slice, run its verification before starting the next slice. If a plan contains horizontal batching, stop and rewrite it.

## Plan self-review

Before execution, check:

- [ ] All user requirements appear in exactly one or more tasks.
- [ ] No task says "similar", "etc.", "TBD", or "handle edge cases" without specifics.
- [ ] Every code task has a verification command.
- [ ] Vertical slices, not horizontal layers.
- [ ] Non-goals block obvious scope creep.
- [ ] The plan names the exact skill sequence to use during implementation.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "This is too simple for design." | Use a smaller design pass, not zero design. |
| "I'll plan as I go." | That hides scope decisions inside code changes. |
| "All tests first is efficient." | Bulk tests verify imagined behavior. Use one test → one implementation. |
| "The implementer can infer paths." | Exact paths prevent context loss and noisy edits. |

## Handoff sentence

When plan is ready:

```text
Plan ready. Execute with `test-driven-development`, `surgical-changes`, `verification-honesty`, and `two-stage-code-review`; use `subagent-orchestration` for independent tasks.
```
