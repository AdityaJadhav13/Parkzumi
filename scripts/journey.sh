#!/usr/bin/env bash
# Runs the end-to-end rider journey on a simulator/emulator and saves a
# screenshot at each step to build/shots/. Usage: scripts/journey.sh <device-id>
set -euo pipefail
DEVICE="${1:?usage: scripts/journey.sh <device-id>  (see: flutter devices)}"
ADB="${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb"
mkdir -p build/shots
LOG=build/journey.log
: > "$LOG"

capture() {
  if [[ "$DEVICE" == emulator-* ]]; then "$ADB" -s "$DEVICE" exec-out screencap -p > "build/shots/$1.png"
  else xcrun simctl io "$DEVICE" screenshot "build/shots/$1.png" > /dev/null; fi
}

tail -n0 -F "$LOG" 2>/dev/null | grep --line-buffered -o 'PZSHOT [A-Za-z0-9_]*' | while read -r _ name; do capture "$name"; done &
trap 'pkill -P $$ 2>/dev/null || true' EXIT


flutter drive --driver=test_driver/integration_test.dart --target=integration_test/journey_test.dart -d "$DEVICE" > "$LOG" 2>&1 || true
grep -E "All tests passed|Some tests failed|Timed out waiting" "$LOG" | head -5
ls build/shots
