#!/usr/bin/env bash

set -e

echo "Building custom NixOS installer ISO..."
echo

# Build the ISO
nix build .#nixosConfigurations.installer.config.system.build.isoImage

# Find the built ISO
if [ -L "result" ]; then
    # result is a symlink, check what it points to
    RESULT_TARGET=$(readlink -f result)
    if [ -f "$RESULT_TARGET" ]; then
        # Direct symlink to ISO file
        ISO_PATH="result"
    elif [ -d "$RESULT_TARGET" ]; then
        # Symlink to directory containing ISO
        ISO_PATH=$(find -L result -name "*.iso" -type f | head -n1)
    fi
elif [ -d "result" ]; then
    # result is a directory
    ISO_PATH=$(find -L result -name "*.iso" -type f | head -n1)
fi

if [ -z "$ISO_PATH" ] || [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO file not found"
    exit 1
fi

echo "ISO built successfully!"
echo "ISO location: $ISO_PATH"
echo "Actual file: $(readlink -f $ISO_PATH)"
echo "Size: $(du -h $ISO_PATH | cut -f1)"
echo
echo "To write it to a USB drive:"
echo "1. Insert your USB drive"
echo "2. Find the device name with: lsblk"
echo "3. Write the ISO with:"
echo "   sudo dd if=$ISO_PATH of=/dev/sdX bs=4M status=progress oflag=sync"
echo
echo "Replace /dev/sdX with your actual USB device (e.g., /dev/sdb)"
echo "WARNING: This will erase all data on the USB drive!"