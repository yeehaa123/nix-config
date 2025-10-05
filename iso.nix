{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    # Enables copy to RAM for faster operation
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  # Use latest kernel for newer hardware support (ROG Flow Z13 2025)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Add kernel parameters to fix USB timeout issues
  boot.kernelParams = [
    "usbcore.autosuspend=-1"  # Disable USB autosuspend
    "usb-storage.quirks=ALL"  # Apply USB storage quirks
    "ibt=off"                 # Disable Intel Branch Tracking for compatibility
  ];

  # ISO naming
  isoImage.isoName = "nixos-yeehaa-installer.iso";
  isoImage.volumeID = "NIXOS_YEEHAA";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # Enable all firmware for newer hardware
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Enable SSH for remote installation (optional)
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Set a root password for the installer (change this!)
  users.users.root = {
    initialPassword = "nixos";
    initialHashedPassword = lib.mkForce null;
  };

  # Enable flakes in the installer environment
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Include git for cloning configs
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    parted
    gptfdisk
  ];

  # Copy your configuration to the ISO
  environment.etc = {
    "install-config/flake.nix".source = ./flake.nix;
    "install-config/configuration.nix".source = ./configuration.nix;
    "install-config/home.nix".source = ./home.nix;
    "install-config/hardware-configuration.nix".source = ./hardware-configuration.nix;
    "install-config/maintenance.nix".source = ./maintenance.nix;
    "install-config/lf.nix".source = ./lf.nix;
    "install-config/fnott.nix".source = ./fnott.nix;
    "install-config/tofi.nix".source = ./tofi.nix;
    "install-config/hyprland.nix".source = ./hyprland.nix;
    "install-config/neovim.nix".source = ./neovim.nix;
    "install-config/waybar.nix".source = ./waybar.nix;
    "install-config/kitty.nix".source = ./kitty.nix;
    "install-config/atuin.nix".source = ./atuin.nix;
  };

  # Auto-login as root
  services.getty.autologinUser = lib.mkForce "root";

  # Add the installation script
  environment.etc."install-script.sh" = {
    mode = "0755";
    text = ''
      #!/usr/bin/env bash

      # Enable error handling but show where errors occur
      set -euo pipefail
      trap 'echo "Error on line $LINENO. Press Enter to see details..."; read' ERR

      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      NC='\033[0m'

      clear
      echo -e "''${GREEN}================================================''${NC}"
      echo -e "''${GREEN}    NixOS Automated Installation Script        ''${NC}"
      echo -e "''${GREEN}================================================''${NC}"
      echo
      echo "Checking system requirements..."
      sleep 1

      # Function to list disks
      list_disks() {
        echo -e "''${YELLOW}Available disks:''${NC}"
        lsblk -d -o NAME,SIZE,TYPE,MODEL | grep disk || true
      }

      # Select installation disk
      list_disks
      echo
      read -p "Enter the disk to install to (e.g., sda, nvme0n1): " DISK
      DISK_PATH="/dev/''${DISK}"

      if [ ! -b "''${DISK_PATH}" ]; then
        echo -e "''${RED}Error: ''${DISK_PATH} does not exist!''${NC}"
        exit 1
      fi

      echo
      echo -e "''${RED}WARNING: This will ERASE ALL DATA on ''${DISK_PATH}''${NC}"
      read -p "Are you sure you want to continue? (yes/no): " CONFIRM

      if [ "''${CONFIRM}" != "yes" ]; then
        echo "Installation cancelled."
        exit 0
      fi

      echo
      echo -e "''${GREEN}Step 1: Partitioning disk...''${NC}"

      # Clear existing partition table
      wipefs -a "''${DISK_PATH}"
      sync
      sleep 1

      # Create GPT partition table
      parted "''${DISK_PATH}" -- mklabel gpt
      sync
      sleep 1

      # Create boot partition (512MB)
      parted "''${DISK_PATH}" -- mkpart ESP fat32 1MiB 512MiB
      parted "''${DISK_PATH}" -- set 1 esp on
      sync
      sleep 1

      # Create root partition (rest of disk)
      parted "''${DISK_PATH}" -- mkpart primary 512MiB 100%
      sync

      # Wait for kernel to recognize new partitions
      echo "Waiting for partitions to be recognized..."
      sleep 3
      partprobe "''${DISK_PATH}" || true
      sleep 2

      # Determine partition naming scheme
      if [[ "''${DISK}" == nvme* ]] || [[ "''${DISK}" == mmcblk* ]]; then
        BOOT_PART="''${DISK_PATH}p1"
        ROOT_PART="''${DISK_PATH}p2"
      else
        BOOT_PART="''${DISK_PATH}1"
        ROOT_PART="''${DISK_PATH}2"
      fi

      echo -e "''${GREEN}Step 2: Formatting partitions...''${NC}"

      # Format boot partition
      mkfs.fat -F 32 -n boot "''${BOOT_PART}"

      # Format root partition
      mkfs.ext4 -L nixos "''${ROOT_PART}"

      echo -e "''${GREEN}Step 3: Mounting filesystems...''${NC}"

      # Mount root
      mount "''${ROOT_PART}" /mnt

      # Create and mount boot
      mkdir -p /mnt/boot
      mount "''${BOOT_PART}" /mnt/boot

      echo -e "''${GREEN}Step 4: Copying configuration...''${NC}"

      # Copy configuration files
      mkdir -p /mnt/etc/nixos
      cp -r /etc/install-config/* /mnt/etc/nixos/

      echo -e "''${GREEN}Step 5: Generating hardware configuration...''${NC}"

      # Generate hardware configuration for the target system
      nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

      echo -e "''${GREEN}Step 6: Installing NixOS...''${NC}"

      # Install NixOS
      cd /mnt/etc/nixos
      nixos-install --flake .#nixos --no-root-password

      echo
      echo -e "''${GREEN}================================================''${NC}"
      echo -e "''${GREEN}    Installation Complete!                     ''${NC}"
      echo -e "''${GREEN}================================================''${NC}"
      echo
      echo "You can now remove the USB drive and reboot."
      echo "Run: reboot"
    '';
  };

  # Display installation message on boot
  services.displayManager.autoLogin.enable = true;

  # Add a welcome message
  programs.bash.interactiveShellInit = ''
    if [ "$USER" = "root" ]; then
      echo
      echo "==============================================="
      echo "  Welcome to NixOS Automated Installer"
      echo "==============================================="
      echo
      echo "This will install your custom NixOS configuration."
      echo
      echo "Run the following command to start:"
      echo "  /etc/install-script.sh"
      echo
      echo "For manual installation, your config is in:"
      echo "  /etc/install-config/"
      echo
    fi
  '';
}