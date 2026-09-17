#!/usr/bin/env bash
# Install repo-analyzer skills + tools for Claude Code and Codex. Idempotent.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS=(analyze-repo audit-repo-security)
TOOLS=(repo-signals verify-packet)

link() { # link <target> <linkpath>
  local target="$1" linkpath="$2"
  if [ -L "$linkpath" ] && [ "$(readlink "$linkpath")" = "$target" ]; then
    echo "  ok      $linkpath"
  elif [ -e "$linkpath" ] || [ -L "$linkpath" ]; then
    echo "  SKIP    $linkpath exists and is not a symlink to this repo — resolve manually"
  else
    ln -s "$target" "$linkpath"
    echo "  linked  $linkpath -> $target"
  fi
}

echo "Skills -> Claude Code (~/.claude/commands/)"
mkdir -p "$HOME/.claude/commands"
for s in "${SKILLS[@]}"; do
  link "$REPO_DIR/skills/$s.md" "$HOME/.claude/commands/$s.md"
done

echo "Skills -> Codex (~/.codex/prompts/)"
mkdir -p "$HOME/.codex/prompts"
for s in "${SKILLS[@]}"; do
  link "$REPO_DIR/skills/$s.md" "$HOME/.codex/prompts/$s.md"
done

echo "Tools -> PATH"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
for t in "${TOOLS[@]}"; do
  link "$REPO_DIR/bin/$t" "$BIN_DIR/$t"
done
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "  NOTE: $BIN_DIR is not on your PATH. Add:"
     echo "        export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac

echo
echo "Done. Codex loads its prompt list at process start — relaunch any running"
echo "Codex session to see /analyze-repo and /audit-repo-security."
