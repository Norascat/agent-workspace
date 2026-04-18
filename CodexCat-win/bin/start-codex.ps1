$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

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

$codexPath = Resolve-CodexPath
if (-not $codexPath) {
    Write-Host 'Codex CLI not found. Run setup.cmd first, or install @openai/codex globally.' -ForegroundColor Yellow
    exit 1
}

& $codexPath
