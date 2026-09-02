# Skills

個人通用 Claude Code skills 集中倉庫。所有 skill 都設計成**跨專案通用**，安裝到使用者層級的
`~/.claude/skills/` 之後，任何專案的 session 都能自動觸發，不綁定特定 repo。

## 內容

### 架構解析（開源引入）

| Skill | 用途 | 來源 |
|---|---|---|
| `codebase-analysis` | 九階段深度解析，每個結論附 `[VERIFY: file:line]` 程式碼佐證，防幻覺。適合**初次解析**一個陌生專案 | [Ycsyyds/codebase-analysis-skill](https://github.com/Ycsyyds/codebase-analysis-skill) |
| `architecture-workflow` | 總指揮：discover → diagnose → fix → document 全流程，會自動挑下面對應的專門 skill | [keez97/claude-architecture-skills](https://github.com/keez97/claude-architecture-skills) |
| `describe-design` | 反推架構並產出 Mermaid 圖（C4／循序圖／ER／部署圖） | 同上 |
| `python-architecture-review` | Python／FastAPI 後端架構審查 | 同上 |
| `modern-web-app-architecture` | 前端／Web 架構審查（渲染策略、狀態管理、bundle） | 同上 |
| `cloud-infrastructure` | AWS／Terraform／CDK 基礎設施與成本優化 | 同上 |
| `microservices-architect` | 分散式系統與微服務邊界設計 | 同上 |
| `software-architecture` | 語言無關的 Clean Architecture／SOLID／ADR | 同上 |

分工：`codebase-analysis` 只描述現狀、要求有出處，不評價好壞；`architecture-workflow` 系列會評價並提出修改。
兩者在「掃描專案結構」這一段有重疊，其餘互補。

### 自製工作方法（原本放在 ai-stock-decision-assistant）

| Skill | 用途 |
|---|---|
| `verify-before-trust` | 別直接信任其他 agent 說「做完了」；診斷問題時別停在第一個聽起來合理的解釋 |
| `feature-batch-workflow` | 多階段功能交付節奏：契約 → 只讀調查 → 沙盒純函式 → 真實接線 → UI 與人工確認關卡 |
| `data-source-verification` | 選外部 API 時把合法性／新鮮度／解析難度拆成三個獨立問題；寫 parser 前先拿到真實原始樣本 |

## 安裝

### 方式一：手動安裝（本機電腦，一次就好）

```bash
git clone https://github.com/wang123890-alt/skills ~/wang-skills
~/wang-skills/install.sh
```

安裝到 `~/.claude/skills/`，之後本機所有專案的 Claude Code 都能用。更新時 `git pull` 再跑一次 `install.sh`。

### 方式二：在這個 repo 開 session（自動）

本 repo 已設定 SessionStart hook（`.claude/hooks/session-start.sh`），
在 Claude Code on the web 開這個 repo 的 session 時會自動安裝，不用手動下指令。

### 方式三：讓「其他專案」也自動安裝

雲端 session 的容器每次都是全新的，`~/.claude/skills/` 不會保留。
要讓其他專案的 session 也自動載入這些 skill，把 bootstrap hook 複製過去：

```bash
mkdir -p <目標專案>/.claude/hooks
cp bootstrap/session-start.sh <目標專案>/.claude/hooks/session-start.sh
chmod +x <目標專案>/.claude/hooks/session-start.sh
# 再把本 repo 的 .claude/settings.json 內容合併進目標專案的 .claude/settings.json
```

該專案之後每次開 session，都會自動抓取本 repo 並安裝所有 skill。

> 注意：本 repo 目前為 private，方式三在其他 session 裡 clone 時需要該 session 具備存取權限。
> 若希望任何 session 都能無痛抓取，可考慮把本 repo 改為 public（內容不含任何憑證或機敏資料）。

## 授權

自製的三個 skill（`verify-before-trust`、`feature-batch-workflow`、
`data-source-verification`）為本倉庫作者所有。

其餘來自第三方開源專案，皆為 MIT 授權，原始授權條文與著作權聲明保留於
[`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md)。部分 skill 有在本倉庫做過修改，
該檔案逐一標注了改了什麼。

## 新增 skill

在 `skills/` 底下建一個資料夾，放入 `SKILL.md`（YAML frontmatter 需含 `name` 與 `description`），
push 之後重跑 `install.sh` 即可。`description` 寫得越具體，自動觸發越準。
