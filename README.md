# FlashWizard

Interactive, command-line helper for flashing and recovery workflows.

Currently focused on **Samsung devices via Heimdall** (Download Mode) and **custom ROM installs via `adb sideload`**.

## Scripts

- `flash-wizard.sh`: interactive wizard for:
  - restoring stock firmware from a Samsung firmware ZIP (BL/AP/CP/CSC `.tar.md5`)
  - flashing a custom recovery image (`.img`) via Heimdall
  - sideloading a ROM ZIP (TWRP / custom recovery)
  - sideloading GApps / other ZIPs
- `recover-sm-t805.sh`: one-shot recovery helper that was used to rescue an SM‑T805 (kept for reference)
- `bootloop-diagnose.sh`: local helper (if present) for bootloop diagnostics

## Requirements

Ubuntu/Debian packages:

```bash
sudo apt update
sudo apt install heimdall-flash adb unzip -y
```

## Usage

```bash
chmod +x flash-wizard.sh
./flash-wizard.sh
```

The wizard will stop and ask you to perform any **physical steps** (enter Download Mode, boot recovery, start ADB sideload) before it runs commands.

