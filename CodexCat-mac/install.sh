#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN="${CODEXCAT_DRY_RUN:-0}"
FAKE_MISSING="${CODEXCAT_FAKE_MISSING:-}"
FAKE_BREW="${CODEXCAT_FAKE_BREW:-0}"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

MISSING_WARNINGS=()
SKIP_CODEX=false

echo_cmd() {
    printf '+'
    for arg in "$@"; do
        printf ' %q' "$arg"
    done
    printf '\n'
}

run_cmd() {
    if [ "$DRY_RUN" = "1" ]; then
        echo_cmd "$@"
    else
        "$@"
    fi
}

has_cmd() {
    local name="$1"
    case ",$FAKE_MISSING," in
        *,"$name",*) return 1 ;;
    esac
    command -v "$name" >/dev/null 2>&1
}

has_brew() {
    if [ "$FAKE_BREW" = "1" ]; then
        return 0
    fi
    has_cmd brew
}

add_warning() {
    MISSING_WARNINGS+=("$1")
}

auto_install_brew_pkg() {
    local display_name="$1"
    local package_name="$2"

    if has_brew; then
        echo -e "${YELLOW}  Auto-installing ${display_name} via Homebrew...${NC}"
        run_cmd brew install "$package_name"
        return 0
    fi

    echo -e "${YELLOW}  ${display_name} missing, but Homebrew is not available for automatic install.${NC}"
    add_warning "${display_name}: install manually or install Homebrew first"
    return 1
}

ensure_node() {
    if has_cmd node; then
        echo -e "${GREEN}  Node.js: $(command -v node)  $(node --version)${NC}"
        return
    fi

    if auto_install_brew_pkg "Node.js" "node" && [ "$DRY_RUN" != "1" ] && has_cmd node; then
        echo -e "${GREEN}  Node.js: $(command -v node)  $(node --version)${NC}"
    fi
}

ensure_python3() {
    if has_cmd python3; then
        echo -e "${GREEN}  python3: $(command -v python3)  $(python3 --version)${NC}"
        return
    fi

    if auto_install_brew_pkg "python3" "python" && [ "$DRY_RUN" != "1" ] && has_cmd python3; then
        echo -e "${GREEN}  python3: $(command -v python3)  $(python3 --version)${NC}"
    fi
}

ensure_git() {
    if has_cmd git; then
        echo -e "${GREEN}  Git: $(command -v git)  $(git --version)${NC}"
        return
    fi

    if auto_install_brew_pkg "Git" "git" && [ "$DRY_RUN" != "1" ] && has_cmd git; then
        echo -e "${GREEN}  Git: $(command -v git)  $(git --version)${NC}"
    fi
}

ensure_codex() {
    if has_cmd codex; then
        echo -e "${GREEN}  Codex: $(command -v codex)${NC}"
        return
    fi

    if ! has_cmd npm && has_brew; then
        auto_install_brew_pkg "Node.js" "node" || true
    fi

    if has_cmd npm; then
        echo -e "${YELLOW}  Auto-installing Codex CLI via npm...${NC}"
        run_cmd npm install -g @openai/codex
    else
        echo -e "${YELLOW}  Codex CLI missing, and npm is unavailable for automatic install.${NC}"
        add_warning "Codex CLI: install manually after Node.js/npm is available"
    fi

    if [ "$DRY_RUN" = "1" ]; then
        return
    fi

    if has_cmd codex; then
        echo -e "${GREEN}  Codex: $(command -v codex)${NC}"
    else
        SKIP_CODEX=true
    fi
}

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  CodexCat Workspace Setup (macOS)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Workspace: $ROOT"
echo ""

echo -e "${YELLOW}[1/4] Checking prerequisites...${NC}"

ensure_node
ensure_python3
ensure_git
ensure_codex

echo ""
echo -e "${YELLOW}[2/4] Creating workspace runtime directories...${NC}"

dirs=(
    ".codex/skills"
    ".codex/tasks/01_tasks"
    "01_user"
    "02_codex/01_identity"
    "02_codex/02_skills"
    "02_codex/03_learning"
    "03_conversation"
    "04_project"
    "bin"
    "docs"
    "tests"
)

for d in "${dirs[@]}"; do
    run_cmd mkdir -p "$ROOT/$d"
done

echo -e "${GREEN}  Directory structure verified${NC}"
echo ""

echo -e "${YELLOW}[3/4] Generating local config and task registry...${NC}"

TEMPLATE="$ROOT/.codex/config.json.template"
TARGET="$ROOT/.codex/config.json"
TASKS_FILE="$ROOT/.codex/tasks/01_tasks.json"

if [ -f "$TEMPLATE" ]; then
    run_cmd cp "$TEMPLATE" "$TARGET"
    echo -e "${GREEN}  Generated .codex/config.json${NC}"
else
    echo -e "${YELLOW}  Missing .codex/config.json.template; skipped config generation${NC}"
fi

if [ "$DRY_RUN" = "1" ]; then
    echo_cmd printf '{\n  "tasks": []\n}\n' '>' "$TASKS_FILE"
elif [ ! -f "$TASKS_FILE" ] || [ ! -s "$TASKS_FILE" ]; then
    printf '{\n  "tasks": []\n}\n' > "$TASKS_FILE"
fi

echo -e "${GREEN}  Task registry verified${NC}"
echo ""

echo -e "${YELLOW}[4/4] Fixing script permissions...${NC}"

run_cmd chmod +x "$ROOT/install.sh"
run_cmd chmod +x "$ROOT/setup.command"

if [ -d "$ROOT/bin" ]; then
    if [ "$DRY_RUN" = "1" ]; then
        echo_cmd find "$ROOT/bin" -maxdepth 1 -type f -exec chmod +x '{}' ';'
    else
        find "$ROOT/bin" -maxdepth 1 -type f -exec chmod +x {} \;
    fi
fi

if [ -d "$ROOT/tests" ]; then
    if [ "$DRY_RUN" = "1" ]; then
        echo_cmd find "$ROOT/tests" -maxdepth 1 -type f -exec chmod +x '{}' ';'
    else
        find "$ROOT/tests" -maxdepth 1 -type f -exec chmod +x {} \;
    fi
fi

echo -e "${GREEN}  Script permissions updated${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. 运行: bin/start-codex"
echo "  2. 阅读: GUIDE.md"
echo "  3. 试试: bin/task-status"
echo "  4. 登记任务: bin/dispatch-task \"任务描述\""
echo ""

if [ ${#MISSING_WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Manual follow-up:${NC}"
    for warning in "${MISSING_WARNINGS[@]}"; do
        echo "  - $warning"
    done
    echo ""
fi

if $SKIP_CODEX; then
    echo -e "${YELLOW}REMINDER:${NC} 当前终端仍找不到 Codex CLI。先确认全局安装已完成，再运行 bin/start-codex。"
    echo ""
fi
