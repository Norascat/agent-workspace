$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$registry = Join-Path $root '.codex\tasks\01_tasks.json'

if (-not (Test-Path $registry)) {
    Write-Host 'No task registry found at .codex\tasks\01_tasks.json'
    exit 0
}

$data = Get-Content $registry -Raw | ConvertFrom-Json
$tasks = @($data.tasks)

if ($tasks.Count -eq 0) {
    Write-Host 'No tasks recorded.'
    exit 0
}

if ($args.Count -gt 0) {
    $target = $args[0]
    $task = $tasks | Where-Object { $_.id -eq $target } | Select-Object -First 1
    if (-not $task) {
        Write-Host "Task $target not found."
        exit 1
    }

    $task.PSObject.Properties | ForEach-Object {
        Write-Host ('{0}: {1}' -f $_.Name, $_.Value)
    }
    exit 0
}

Write-Host 'ID  STATUS   UPDATED_AT            SUMMARY'
foreach ($task in $tasks) {
    '{0,-2}  {1,-8}  {2,-19}  {3}' -f $task.id, $task.status, $task.updated_at.Substring(0, [Math]::Min(19, $task.updated_at.Length)), $task.summary | Write-Host
}
