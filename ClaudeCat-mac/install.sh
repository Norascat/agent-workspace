#!/bin/bash
# ============================================================
# ClaudeCat Workspace Setup — macOS
# 运行方式：双击 setup.command，或终端执行 bash install.sh
# ============================================================

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ANSI 颜色
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  ClaudeCat Workspace Setup (macOS)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Workspace: $ROOT"
echo ""

# ── Step 1: 检查依赖 ─────────────────────────────────────────

echo -e "${YELLOW}[1/4] Checking prerequisites...${NC}"

# Node.js（必须）
if ! command -v node &>/dev/null; then
    echo -e "${RED}  ERROR: Node.js not found.${NC}"
    echo "  安装方式（任选一）："
    echo "    brew install node"
    echo "    或访问 https://nodejs.org 下载安装包"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi
echo -e "${GREEN}  Node.js: $(command -v node)  $(node --version)${NC}"

# Claude Code CLI（必须，未装则警告）
SKIP_CLAUDE=false
if ! command -v claude &>/dev/null; then
    echo -e "${YELLOW}  WARNING: Claude Code CLI not found.${NC}"
    echo -e "${YELLOW}  Install: npm install -g @anthropic-ai/claude-code${NC}"
    echo -e "${YELLOW}  Then run: claude login${NC}"
    SKIP_CLAUDE=true
else
    echo -e "${GREEN}  Claude Code: $(command -v claude)${NC}"
fi

# Git（可选，部分 skill 需要）
if command -v git &>/dev/null; then
    echo -e "${GREEN}  Git: $(command -v git)  $(git --version)${NC}"
else
    echo -e "${YELLOW}  Git: not found (optional, some skills need it)${NC}"
fi

echo ""

# ── Step 2: 初始化 git 仓库 ───────────────────────────────────

echo -e "${YELLOW}[2/4] Initializing git repository...${NC}"

if command -v git &>/dev/null; then
    if [ ! -d "$ROOT/.git" ]; then
        cd "$ROOT"
        git init
        git add -A
        git commit -m "Initial ClaudeCat workspace setup"
        echo -e "${GREEN}  Git repo initialized${NC}"
    else
        echo -e "${GREEN}  Git repo already exists${NC}"
    fi
else
    echo -e "${YELLOW}  Skipped (git not installed)${NC}"
fi

echo ""

# ── Step 3: 生成 settings.json ────────────────────────────────

echo -e "${YELLOW}[3/4] Configuring .claude/settings.json...${NC}"

TEMPLATE="$ROOT/.claude/settings.json.template"
TARGET="$ROOT/.claude/settings.json"

if [ -f "$TEMPLATE" ]; then
    # 替换 {{WORKSPACE}} 占位符（当前版本模板未使用，保留以备扩展）
    sed "s|{{WORKSPACE}}|$ROOT|g" "$TEMPLATE" > "$TARGET"
    echo -e "${GREEN}  settings.json created${NC}"
else
    echo -e "${YELLOW}  Template not found, skipping${NC}"
fi

echo ""

# ── Step 4: 确保目录结构完整 ──────────────────────────────────

echo -e "${YELLOW}[4/4] Verifying directory structure...${NC}"

dirs=(
    "01_user"
    "02_claude/01_identity"
    "02_claude/02_skills"
    "02_claude/03_learning"
    "03_conversation"
    "04_project"
    ".claude/tasks/01_tasks"
)

for d in "${dirs[@]}"; do
    mkdir -p "$ROOT/$d"
done

# 初始化任务注册表
TASKS_FILE="$ROOT/.claude/tasks/01_tasks.json"
if [ ! -f "$TASKS_FILE" ] || [ ! -s "$TASKS_FILE" ]; then
    echo '{"tasks": []}' > "$TASKS_FILE"
fi

# 设置 setup.command 可执行权限（二次确保）
chmod +x "$ROOT/setup.command" 2>/dev/null || true

echo -e "${GREEN}  All directories and data files verified${NC}"
echo ""

# ── 完成提示 ─────────────────────────────────────────────────

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. 打开终端，cd 到此文件夹"
echo "  2. 运行: claude"
echo "  3. 试试: /dispatch \"create a hello.txt in 04_project\""
echo "  4. 阅读 GUIDE.md 了解完整用法"
echo ""

if $SKIP_CLAUDE; then
    echo -e "${YELLOW}REMINDER: 先安装 Claude Code：${NC}"
    echo -e "${YELLOW}  npm install -g @anthropic-ai/claude-code${NC}"
    echo -e "${YELLOW}  claude login${NC}"
    echo ""
fi
