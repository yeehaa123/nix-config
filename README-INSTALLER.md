# NixOS Auto-Installer USB

Custom NixOS installer that automatically deploys this configuration to new machines.

## Quick Start

### Build ISO
```bash
./build-installer.sh
```

### Write to USB
```bash
# Find your USB device
lsblk

# Write ISO (replace sdX with your device)
sudo dd if=result/iso/nixos-yeehaa-installer.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Install on Target Machine
1. Boot from USB
2. Run: `/etc/install-script.sh`
3. Select target disk
4. Confirm (will erase all data!)
5. Reboot when complete

## Features
- Automatic disk partitioning (EFI + root)
- Hardware detection for target machine
- Full configuration deployment (Hyprland, Waybar, etc.)
- No manual configuration needed

## Files
- `iso.nix` - ISO configuration
- `build-installer.sh` - Build script
- `flake.nix` - Updated with installer target

## Requirements
- UEFI boot support
- x86_64 architecture
- 8GB+ USB drive

## Hardware Support
- Uses **latest Linux kernel** for new hardware (e.g., ROG Flow Z13 2025)
- Includes USB timeout fixes and all firmware
- Auto-detects NVMe, SATA, and eMMC drives
- Improved error handling with line-by-line debugging

## Default Credentials
- Installer root password: `nixos`
- System user: `yeehaa` (configure in `configuration.nix`)