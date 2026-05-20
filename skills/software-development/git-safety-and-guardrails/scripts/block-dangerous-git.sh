#!/usr/bin/env bash
set -euo pipefail

command_text="${1:-${COMMAND:-}}"

case "$command_text" in
  *"git reset --hard"*|*"git clean -f"*|*"git clean -fd"*|*"git clean -fdx"*|*"git branch -D"*|*"git checkout ."*|*"git restore ."*|*"git restore --source"*|*"git push"*)
    echo "Blocked dangerous git command: $command_text" >&2
    exit 1
    ;;
esac

exit 0
