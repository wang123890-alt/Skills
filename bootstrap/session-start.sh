#!/bin/bash
# 給「其他專案」用的 SessionStart hook。
#
# 用法：把這個檔案複製到目標專案的 .claude/hooks/session-start.sh，
#      並在該專案的 .claude/settings.json 註冊（格式見本 repo 的 .claude/settings.json）。
#
# 效果：那個專案每次開新 session 時，會自動抓取 wang123890-alt/skills
#      並把裡面所有通用 skill 安裝到 ~/.claude/skills/。
set -euo pipefail

REPO_URL="${CLAUDE_SKILLS_REPO:-https://github.com/wang123890-alt/skills}"
CACHE_DIR="${CLAUDE_SKILLS_CACHE:-$HOME/.cache/wang-skills}"

if [ -d "$CACHE_DIR/.git" ]; then
  git -C "$CACHE_DIR" fetch --depth 1 origin HEAD >/dev/null 2>&1 || true
  git -C "$CACHE_DIR" reset --hard FETCH_HEAD >/dev/null 2>&1 || true
else
  rm -rf "$CACHE_DIR"
  # repo 若為 private，這一步需要該 session 具備存取權限（例如已用 add_repo 掛上）。
  git clone --depth 1 "$REPO_URL" "$CACHE_DIR" >/dev/null 2>&1 || {
    echo "略過 skill 安裝：無法取得 $REPO_URL（可能是權限不足或離線）" >&2
    exit 0
  }
fi

bash "$CACHE_DIR/install.sh"
