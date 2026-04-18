#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_file() {
    local path="$1"
    if [ ! -f "$ROOT/$path" ]; then
        echo "Missing file: $path"
        exit 1
    fi
}

assert_contains() {
    local path="$1"
    local needle="$2"
    if ! grep -Fq "$needle" "$ROOT/$path"; then
        echo "Expected $path to contain: $needle"
        exit 1
    fi
}

assert_file "setup.cmd"
assert_file "start-codex.cmd"
assert_file "install.ps1"
assert_file "GUIDE.md"
assert_file "bin/start-codex.ps1"
assert_file "bin/dispatch-task.ps1"
assert_file "bin/task-status.ps1"
assert_file "bin/session-review.ps1"
assert_file "bin/start-codex.cmd"
assert_file "bin/dispatch-task.cmd"
assert_file "bin/task-status.cmd"
assert_file "bin/session-review.cmd"

assert_contains "install.ps1" "'Git.Git'"
assert_contains "install.ps1" "'Python.Python.3'"
assert_contains "install.ps1" "'OpenJS.NodeJS.LTS'"
assert_contains "install.ps1" "'@openai/codex'"
assert_contains "GUIDE.md" "setup.cmd"
assert_contains "GUIDE.md" "start-codex.cmd"

echo "windows-bundle-check.sh: PASS"
