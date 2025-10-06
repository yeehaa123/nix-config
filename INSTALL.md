# NixOS Installation Guide

Simple installation guide for deploying this NixOS configuration on new machines.

## Quick Start

### 1. Download Official NixOS ISO

For new hardware (like ROG Flow Z13 2025), use the **unstable** ISO:
```bash
# Download from: https://nixos.org/download#nixos-iso
# Choose: Minimal ISO image (64-bit Intel/AMD)
# For newest hardware, select "unstable" channel
```

For stable hardware, use the **stable** ISO (25.05 or latest).

### 2. Create Bootable USB

**On Linux:**
```bash
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

**On macOS:**
```bash
sudo dd if=nixos-minimal-*.iso of=/dev/diskX bs=4m
```

**On Windows:**
Use [Rufus](https://rufus.ie/) or [balenaEtcher](https://etcher.balena.io/)

### 3. Boot from USB

1. Insert USB drive into target machine
2. Boot from USB (usually F12, F2, or DEL to access boot menu)
3. Select "NixOS Installer"

### 4. Run Installation

Once booted into the NixOS installer:

```bash
# Download and run the install script
curl -L https://raw.githubusercontent.com/yeehaa123/nix-config/main/install.sh | sudo bash
```

Or manually:
```bash
# Clone this repo
sudo su
curl -L https://raw.githubusercontent.com/yeehaa123/nix-config/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

The script will:
- Ask which disk to install to
- Partition and format the disk (GPT + EFI boot + ext4 root)
- Clone this configuration from GitHub
- Generate hardware configuration
- Install NixOS with your complete setup

### 5. Post-Installation

After installation completes:

```bash
# Set passwords (optional if you want to login as root first)
nixos-enter --root /mnt -c 'passwd root'
nixos-enter --root /mnt -c 'passwd yeehaa'

# Reboot
reboot
```

Remove the USB drive and boot into your new NixOS system!

## Manual Installation

If you prefer more control:

1. **Partition disk:**
   ```bash
   parted /dev/sdX -- mklabel gpt
   parted /dev/sdX -- mkpart ESP fat32 1MiB 512MiB
   parted /dev/sdX -- set 1 esp on
   parted /dev/sdX -- mkpart primary 512MiB 100%
   ```

2. **Format partitions:**
   ```bash
   mkfs.fat -F 32 -n boot /dev/sdX1
   mkfs.ext4 -L nixos /dev/sdX2
   ```

3. **Mount filesystems:**
   ```bash
   mount /dev/sdX2 /mnt
   mkdir -p /mnt/boot
   mount /dev/sdX1 /mnt/boot
   ```

4. **Clone config:**
   ```bash
   git clone https://github.com/yeehaa123/nix-config.git /mnt/etc/nixos
   ```

5. **Generate hardware config:**
   ```bash
   nixos-generate-config --root /mnt
   ```

6. **Install:**
   ```bash
   cd /mnt/etc/nixos
   nixos-install --flake .#nixos
   ```

## Troubleshooting

### USB Boot Issues
If you see USB timeout errors (common on new hardware):
- Use the **unstable** ISO which has the latest kernel
- Try different USB ports (prefer USB 2.0 if available)

### Network Issues
The installer needs internet to download packages:
```bash
# Check connection
ping nixos.org

# For WiFi
sudo systemctl start wpa_supplicant
sudo wpa_cli
> add_network
> set_network 0 ssid "YourNetworkName"
> set_network 0 psk "YourPassword"
> enable_network 0
> quit
```

### Disk Names
- SATA/SSD: `/dev/sda`, `/dev/sdb`
- NVMe: `/dev/nvme0n1`, `/dev/nvme1n1`
- eMMC: `/dev/mmcblk0`

## Configuration Details

- **Hostname:** nixos (change in `configuration.nix`)
- **User:** yeehaa (change in `flake.nix` and `home.nix`)
- **Desktop:** Hyprland + Waybar
- **Boot:** systemd-boot (UEFI)
- **Partitioning:** GPT with EFI boot partition

## Notes

- The install script uses the latest config from GitHub (always current)
- Hardware configuration is auto-generated for each machine
- All your dotfiles and programs will be installed automatically
- First boot may take a few minutes to build home-manager
