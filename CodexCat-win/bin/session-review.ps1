$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$reviewDir = Join-Path $root '03_conversation'
New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null

$slug = if ($args.Count -gt 0) { $args[0] } else { 'session' }
$slug = (($slug.ToLowerInvariant() -replace '[^a-z0-9]+', '-') -replace '^-|-$', '')
if (-not $slug) {
    $slug = 'session'
}

$dateStamp = Get-Date -Format 'yyyyMMdd'
$humanDate = Get-Date -Format 'yyyy-MM-dd'
$file = Join-Path $reviewDir ("review_{0}_{1}.md" -f $dateStamp, $slug)

$content = @"
# Session Review — $humanDate

## Completed
- 

## Key Decisions
- 

## Problems & Solutions
- 

## Open Items
- 
"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created review: $file"
