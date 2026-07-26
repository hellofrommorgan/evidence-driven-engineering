#!/usr/bin/env bash
# Guard against destructive git commands.
#
# Hook mode (Claude Code PreToolUse): receives the tool-call JSON on stdin,
# extracts .tool_input.command, and exits 2 to block; stderr is fed back to
# the agent as the block reason.
# CLI mode: pass the command as $1 or in COMMAND; any non-zero exit blocks.
set -euo pipefail

command_text="${1:-${COMMAND:-}}"

if [ -z "$command_text" ] && [ ! -t 0 ]; then
  stdin_payload="$(cat || true)"
  if [ -n "$stdin_payload" ]; then
    if command -v jq >/dev/null 2>&1; then
      command_text="$(printf '%s' "$stdin_payload" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
    else
      command_text="$(printf '%s' "$stdin_payload" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' 2>/dev/null || true)"
    fi
  fi
fi

case "$command_text" in
  *"git reset --hard"*|*"git clean -f"*|*"git clean -fd"*|*"git clean -fdx"*|*"git branch -D"*|*"git checkout ."*|*"git restore ."*|*"git restore --source"*|*"git push"*)
    echo "Blocked dangerous git command: $command_text" >&2
    exit 2
    ;;
esac

exit 0
