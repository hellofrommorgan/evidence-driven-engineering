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

## Direct main push when explicitly requested

When Morgan explicitly asks to clean up a repo and push `main`, treat that as authorization for the non-force push, but still run the provenance and inclusion gates first.

If HTTPS git operations fail non-interactively even though `gh auth status` is valid, use `references/github-https-gh-askpass.md`: bridge Git to `gh auth token` through a temporary `GIT_ASKPASS` helper without printing the token, then keep the normal fetch/push verification gates.

Direct-main protocol:

1. Inspect repo/root/branch/remotes/worktrees/status and ahead/behind:
   - `git rev-parse --show-toplevel`
   - `git branch --show-current`
   - `git remote -v`
   - `git worktree list`
   - `git status --short --branch`
   - `git fetch origin && git rev-list --left-right --count origin/main...HEAD`
2. Classify dirty and untracked files before staging. Include intentional source/tests/docs/scripts; exclude runtime state, DBs, logs, generated local data, dependency folders, and env/credential files.
3. Prove representative exclusions with `git check-ignore -v` where runtime/local artifacts exist.
4. Scan staged source-like files for credential-shaped literals before committing.
5. Run relevant verification and `git diff --cached --check`; inspect `git diff --cached --stat` and `git status --short --branch`.
6. Commit with a conventional message on `main`.
7. Push with plain `git push origin main` only — never force-push unless separately and explicitly requested.
8. Verify remote alignment after push with `git fetch origin`, `git rev-list --left-right --count origin/main...HEAD` expecting `0 0`, and `git log -1 --oneline --decorate` showing `origin/main` at `HEAD`.

## Organizing large uncommitted research surfaces

When the user asks to organize and commit a large mixed research/prototype surface, treat it as provenance + inclusion control, not a blind `git add .`:

1. Inspect repo/root/branch/worktrees/status first:
   - `git rev-parse --show-toplevel`
   - `git branch --show-current`
   - `git rev-parse --git-common-dir`
   - `git worktree list`
   - `git status --short`
2. Inventory both tracked diffs and untracked files:
   - `git diff --stat`
   - `git diff --name-only`
   - `git ls-files --others --exclude-standard`
   - optionally `du -sh` on large new directories.
3. Classify before staging:
   - Commit source, tests, docs, lockfiles, plans, and intentional scripts.
   - Keep runtime receipts, local state, logs, build output, dependency folders, and env files out of the commit.
   - Add or verify ignore rules before staging generated/runtime artifacts.
4. Prove exclusions with `git check-ignore -v` for representative ignored files such as `.env.local`, runtime stores, watcher state/logs, `dist/`, and `node_modules/`.
5. Scan staged/untracked source-like files for likely secrets before commit. Treat placeholder/dev tokens and security vocabulary as review findings, not automatic blockers, but never commit real credentials.
6. Stage only after classification is complete. `git add -A` is acceptable when ignore rules and `git check-ignore -v` prove excluded artifacts are protected.
7. Before committing, run relevant verification plus `git diff --cached --check`, then inspect `git diff --cached --stat` and `git status --short`.
8. After commit, run `git status --short`, `git rev-parse --short HEAD`, and `git log -1 --oneline --stat --summary` before claiming the worktree is clean and naming the commit.

Do not use destructive cleanup (`git clean`, `reset --hard`, deleting directories) to make the surface look tidy unless the user explicitly requests it and the destructive confirmation protocol has been satisfied.

## Syncing to upstream / fork-divergence (stash, fast-forward, rescue)

For "sync our repo to the source repo and don't lose local changes" or
"what changes do we have relative to the source," see
`references/stash-fastforward-fork-divergence.md`. Key rules:

- **A stash-vs-HEAD diff lies once the branch has moved forward.** It mixes
  the stash's real edit with all intervening upstream drift, making the
  stash look like it *deletes* code that was actually *added upstream after*
  the stash. Always read a stash as `git diff stash@{0}^ stash@{0} -- <paths>`
  (against its OWN base), never against current `main`.
