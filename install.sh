#!/usr/bin/env bash
set -euo pipefail

SRC_ROOT="$(cd "$(dirname "$0")" && pwd)/skills"
if [ "${1:-}" = "--project" ]; then
    DEST_ROOT="$(pwd)/.claude/skills"
else
    DEST_ROOT="$HOME/.claude/skills"
fi

mkdir -p "$DEST_ROOT"
for skill in "$SRC_ROOT"/*/; do
    name="$(basename "$skill")"
    rm -rf "${DEST_ROOT:?}/$name"
    cp -r "$skill" "$DEST_ROOT/$name"
    echo "Installed /$name to $DEST_ROOT/$name"
done

# Supply-chain seasoning for every npm install (pi, pi-search-hub, deps): only
# install versions public >=4 days, so a poisoned release can be caught/yanked first.
command -v npm >/dev/null 2>&1 && npm config set min-release-age 4 >/dev/null 2>&1 || true

# Builder: pi pointed at a cheap model (DeepSeek by default).
if command -v pi >/dev/null 2>&1; then
    echo "pi found: $(pi --version)"
    # web_search tool: pi-search-hub (keyless DuckDuckGo by default; Tavily etc. optional)
    pi install npm:pi-search-hub >/dev/null 2>&1 && echo "Installed pi-search-hub (web_search tool)"
else
    echo "pi not found - install the builder: npm i -g --ignore-scripts @earendil-works/pi-coding-agent@latest"
    echo "  then re-run ./install.sh (it installs pi-search-hub for web_search)"
fi
# Keyless DuckDuckGo search needs the ddgs Python package
command -v pip3 >/dev/null 2>&1 && { pip3 install --quiet ddgs 2>/dev/null || pip3 install --quiet --break-system-packages ddgs 2>/dev/null; } || true
echo "Set your builder key:  export DEEPSEEK_API_KEY=sk-...   (see skills/architect/dispatch.md to switch models)"
echo "Optional better search: export TAVILY_API_KEY=tvly-...  (else web_search uses keyless DuckDuckGo)"
