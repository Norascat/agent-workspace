#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
    local haystack="$1"
    local needle="$2"
    if [[ "$haystack" != *"$needle"* ]]; then
        echo "Expected output to contain: $needle"
        exit 1
    fi
}

OUTPUT="$(
    cd "$ROOT"
    CODEXCAT_DRY_RUN=1 CODEXCAT_FAKE_BREW=1 CODEXCAT_FAKE_MISSING="python3,codex" bash install.sh 2>&1
)"

assert_contains "$OUTPUT" "Auto-installing python3 via Homebrew"
assert_contains "$OUTPUT" "brew install python"
assert_contains "$OUTPUT" "Auto-installing Codex CLI via npm"
assert_contains "$OUTPUT" "npm install -g @openai/codex"

echo "install-script-test.sh: PASS"
