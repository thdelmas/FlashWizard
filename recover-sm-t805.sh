#!/usr/bin/env bash
set -euo pipefail

FW_ZIP="$HOME/Downloads/SAMFW.COM_SM-T805_EUR_T805XXU1CVG2_fac.zip"
WORK_DIR="$HOME/Downloads/SM-T805-firmware"

echo "== SM-T805 stock firmware recovery script =="

if [[ ! -f "$FW_ZIP" ]]; then
  echo "ERROR: Firmware zip not found at: $FW_ZIP"
  echo "Make sure SAMFW.COM_SM-T805_EUR_T805XXU1CVG2_fac.zip is in your Downloads folder."
  exit 1
fi

if ! command -v heimdall >/dev/null 2>&1; then
  echo "ERROR: heimdall not found. Install with:"
  echo "  sudo apt update && sudo apt install heimdall-flash"
  exit 1
fi

echo "Using firmware zip: $FW_ZIP"
echo "Working directory:  $WORK_DIR"
mkdir -p "$WORK_DIR"

echo
echo "== Extracting main firmware zip =="
unzip -o "$FW_ZIP" -d "$WORK_DIR"

cd "$WORK_DIR"

echo
echo "== Extracting BL/AP/CP/CSC tar.md5 files =="
tar -xvf BL_*.tar.md5
tar -xvf AP_*.tar.md5
tar -xvf CP_*.tar.md5
tar -xvf CSC_*.tar.md5

echo
echo "Files in firmware directory:"
ls

for f in sboot.bin param.bin boot.img recovery.img system.img modem.bin cache.img hidden.img userdata.img; do
  if [[ ! -f "$f" ]]; then
    echo "WARNING: Expected file '$f' not found. If Heimdall fails, you may need to adjust the flash command."
  fi
done

echo
echo "== IMPORTANT =="
echo "1) Put the tablet into DOWNLOAD MODE now:"
echo "   Power + Home + Volume Down, then Volume Up to confirm"
echo "2) Connect it to this computer via USB"
echo
read -rp "When the tablet is in Download Mode and plugged in, press Enter to continue..."

echo
echo "== Checking Heimdall device detection (with sudo) =="
sudo heimdall detect

echo
echo "If you see 'Device detected', we will now flash the full stock firmware."
echo "DO NOT disconnect the USB cable during flashing."
echo
read -rp "Press Enter to start flashing with Heimdall (or Ctrl+C to abort)..."

echo
echo "== Flashing stock firmware to SM-T805 =="
sudo heimdall flash \
  --SBOOT sboot.bin \
  --PARAM param.bin \
  --BOOT boot.img \
  --RECOVERY recovery.img \
  --SYSTEM system.img \
  --MODEM modem.bin \
  --CACHE cache.img \
  --HIDDEN hidden.img \
  --USERDATA userdata.img

echo
echo "== Flash complete (if no errors were shown) =="
echo "If the tablet doesn't reboot automatically, hold Power + Home + Volume Down until it turns off,"
echo "then immediately press Power + Home + Volume Up to boot into STOCK RECOVERY."

echo
echo "In stock recovery, do:"
echo "  - Wipe data/factory reset"
echo "  - Wipe cache partition"
echo "  - Reboot system now"
echo
echo "If, after this, it still bootloops, the eMMC may be failing (hardware issue)."

