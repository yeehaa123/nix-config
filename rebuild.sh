#!/usr/bin/env bash

# NixOS rebuild script using flakes
# Uses --impure to allow access to /etc/nixos/hardware-configuration.nix
# Automatically uses the current hostname to select the flake configuration

set -e

HOSTNAME=$(hostname)

echo "Rebuilding NixOS configuration for $HOSTNAME..."

# Build and switch to the new configuration
# --impure allows access to /etc/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --impure --flake .#$HOSTNAME

echo "Rebuild complete!"