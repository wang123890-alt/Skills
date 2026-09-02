#!/bin/bash
# SessionStart hook：在這個 repo 開 session 時，自動把 skills 安裝到 ~/.claude/skills/
set -euo pipefail

"${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}/install.sh"
