#!/bin/bash
# 把這個 repo 裡的 skills 安裝到使用者層級的 ~/.claude/skills/
# 任何專案的 Claude Code session 都能載入。可重複執行（idempotent）。
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST"

count=0
for dir in "$SRC"/*/; do
  [ -f "${dir}SKILL.md" ] || continue
  name="$(basename "$dir")"
  rm -rf "${DEST:?}/$name"
  cp -r "$dir" "$DEST/$name"
  count=$((count + 1))
done

echo "已安裝 $count 個 skill 到 $DEST"
