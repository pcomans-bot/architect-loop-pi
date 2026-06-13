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

# Builder: pi pointed at a cheap model (DeepSeek by default).
if command -v pi >/dev/null 2>&1; then
    echo "pi found: $(pi --version)"
    # web_search tool: pi-search-hub (keyless DuckDuckGo by default; Tavily etc. optional).
    # Fail loudly — researchers depend on web_search; don't swallow the error.
    if pi install npm:pi-search-hub; then
        echo "Installed pi-search-hub (web_search tool)"
    else
        echo "ERROR: failed to install pi-search-hub (web_search for researchers)." >&2
        echo "       Fix the error above, then run: pi install npm:pi-search-hub" >&2
    fi
else
    echo "pi not found - install the builder: npm i -g --ignore-scripts @earendil-works/pi-coding-agent@latest"
    echo "  then re-run ./install.sh (it installs pi-search-hub for web_search)"
fi

# Keyless DuckDuckGo (the default web_search backend) needs the `ddgs` Python pkg.
# We don't auto-install it (no global pip mutation) — just say so if it's missing.
if ! python3 -c 'import ddgs' >/dev/null 2>&1; then
    echo "NOTE: keyless DuckDuckGo search needs the 'ddgs' package — run: pip install ddgs" >&2
fi

echo "Set your builder key:  export DEEPSEEK_API_KEY=sk-...        (see skills/architect/dispatch.md to switch models)"
echo "Optional better search: export SEARCH_TAVILY_API_KEY=tvly-...  (else web_search uses keyless DuckDuckGo)"
echo "Optional hardening:     npm config set min-release-age 4      (season npm installs; see README)"