- **`hermes update` leaves orphaned autostashes** (`hermes-update-autostash-*`).
  Always `git stash list` after stash work; old entries can hold unique
  uncommitted work living on no branch. Inspect before dropping; never
  blind-drop. Don't drop a stash without explicit user sign-off — once the
  work is committed to a branch it's durable and the stash is a free backup.
- **Real fork divergence hides outside committed `main`** (often a clean
  ancestor of upstream). Enumerate branches' local-only commits, untracked
  files, orphaned stashes, AND worktrees — not just `git log main`.
- **Sync sequence:** record rollback SHA → confirm incoming HEAD doesn't
  track your untracked paths → `git stash push -u` → `git merge --ff-only
  upstream/main` (refuses if diverged) → `git stash pop` → re-check
  `git stash list`.
- **Rescue unique stash work across a moved-forward base** with
  `git diff stash@{0}^ stash@{0} -- <file> | git apply --3way` onto a new
  branch off current `main` — never `stash pop` across large drift. First
  grep the target function on `main` to confirm upstream hasn't already
  merged the same fix (else the stash is obsolete, don't re-commit a dup).

## Recovering an orphaned local commit (reset/pull dropped a cherry-pick)

For "is my cherry-pick / local commit still on HEAD?" when `git log` doesn't
show it — a `git reset --hard origin/main` (often buried inside a pull/sync/
`hermes update`) silently orphaned a local commit, and a running service may no
longer have the change. See `references/reflog-orphaned-commit-recovery.md`.
Key moves: `git merge-base --is-ancestor <sha> HEAD` to detect the orphan →
`git reflog` to find the `reset: moving to origin/main` that dropped it →
confirm zero upstream changes to the files with `git log <sha>^..HEAD -- <files>`
→ `git cherry-pick <sha>` to re-apply (new SHA, identical content/message/author
date) → run the change's test. This is the *recovery* companion to the
*prevention* rules in `stash-fastforward-fork-divergence.md`.

## Diverged fork / pushing into a repo a parallel session owns

When you go to `git push` and the remote has **diverged** (your branch and `origin/main` both moved past a shared ancestor — `git rev-list --left-right --count origin/main...HEAD` shows nonzero on BOTH sides), STOP. A plain push is correctly rejected; never resolve it by force-push.

- **Diagnose before deciding.** `git log --oneline HEAD..origin/main` (what upstream added) and `git log --oneline origin/main..HEAD` (what you added). Inspect the upstream commits in an isolated worktree (`git worktree add /tmp/x origin/main`) — another agent session may have independently built the SAME features, usually in a richer form.
- **"Rebase and cull" can cull to zero.** If upstream already supersedes all your local commits, the honest reconciliation is `git reset --hard origin/main` — but FIRST preserve your lineage on a backup branch+tag (local AND pushed: `git push origin loom/work-YYYYMMDD`) so nothing is lost and the reset is reversible.
- **Never unattended-merge a large divergence onto `main`,** and never force-push over a parallel session's commits. When unsure, push your work as a NEW branch (`git push origin <feature-branch>`) and open a PR — that's always safe and reversible; it touches no shared ref.

## Greening a RED gate on a repo another session is actively working

To fix a broken test/build gate on a repo you don't exclusively own (a parallel agent pushes to its `main`): do it on a branch off `origin/main` in an **isolated worktree**, never on local `main`.

1. `git worktree add -b fix/green-gate /tmp/gatefix origin/main` (local `main` is never touched).
2. **Reproduce the failure on the pristine checkout first** — prove it's RED before your change, and `git log -S '<symbol>'` to confirm the failing test + the code under test shipped in the SAME commit (RED-on-arrival, a real bug) vs. the test being newer WIP (someone's in-flight work — do NOT "fix" by guessing their intent; report it instead).
3. Make the **minimal** fix the tests fully determine; clean up now-unused locals so the diff is tight; secret-scan changed files.
4. Push the branch + open a PR (`gh pr create --base main --head fix/green-gate`). Verify `main` is byte-identical before/after (`git rev-parse main origin/main`), then `git worktree remove --force`.

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
