#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skills/architect"
if [ "${1:-}" = "--project" ]; then
    DEST="$(pwd)/.claude/skills/architect"
else
    DEST="$HOME/.claude/skills/architect"
fi

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -r "$SRC" "$DEST"

echo "Installed /architect to $DEST"
if command -v codex >/dev/null 2>&1; then
    echo "Codex CLI found: $(codex --version) (need >= 0.133 for default Goal Mode)"
else
    echo "Codex CLI not found - install the builder with: npm i -g @openai/codex@latest"
fi
