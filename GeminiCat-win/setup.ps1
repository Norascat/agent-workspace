# ============================================================
# GeminiCat Workspace Setup (Windows)
# Usage: Double-click setup.bat
# ============================================================

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GeminiCat Workspace Setup (Windows)" -ForegroundColor Cyan
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

# Gemini CLI
$gemini = Get-Command gemini -ErrorAction SilentlyContinue
if (-not $gemini) {
    Write-Host "  WARNING: Gemini CLI not found." -ForegroundColor Yellow
    Write-Host "  Install: npm install -g @google/gemini-cli" -ForegroundColor Yellow
    Write-Host "  Then run: gemini login" -ForegroundColor Yellow
    $skipGemini = $true
} else {
    Write-Host "  Gemini CLI: $($gemini.Source)" -ForegroundColor Green
    $skipGemini = $false
}

# Git (optional)
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Host "  Git: $($git.Source)" -ForegroundColor Green
} else {
    Write-Host "  Git: not found (optional)" -ForegroundColor Yellow
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
        git commit -m "Initial GeminiCat workspace setup"
        Pop-Location
        Write-Host "  Git repo initialized" -ForegroundColor Green
    } else {
        Write-Host "  Git repo already exists" -ForegroundColor Green
    }
} else {
    Write-Host "  Skipped (git not installed)" -ForegroundColor Yellow
}

Write-Host ""

# ── Step 3: Ensure directory structure ───────────────────────

Write-Host "[3/4] Verifying directory structure..." -ForegroundColor Yellow

$dirs = @(
    "01_user",
    "02_gemini\01_identity",
    "02_gemini\02_skills",
    "02_gemini\03_learning",
    "03_conversation",
    "04_project",
    ".gemini\tasks\01_tasks"
)

foreach ($d in $dirs) {
    $full = Join-Path $Root $d
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
    }
}

# Initialize data files
$tasksFile = Join-Path $Root ".gemini\tasks\01_tasks.json"
if (-not (Test-Path $tasksFile) -or (Get-Item $tasksFile).Length -eq 0) {
    '{"tasks": []}' | Set-Content $tasksFile -Encoding UTF8
}

# .geminiignore for Windows
$ignoreFile = Join-Path $Root ".geminiignore"
if (-not (Test-Path $ignoreFile)) {
    ".git/`r`nnode_modules/`r`n.DS_Store" | Set-Content $ignoreFile -Encoding UTF8
    Write-Host "  .geminiignore created" -ForegroundColor Green
}

Write-Host "  All directories and data files verified" -ForegroundColor Green
Write-Host ""

# ── Summary ──────────────────────────────────────────────────

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open a terminal (CMD or PowerShell) in this directory"
Write-Host "  2. Run: gemini"
Write-Host "  3. Use 'activate_skill' to load existing skills"
Write-Host "  4. Read GUIDE_Windows.md for full usage guide"
Write-Host ""

if ($skipGemini) {
    Write-Host "REMINDER: Install Gemini CLI first:" -ForegroundColor Yellow
    Write-Host "  npm install -g @google/gemini-cli" -ForegroundColor Yellow
    Write-Host "  gemini login" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Press Enter to close"
