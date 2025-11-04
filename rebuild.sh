#!/usr/bin/env bash

# NixOS rebuild script using flakes
# Uses --impure to allow access to /etc/nixos/hardware-configuration.nix

set -e

echo "Rebuilding NixOS configuration..."

# Build and switch to the new configuration
# --impure allows access to /etc/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --impure --flake .#nixos

echo "Rebuild complete!"