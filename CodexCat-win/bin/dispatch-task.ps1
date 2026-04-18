$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$registry = Join-Path $root '.codex\tasks\01_tasks.json'
$taskDir = Join-Path $root '.codex\tasks\01_tasks'

if ($args.Count -eq 0) {
    Write-Host 'Usage: .\bin\dispatch-task.ps1 "task description"'
    exit 1
}

New-Item -ItemType Directory -Force -Path $taskDir | Out-Null

if (-not (Test-Path $registry)) {
    Set-Content -Path $registry -Value "{`n  `"tasks`": []`n}" -Encoding UTF8
}

$description = ($args -join ' ').Trim()
$data = Get-Content $registry -Raw | ConvertFrom-Json
if (-not $data.tasks) {
    $data | Add-Member -NotePropertyName tasks -NotePropertyValue @()
}

$id = '{0:D2}' -f ($data.tasks.Count + 1)
$timestamp = Get-Date -Format 'yyyyMMddHHmmss'
$isoTime = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$humanTime = Get-Date -Format 'yyyy-MM-dd HH:mm'
$slug = (($description.ToLowerInvariant() -replace '[^a-z0-9]+', '-') -replace '^-|-$', '')
if (-not $slug) {
    $slug = 'task'
}
if ($slug.Length -gt 40) {
    $slug = $slug.Substring(0, 40).TrimEnd('-')
}

$fileName = "{0}_{1}_{2}.md" -f $id, $timestamp, $slug
$taskFile = Join-Path $taskDir $fileName

$taskContent = @"
# 任务：$slug
状态：pending | 开始：$humanTime

## 目标
$description

## 进度日志

## 结果
"@

Set-Content -Path $taskFile -Value $taskContent -Encoding UTF8

$summary = $description
if ($summary.Length -gt 50) {
    $summary = $summary.Substring(0, 50)
}

$task = [pscustomobject]@{
    id         = $id
    slug       = $slug
    file       = "01_tasks/$fileName"
    status     = 'pending'
    created_at = $isoTime
    updated_at = $isoTime
    summary    = $summary
}

$data.tasks += $task
$data | ConvertTo-Json -Depth 5 | Set-Content -Path $registry -Encoding UTF8

Write-Host "任务 #$id 已登记"
Write-Host "描述：$description"
Write-Host "文件：.codex\tasks\01_tasks\$fileName"
