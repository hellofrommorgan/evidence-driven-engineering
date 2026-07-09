---
name: surgical-changes
description: "Use whenever editing existing files; enforces line-by-line traceability to the request, codebase style matching, and anti-YAGNI prohibitions."
version: 1.0.0
author: Morgan Wilson
metadata:
  hermes:
    tags: [diff, surgical, yagni, style]
    related_skills: [falsifiable-goals, architecture-deepening, verification-honesty]
---

# Surgical Changes

## Overview
The diff is the product. Every changed line must trace directly to the user's request or to cleanup caused by your own change.

## Iron law

```text
EVERY CHANGED LINE MUST TRACE DIRECTLY TO THE USER'S REQUEST.
```

## Allowed changes

- Lines required to implement the requested behavior.
- Tests that specify the requested behavior.
- Imports/types/variables made necessary by those changes.
- Cleanup of unused code created by your changes.
- Minimal formatting required by the touched language/tool.

## Forbidden changes

- Adjacent refactors.
- Reformatting unrelated code.
- Renaming for taste.
- Adding type hints/docstrings/comments not required by the request.
- Generic "cleanup" while you are nearby.
- New abstractions for one caller.
- Configurability not requested.
- Error handling for impossible scenarios.
- Deleting pre-existing dead code unless asked.
- Replacing a user-approved UI/design with a simpler alternate implementation while claiming to preserve it.

If the request says a redesign/prototype is the source of truth, delete or quarantine older alternate UI paths and add a contract test that forbids them from becoming production again.

## Simplicity gate

Before finalizing a diff, ask:

1. Could this be 50 lines instead of 200?
2. Did I introduce a seam with only one adapter? If yes, remove it unless the task is explicitly architectural.
3. Did I add options/configuration without a current caller? Remove them.
4. Would a senior maintainer call this overcomplicated? Simplify.

## Diff audit procedure

Before final response, run or inspect the actual diff (`git diff`, `git diff --stat`, or the harness equivalent) and cite the changed files reviewed. Don't rely on memory of edits.

### A `"success": true` from the edit tool is NOT proof the file is valid

A fuzzy find-and-replace (`patch`/apply-patch/sed-like tools) can report success while
silently corrupting the file — most commonly when the `old_string`/`new_string` span
**multiple adjacent lines of an implicit string concatenation** (Python `"a" "b"`,
JS template chunks, C string literals). The matcher can inject a stray escaped quote
(`\"`) or drop a terminator at a line boundary, producing `SyntaxError: unterminated
string literal` (or the language's equivalent) on lines the diff *looked* clean on.
Real example this session: three `patch` calls to a Python builder each returned
`success`, but two injected `"…to Claude to \"` at the concatenation seam → the build
would not import.

Defenses (do at least the first two):
1. **Compile/parse after every batch of edits**, not just at the end:
   `python3 -c "import ast; ast.parse(open('f.py').read())"` (or `node --check`,
   `bash -n`, `tsc --noEmit`, the project linter). The auto-lint some tools emit on
   write is the same signal — read it; a lint error there means the edit is broken now.
2. **Grep for the corruption signature** the tool tends to leave, e.g.
   `grep -n '\\"),$' file.py` for stray escaped-quote line-ends after editing a file
   full of escaped quotes.
3. If a fuzzy patch keeps drifting on an escaped-quote-heavy region (error mentions
   "escape-drift" or "literal sequence `\\\"`"), **stop patching and rewrite the whole
   file with `write_file`** — many small patches into that region compound the damage.

Produce a trace table for every non-trivial diff; for tiny diffs include a one-sentence trace:

| Changed file/region | Reason tied to request |
|---|---|
| `path:lines` | Implements/tests [specific requirement]. |

If a row says "cleanup", "style", "while here", or "best practice", revert it unless the user asked.

Before adding a new abstraction, helper, seam, or config option, cite the current second caller/adapter or remove it.

## Matching style

The codebase wins over the model:

- Keep naming conventions.
- Keep quote/format style unless formatter changes it.
- Keep test style and assertion idioms.
- Prefer existing helpers over new helpers.
- If existing style is ugly but local, match it.

## Anti-rationalization table

| Rationalization | Correction |
|---|---|
| "This code was bad anyway." | Mention unrelated issues separately; do not edit them. |
| "The formatter touched it." | Use the project's formatter only on required scope if possible. |
| "This abstraction will help later." | Later is not a requirement; two adapters make a real seam. |
| "Better errors are always good." | Impossible cases do not need defensive code. Real cases need tests. |

## Verification checklist

- [ ] Diff reviewed line by line.
- [ ] Every changed line maps to a requirement or self-created cleanup.
- [ ] Existing style matched.
- [ ] Speculative abstractions/configuration removed.
- [ ] Unrelated observations reported outside the diff, not edited.
