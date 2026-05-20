---
name: git-safety-and-guardrails
description: "Use before git operations, worktree cleanup, branch finishing, push/merge/reset/restore/clean commands, or setting up harness safety; combines provenance checks with hook-level destructive-git blocking."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [git, safety, worktree, hooks]
    related_skills: [verification-honesty, failure-vocabulary]
---

# Git Safety and Guardrails

## Overview
A hook beats a rule. Agents can rationalize around text. Destructive git operations should be blocked by the harness or shell when possible, and manually guarded otherwise.

## Detect before acting

Before branch/worktree operations, inspect:

```bash
git status --short
git branch --show-current
git rev-parse --show-toplevel
git rev-parse --git-common-dir
git worktree list
```

Never modify or delete a worktree you did not create or cannot prove is safe to touch.

## Dangerous commands

Block or require explicit human confirmation for:

- `git push`
- `git push --force` / `--force-with-lease`
- `git reset --hard`
- `git clean -f`, `git clean -fd`, `git clean -fdx`
- `git branch -D`
- `git checkout .`
- `git restore .`
- `git restore --source ...`
- deleting worktree directories

## Runnable guardrail script

Use `scripts/block-dangerous-git.sh` as the runnable guardrail. Install it in the harness PreToolUse hook when supported. If the harness cannot run hooks, source/wrap it in the shell before issuing destructive git commands.

Check/install protocol:

1. Check whether the harness supports PreToolUse or command hooks.
2. If supported, register `scripts/block-dangerous-git.sh` and verify it blocks a harmless dry-run string such as `git reset --hard`.
3. If unsupported, state `Hook unavailable because: [reason]` and use the fallback confirmation protocol below.

## Fallback confirmation protocol

When hooks are unavailable and a destructive operation is explicitly requested:

1. Print the exact command.
2. Print `git status --short`.
3. Identify dirty/untracked work and whether it is agent-created or user-created.
4. Refuse the destructive operation if unknown user changes exist.
5. Require typed confirmation: `confirm destructive git: [command]`.

A warning is not enough. Either a hook blocks the command, or explicit typed confirmation gates it.

## Pre-merge protocol

Before `git merge` or equivalent branch integration:

1. Run `git status --short` and refuse to merge over unknown dirty/untracked user work.
2. Identify current branch and target branch.
3. Run the relevant verification checks before merge when feasible.
4. Show the merge command that will run.
5. If the merge is user-requested and status is safe, proceed; otherwise present the finishing branch menu.
6. After merge, inspect conflicts/status and rerun verification before claiming readiness.

## Finishing branch menu

Before presenting finish options:

1. Run verification checks.
2. Run `git status --short`.
3. Summarize branch and diff.

Then present:

1. Merge locally.
2. Open PR / prepare PR.
3. Keep branch/worktree for later.
4. Discard worktree/branch (requires typed confirmation and provenance proof).

Don't clean up unproven worktrees.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "I need reset --hard to clean up." | Ask; preserve user work by default. |
| "Push is harmless." | Push changes remote state; require explicit request. |
| "The worktree looks temporary." | Provenance, not vibes. |
| "A warning is enough." | Use a hook/guard where possible. |

## Verification checklist

- [ ] Repo root, branch, status, and worktrees inspected.
- [ ] User work not overwritten.
- [ ] Destructive commands blocked or explicitly confirmed.
- [ ] Cleanup only touches agent-created resources.
- [ ] Finish options presented after verification.
