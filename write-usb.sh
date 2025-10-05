#!/usr/bin/env bash

echo "This will write the NixOS installer to /dev/sda"
echo "WARNING: This will ERASE all data on /dev/sda!"
echo
read -p "Are you sure? (type 'yes' to continue): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Cancelled."
    exit 1
fi

echo
echo "Writing ISO to USB drive..."
sudo dd if=result/iso/nixos-minimal-25.05.20250522.55d1f92-x86_64-linux.iso of=/dev/sda bs=4M status=progress oflag=sync

echo
echo "Done! Your USB installer is ready."
echo "You can now boot from this USB on any machine."