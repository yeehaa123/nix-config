#!/usr/bin/env bash

# NixOS Installation Script
# Run this on the official NixOS installer ISO
# Downloads and installs the configuration from GitHub

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/yeehaa123/nix-config.git"
CONFIG_DIR="/mnt/etc/nixos"

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}    NixOS Installation Script                  ${NC}"
echo -e "${GREEN}================================================${NC}"
echo
echo "This script will:"
echo "  1. Partition and format your disk"
echo "  2. Clone your NixOS configuration from GitHub"
echo "  3. Install NixOS with your configuration"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root (or use sudo)${NC}"
    exit 1
fi

# Function to list disks
list_disks() {
    echo -e "${YELLOW}Available disks:${NC}"
    lsblk -d -o NAME,SIZE,TYPE,MODEL | grep disk || true
    echo
}

# Select installation disk
list_disks
read -p "Enter the disk to install to (e.g., sda, nvme0n1): " DISK
DISK_PATH="/dev/${DISK}"

if [ ! -b "${DISK_PATH}" ]; then
    echo -e "${RED}Error: ${DISK_PATH} does not exist!${NC}"
    exit 1
fi

echo
echo -e "${RED}WARNING: This will ERASE ALL DATA on ${DISK_PATH}${NC}"
read -p "Are you sure you want to continue? (type 'yes'): " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
    echo "Installation cancelled."
    exit 0
fi

echo
echo -e "${BLUE}Step 1/6: Partitioning disk...${NC}"

# Clear existing partition table
wipefs -a "${DISK_PATH}"
sync
sleep 1

# Create GPT partition table
parted "${DISK_PATH}" -- mklabel gpt
sync

# Create boot partition (512MB)
parted "${DISK_PATH}" -- mkpart ESP fat32 1MiB 512MiB
parted "${DISK_PATH}" -- set 1 esp on
sync

# Create root partition (rest of disk)
parted "${DISK_PATH}" -- mkpart primary 512MiB 100%
sync

# Wait for kernel to recognize new partitions
echo "Waiting for partitions to be recognized..."
sleep 3
partprobe "${DISK_PATH}" 2>/dev/null || true
sleep 2

# Determine partition naming scheme
if [[ "${DISK}" == nvme* ]] || [[ "${DISK}" == mmcblk* ]]; then
    BOOT_PART="${DISK_PATH}p1"
    ROOT_PART="${DISK_PATH}p2"
else
    BOOT_PART="${DISK_PATH}1"
    ROOT_PART="${DISK_PATH}2"
fi

echo -e "${BLUE}Step 2/6: Formatting partitions...${NC}"

# Format boot partition
mkfs.fat -F 32 -n boot "${BOOT_PART}"

# Format root partition
mkfs.ext4 -L nixos "${ROOT_PART}"

echo -e "${BLUE}Step 3/6: Mounting filesystems...${NC}"

# Mount root
mount "${ROOT_PART}" /mnt

# Create and mount boot
mkdir -p /mnt/boot
mount "${BOOT_PART}" /mnt/boot

echo -e "${BLUE}Step 4/6: Cloning configuration from GitHub...${NC}"

# Clone configuration
mkdir -p "${CONFIG_DIR}"
git clone "${REPO_URL}" "${CONFIG_DIR}"

echo -e "${BLUE}Step 5/6: Generating hardware configuration...${NC}"

# Generate hardware configuration for the target system
nixos-generate-config --root /mnt

# The hardware-configuration.nix will be generated in /mnt/etc/nixos
# Our cloned config will use this

echo -e "${BLUE}Step 6/6: Installing NixOS...${NC}"
echo "This may take 20-30 minutes depending on internet speed..."
echo

# Install NixOS
cd "${CONFIG_DIR}"
nixos-install --flake .#nixos

echo
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}    Installation Complete!                     ${NC}"
echo -e "${GREEN}================================================${NC}"
echo
echo "Next steps:"
echo "  1. Set a root password if needed: nixos-enter --root /mnt -c 'passwd root'"
echo "  2. Set user password: nixos-enter --root /mnt -c 'passwd yeehaa'"
echo "  3. Reboot: reboot"
echo
echo "Remove the USB drive before rebooting."
