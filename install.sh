#!/bin/sh
# install agent-cage into ~/.local/bin (or $AGENT_CAGE_BIN)
# usage: curl -fsSL https://raw.githubusercontent.com/kilazi/agent-cage/main/install.sh | sh
set -eu
SRC="${AGENT_CAGE_SRC:-https://raw.githubusercontent.com/kilazi/agent-cage/main/agent-cage}"
BIN="${AGENT_CAGE_BIN:-$HOME/.local/bin}"
[ "$(uname -s)" = "Darwin" ] || { echo "agent-cage: macOS only" >&2; exit 1; }
mkdir -p "$BIN"
case "$SRC" in
  http://*|https://*) curl -fsSL "$SRC" -o "$BIN/agent-cage.tmp" ;;
  *) cp "$SRC" "$BIN/agent-cage.tmp" ;;
esac
chmod +x "$BIN/agent-cage.tmp"
mv "$BIN/agent-cage.tmp" "$BIN/agent-cage"
echo "installed $BIN/agent-cage"
case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo "add it to your PATH: echo 'export PATH=\"$BIN:\$PATH\"' >> ~/.zshrc" ;;
esac
"$BIN/agent-cage" --selftest
