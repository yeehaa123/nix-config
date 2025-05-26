#!/usr/bin/env bash

# NixOS rebuild script using flakes
# No need to copy files to /etc/nixos anymore!

set -e

echo "Rebuilding NixOS configuration..."

# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#nixos

echo "Rebuild complete!"