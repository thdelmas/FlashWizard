#!/bin/bash
# Samsung tablet boot loop diagnostic script
# Run this when the tablet is connected via USB with USB debugging enabled.

set -e
ADB="${ADB:-adb}"

echo "=== Boot loop diagnostic ==="
echo ""

# 1. Check device connection
echo "1. Checking connected devices..."
"$ADB" devices -l
if ! "$ADB" devices | grep -q 'device$'; then
  echo ""
  echo "No device in 'device' state. Possible causes:"
  echo "  - Tablet not connected via USB"
  echo "  - USB cable is charge-only (try a data cable)"
  echo "  - USB debugging not enabled (enable in Developer options)"
  echo "  - Device not authorized (accept prompt on tablet if it appears briefly)"
  echo "  - During boot loop, device may appear only for a few seconds"
  exit 1
fi

# 2. Device state
echo ""
echo "2. Device state..."
"$ADB" get-state 2>/dev/null || true

# 3. Capture logcat (this will show why it's crashing/rebooting)
echo ""
echo "3. Capturing logcat (last 500 lines + live for 30s)..."
echo "   Look for 'FATAL', 'AndroidRuntime', 'crash', 'reboot', 'watchdog'"
"$ADB" logcat -d -t 500 2>/dev/null | tail -200
echo ""
echo "--- Live logcat for 30 seconds (capture crash/reboot) ---"
timeout 30 "$ADB" logcat -v time 2>/dev/null || true

echo ""
echo "Done. Save this output and look for repeated errors or 'FATAL' lines."
