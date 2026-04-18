$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dryRun = $env:CODEXCAT_DRY_RUN -eq '1'
$fakeMissing = @()

if ($env:CODEXCAT_FAKE_MISSING) {
    $fakeMissing = $env:CODEXCAT_FAKE_MISSING.Split(',') | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ }
}

$warnings = New-Object System.Collections.Generic.List[string]
$skipCodex = $false

function Write-Info($message) {
    Write-Host $message -ForegroundColor Green
}

function Write-Warn($message) {
    Write-Host $message -ForegroundColor Yellow
}

function Invoke-LoggedCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Command
    )

    if ($dryRun) {
        Write-Host ('+ ' + ($Command -join ' '))
        return
    }

    & $Command[0] @Command[1..($Command.Length - 1)]
}

function Test-CommandAvailable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($fakeMissing -contains $Name.ToLowerInvariant()) {
        return $false
    }

    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-WingetAvailable {
    return Test-CommandAvailable -Name 'winget'
}

function Add-Warning {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $warnings.Add($Message) | Out-Null
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )

    if (-not (Test-WingetAvailable)) {
        Write-Warn "  $DisplayName missing, but winget is not available for automatic install."
        Add-Warning "$DisplayName: install manually or install winget first"
        return $false
    }

    Write-Warn "  Auto-installing $DisplayName via winget..."
    Invoke-LoggedCommand -Command @(
        'winget', 'install', '--id', $PackageId, '--exact', '--source', 'winget',
        '--accept-package-agreements', '--accept-source-agreements'
    )
    return $true
}

function Ensure-Node {
    if (Test-CommandAvailable -Name 'node') {
        Write-Info "  Node.js: $((Get-Command node).Source)  $(& node --version)"
        return
    }

    if ((Install-WingetPackage -DisplayName 'Node.js LTS' -PackageId 'OpenJS.NodeJS.LTS') -and -not $dryRun -and (Test-CommandAvailable -Name 'node')) {
        Write-Info "  Node.js: $((Get-Command node).Source)  $(& node --version)"
    }
}

function Ensure-Python {
    if (Test-CommandAvailable -Name 'python') {
        Write-Info "  Python: $((Get-Command python).Source)  $(& python --version)"
        return
    }

    if ((Install-WingetPackage -DisplayName 'Python 3' -PackageId 'Python.Python.3') -and -not $dryRun -and (Test-CommandAvailable -Name 'python')) {
        Write-Info "  Python: $((Get-Command python).Source)  $(& python --version)"
    }
}

function Ensure-Git {
    if (Test-CommandAvailable -Name 'git') {
        Write-Info "  Git: $((Get-Command git).Source)  $(& git --version)"
        return
    }

    if ((Install-WingetPackage -DisplayName 'Git' -PackageId 'Git.Git') -and -not $dryRun -and (Test-CommandAvailable -Name 'git')) {
        Write-Info "  Git: $((Get-Command git).Source)  $(& git --version)"
    }
}

function Resolve-CodexPath {
    $cmd = Get-Command codex -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    $npm = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npm) {
        return $null
    }

    $prefix = (& npm config get prefix).Trim()
    if (-not $prefix) {
        return $null
    }

    $candidate = Join-Path $prefix 'codex.cmd'
    if (Test-Path $candidate) {
        return $candidate
    }

    return $null
}

function Ensure-Codex {
    $resolved = Resolve-CodexPath
    if ($resolved) {
        Write-Info "  Codex: $resolved"
        return
    }

    if (-not (Test-CommandAvailable -Name 'npm')) {
        if (Test-WingetAvailable) {
            Install-WingetPackage -DisplayName 'Node.js LTS' -PackageId 'OpenJS.NodeJS.LTS' | Out-Null
        }
    }

    if (Test-CommandAvailable -Name 'npm') {
        Write-Warn '  Auto-installing Codex CLI via npm...'
        Invoke-LoggedCommand -Command @('npm', 'install', '-g', '@openai/codex')
    }
    else {
        Write-Warn '  Codex CLI missing, and npm is unavailable for automatic install.'
        Add-Warning 'Codex CLI: install manually after Node.js/npm is available'
    }

    if ($dryRun) {
        return
    }

    $resolved = Resolve-CodexPath
    if ($resolved) {
        Write-Info "  Codex: $resolved"
    }
    else {
        $script:skipCodex = $true
    }
}

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  CodexCat Workspace Setup (Windows)' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''
Write-Host "Workspace: $root"
Write-Host ''

Write-Host '[1/4] Checking prerequisites...' -ForegroundColor Yellow
Ensure-Node
Ensure-Python
Ensure-Git
Ensure-Codex

Write-Host ''
Write-Host '[2/4] Creating workspace runtime directories...' -ForegroundColor Yellow

$dirs = @(
    '.codex\skills',
    '.codex\tasks\01_tasks',
    '01_user',
    '02_codex\01_identity',
    '02_codex\02_skills',
    '02_codex\03_learning',
    '03_conversation',
    '04_project',
    'bin',
    'tests'
)

foreach ($dir in $dirs) {
    $full = Join-Path $root $dir
    if ($dryRun) {
        Write-Host "+ New-Item -ItemType Directory -Force -Path `"$full`""
    }
    else {
        New-Item -ItemType Directory -Force -Path $full | Out-Null
    }
}

Write-Info '  Directory structure verified'
Write-Host ''

Write-Host '[3/4] Generating local config and task registry...' -ForegroundColor Yellow

$template = Join-Path $root '.codex\config.json.template'
$target = Join-Path $root '.codex\config.json'
$tasksFile = Join-Path $root '.codex\tasks\01_tasks.json'

if (Test-Path $template) {
    if ($dryRun) {
        Write-Host "+ Copy-Item `"$template`" `"$target`" -Force"
    }
    else {
        Copy-Item $template $target -Force
    }
    Write-Info '  Generated .codex\config.json'
}
else {
    Write-Warn '  Missing .codex\config.json.template; skipped config generation'
}

if ($dryRun) {
    Write-Host "+ Set-Content `"$tasksFile`" '{`n  `"tasks`": []`n}'"
}
elseif (-not (Test-Path $tasksFile) -or -not (Get-Item $tasksFile).Length) {
    Set-Content -Path $tasksFile -Value "{`n  `"tasks`": []`n}" -Encoding UTF8
}

Write-Info '  Task registry verified'
Write-Host ''

Write-Host '[4/4] Setup complete.' -ForegroundColor Yellow
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host '  1. 双击 start-codex.cmd'
Write-Host '  2. 阅读 GUIDE.md'
Write-Host '  3. 试试 bin\task-status.cmd'
Write-Host '  4. 登记任务: bin\dispatch-task.cmd "任务描述"'
Write-Host ''

if ($warnings.Count -gt 0) {
    Write-Host 'Manual follow-up:' -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning"
    }
    Write-Host ''
}

if ($skipCodex) {
    Write-Host 'REMINDER: 当前终端仍找不到 Codex CLI。重新打开 PowerShell 后再运行 start-codex.cmd。' -ForegroundColor Yellow
    Write-Host ''
}
