# ============================================================
# ClaudeCat Workspace Setup
# Run via setup.bat (double-click) or: powershell -ExecutionPolicy Bypass -File setup.ps1
# ============================================================

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ClaudeCat Workspace Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Workspace: $Root"
Write-Host ""

# ── Step 1: Check prerequisites ──────────────────────────────

Write-Host "[1/4] Checking prerequisites..." -ForegroundColor Yellow

# Node.js
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host "  ERROR: Node.js not found. Install from https://nodejs.org" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "  Node.js: $($node.Source)" -ForegroundColor Green

# Claude Code
$claude = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claude) {
    Write-Host "  WARNING: Claude Code CLI not found." -ForegroundColor Yellow
    Write-Host "  Install: npm install -g @anthropic-ai/claude-code" -ForegroundColor Yellow
    Write-Host "  Then run: claude login" -ForegroundColor Yellow
    $skipClaude = $true
} else {
    Write-Host "  Claude Code: $($claude.Source)" -ForegroundColor Green
    $skipClaude = $false
}

# Git (optional, for worktree skill)
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Host "  Git: $($git.Source)" -ForegroundColor Green
} else {
    Write-Host "  Git: not found (optional, some skills need it)" -ForegroundColor Yellow
}

Write-Host ""

# ── Step 2: Initialize git repo ──────────────────────────────

Write-Host "[2/4] Initializing git repository..." -ForegroundColor Yellow

if ($git) {
    $gitDir = Join-Path $Root ".git"
    if (-not (Test-Path $gitDir)) {
        Push-Location $Root
        git init
        git add -A
        git commit -m "Initial ClaudeCat workspace setup"
        Pop-Location
        Write-Host "  Git repo initialized" -ForegroundColor Green
    } else {
        Write-Host "  Git repo already exists" -ForegroundColor Green
    }
} else {
    Write-Host "  Skipped (git not installed)" -ForegroundColor Yellow
}

Write-Host ""

# ── Step 3: Generate settings.json from template ─────────────

Write-Host "[3/4] Configuring .claude/settings.json..." -ForegroundColor Yellow

$settingsTemplate = Join-Path $Root ".claude\settings.json.template"
$settingsTarget = Join-Path $Root ".claude\settings.json"

if (Test-Path $settingsTemplate) {
    $content = Get-Content $settingsTemplate -Raw
    $workspacePath = $Root.Replace('\', '/')
    $content = $content.Replace('{{WORKSPACE}}', $workspacePath)
    Set-Content -Path $settingsTarget -Value $content -Encoding UTF8
    Write-Host "  settings.json created with workspace path" -ForegroundColor Green
} else {
    Write-Host "  Template not found, skipping" -ForegroundColor Yellow
}

Write-Host ""

# ── Step 4: Ensure directory structure ───────────────────────

Write-Host "[4/4] Verifying directory structure..." -ForegroundColor Yellow

$dirs = @(
    "01_user",
    "02_claude\01_identity",
    "02_claude\02_skills",
    "02_claude\03_learning",
    "03_conversation",
    "04_project",
    ".claude\tasks\01_tasks"
)

foreach ($d in $dirs) {
    $full = Join-Path $Root $d
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
    }
}

# Initialize data files if empty
$tasksFile = Join-Path $Root ".claude\tasks\01_tasks.json"
if (-not (Test-Path $tasksFile) -or (Get-Item $tasksFile).Length -eq 0) {
    '{"tasks": []}' | Set-Content $tasksFile -Encoding UTF8
}

Write-Host "  All directories and data files verified" -ForegroundColor Green
Write-Host ""

# ── Summary ──────────────────────────────────────────────────

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open a terminal in this directory"
Write-Host "  2. Run: claude"
Write-Host "  3. Try: /dispatch `"create a hello.txt in 04_project`""
Write-Host "  4. Read GUIDE.md for full usage guide"
Write-Host ""

if ($skipClaude) {
    Write-Host "REMINDER: Install Claude Code first:" -ForegroundColor Yellow
    Write-Host "  npm install -g @anthropic-ai/claude-code" -ForegroundColor Yellow
    Write-Host "  claude login" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Press Enter to close"
