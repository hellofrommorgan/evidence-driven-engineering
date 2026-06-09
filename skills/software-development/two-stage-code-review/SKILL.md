---
name: two-stage-code-review
description: "Use after implementation tasks, before merging, or when responding to review; reviews spec compliance before code quality, triages severity, and forbids performative agreement."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [review, spec, quality, anti-sycophancy]
    related_skills: [surgical-changes, verification-honesty]
---

# Two-Stage Code Review

## Overview
Review has two different questions. Don't conflate them:

1. Did we build the right thing? (spec compliance)
2. Did we build it well? (code quality)

Spec review must happen first. Beautiful wrong code is still wrong.

## Stage 1: Spec compliance

Inputs:
- Original user request/spec/plan.
- Allowed scope/non-goals.
- Diff or changed files.
- Base branch/SHA and reviewed diff range, when available.
- Verification evidence.

Check:

- [ ] Every requirement implemented.
- [ ] No requirement contradicted.
- [ ] File paths/interfaces match the plan.
- [ ] No extra features or speculative changes.
- [ ] Tests prove the intended behavior.

Reviewer must inspect the actual diff/changed files, not rely on implementer summary.

Output:

```text
Reviewed: [files or diff range]
Spec verdict: PASS / REQUEST_CHANGES
Gaps:
- [specific requirement missing or overbuilt]
```

## Stage 2: Code quality

Run only after spec PASS.

Check:

- Correctness and edge cases for real scenarios.
- Project style and vocabulary.
- Surgical diff discipline.
- Test quality: behavior through public interfaces.
- Security/performance only where relevant to this change.
- Debug instrumentation removed.

Severity:

- Critical: must fix; incorrect, unsafe, or breaks requirements.
- Important: should fix before merge; maintainability or robustness issue.
- Minor: optional nit; do not block.

Output:

```text
Reviewed: [files or diff range]
Quality verdict: APPROVED / REQUEST_CHANGES
Critical:
Important:
Minor:
```

## Receiving review

Technical evaluation, not emotional performance. Follow `verification-honesty` (Communication integrity): evaluate each finding as accepted/rejected/needs-clarification with evidence and an action; never substitute gratitude or approval for evaluation. Push back when the reviewer is wrong — blindly accepting bad feedback is dishonest.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "Quality review can include spec." | It will miss over/under-building. Spec first. |
| "The reviewer said it, so fix it." | Evaluate evidence; push back with code/tests when needed. |
| "Minor nits show diligence." | Nits can create noise; do not block on optional taste. |

## Verification checklist

- [ ] Reviewer had curated context, not session history only.
- [ ] Spec compliance completed before quality review.
- [ ] Severity labels used.
- [ ] Critical/Important issues resolved or explicitly rejected with evidence.
- [ ] Response contains technical evaluation, not sycophancy.
