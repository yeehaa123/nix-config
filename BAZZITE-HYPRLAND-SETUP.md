# Bazzite + Hyprland + Nix Setup Guide

Complete guide for running your Hyprland/NixOS configuration on top of Bazzite Linux.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Phase 1: Install Hyprland](#phase-1-install-hyprland)
4. [Phase 2: Install Nix](#phase-2-install-nix)
5. [Phase 3: Setup Home-Manager](#phase-3-setup-home-manager)
6. [Phase 4: Migrate Configuration](#phase-4-migrate-configuration)
7. [Package Management Strategy](#package-management-strategy)
8. [Session Management](#session-management)
9. [Configuration Adaptation](#configuration-adaptation)
10. [Testing Checklist](#testing-checklist)
11. [Troubleshooting](#troubleshooting)
12. [Maintenance](#maintenance)

---

## Overview

### Goals

- **Hyprland** for productivity workflow with tiling window management
- **KDE Plasma** for gaming with better HDR/VRR support
- **Nix + home-manager** for declarative package and dotfile management
- **Bazzite base** for gaming optimizations and hardware support

### Architecture Layers

```
┌─────────────────────────────────────────┐
│  User Packages & Dotfiles (Nix/HM)     │
├─────────────────────────────────────────┤
│  Window Managers (rpm-ostree layer)    │
│  - Hyprland (for work)                 │
│  - KDE Plasma (for gaming)             │
├─────────────────────────────────────────┤
│  Bazzite Base (Fedora Atomic)          │
│  - Gaming optimizations                │
│  - Hardware support                    │
│  - Atomic updates                      │
└─────────────────────────────────────────┘
```

### Benefits

- ✅ Full Hyprland experience with your existing config
- ✅ Bazzite's gaming stack and hardware support (ROG Flow Z13)
- ✅ Declarative configuration via Nix
- ✅ Atomic updates with rollback capability
- ✅ Switch between Hyprland and KDE at login
- ✅ Best of both NixOS and Fedora ecosystems

### Tradeoffs

- ⚠️ COPR repo could occasionally break updates
- ⚠️ More complex than single-distro setup
- ⚠️ Some NixOS-specific modules won't work
- ⚠️ Need to manage packages across multiple systems (rpm-ostree, Nix, Flatpak)

---

## Prerequisites

### Hardware Requirements

- **Tested on:** ASUS ROG Flow Z13 (2025)
- **Architecture:** x86_64
- **Storage:** 50GB+ free space recommended
- **RAM:** 8GB minimum, 16GB+ recommended

### Software Requirements

- Bazzite installed and updated
- Internet connection (for downloading packages)
- Basic terminal knowledge

### Before Starting

1. **Backup your current system:**
   ```bash
   # List current deployment (for rollback reference)
   rpm-ostree status

   # Backup home directory
   rsync -av --progress /home/$USER /path/to/backup/
   ```

2. **Update Bazzite:**
   ```bash
   rpm-ostree upgrade
   systemctl reboot
   ```

3. **Verify current desktop environment:**
   ```bash
   echo $XDG_CURRENT_DESKTOP
   ```

---

## Phase 1: Install Hyprland

### Step 1.1: Enable COPR Repository

```bash
# Enable solopasha's Hyprland COPR
sudo dnf5 copr enable solopasha/hyprland

# Refresh metadata
rpm-ostree refresh-md
```

### Step 1.2: Layer Hyprland Packages

```bash
# Install core Hyprland packages
rpm-ostree install \
  hyprland \
  xdg-desktop-portal-hyprland \
  hyprpaper \
  waybar \
  hyprpicker \
  hyprshot \
  wofi

# Optional: Additional Hyprland utilities
rpm-ostree install \
  hyprland-autoname-workspaces \
  hyprpanel
```

**Note:** This requires a reboot and will create a new deployment.

### Step 1.3: Reboot and Verify

```bash
systemctl reboot
```

After reboot:
- At SDDM login screen, click user
- Look for session selector (gear icon or dropdown)
- Verify "Hyprland" appears in session list
- **Don't log in to Hyprland yet** - we need to set up configs first

### Step 1.4: Verify Installation

```bash
# Check if Hyprland is installed
which hyprland

# Check Hyprland version
hyprland --version

# Verify session file exists
ls /usr/share/wayland-sessions/hyprland.desktop
```

---

## Phase 2: Install Nix

### Step 2.1: Install Nix with Determinate Installer

The Determinate Nix installer properly handles SELinux on Fedora Atomic systems.

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | sh -s -- install

# Source nix environment (or logout/login)
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Step 2.2: Configure Nix

```bash
# Enable experimental features
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf <<EOF
experimental-features = nix-command flakes
EOF
```

### Step 2.3: Add Nix Channels

```bash
# Add unstable channel
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs

# Add home-manager channel
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# Update channels
nix-channel --update
```

### Step 2.4: Verify Nix Installation

```bash
# Check Nix version
nix --version

# Test Nix installation
nix-shell -p hello --run hello

# Verify channels
nix-channel --list
```

---

## Phase 3: Setup Home-Manager

### Step 3.1: Install Home-Manager

```bash
# Install home-manager
nix-shell '<home-manager>' -A install
```

### Step 3.2: Initialize Home-Manager Configuration

```bash
# Create home-manager directory
mkdir -p ~/.config/home-manager

# Initialize with basic config (we'll replace this)
cat > ~/.config/home-manager/home.nix <<EOF
{ config, pkgs, ... }:

{
  home.username = "yeehaa";
  home.homeDirectory = "/home/yeehaa";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
EOF
```

### Step 3.3: Test Home-Manager

```bash
# Test home-manager switch
home-manager switch

# Verify it worked
home-manager --version
```

---

## Phase 4: Migrate Configuration

### Step 4.1: Clone Your Existing Config

```bash
# Clone your NixOS config as reference
git clone https://github.com/yeehaa123/nix-config.git ~/nixos-config-reference
```

### Step 4.2: Identify What to Migrate

**Files that work as-is:**
- `hyprland.nix` - Hyprland configuration
- `waybar.nix` - Waybar configuration
- `neovim.nix` - Neovim setup
- `kitty.nix` - Kitty terminal
- `tofi.nix` - Application launcher
- `lf.nix` - File manager
- `fnott.nix` - Notification daemon
- `atuin.nix` - Shell history

**Files that need modification:**
- `home.nix` - Remove NixOS-specific imports
- `flake.nix` - Convert to standalone home-manager flake

**Files to skip:**
- `configuration.nix` - NixOS system config (not applicable)
- `hardware-configuration.nix` - NixOS specific
- `maintenance.nix` - System-level NixOS config

### Step 4.3: Create Standalone Home-Manager Flake

```bash
# Create new flake for home-manager on Bazzite
mkdir -p ~/.config/home-manager
cd ~/.config/home-manager
```

Create `flake.nix`:

```nix
{
  description = "Home Manager configuration for Bazzite";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    plugin-gen = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    homeConfigurations."yeehaa" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = { inherit inputs; };

      modules = [
        ./home.nix
      ];
    };
  };
}
```

### Step 4.4: Create Adapted home.nix

Copy your existing `home.nix` but remove NixOS-specific options:

```bash
# Copy module files
cp ~/nixos-config-reference/neovim.nix ~/.config/home-manager/
cp ~/nixos-config-reference/kitty.nix ~/.config/home-manager/
cp ~/nixos-config-reference/hyprland.nix ~/.config/home-manager/
cp ~/nixos-config-reference/waybar.nix ~/.config/home-manager/
cp ~/nixos-config-reference/tofi.nix ~/.config/home-manager/
cp ~/nixos-config-reference/lf.nix ~/.config/home-manager/
cp ~/nixos-config-reference/fnott.nix ~/.config/home-manager/
cp ~/nixos-config-reference/atuin.nix ~/.config/home-manager/
```

Create new `home.nix`:

```nix
{ config, pkgs, inputs, ... }:

{
  home.username = "yeehaa";
  home.homeDirectory = "/home/yeehaa";
  home.stateVersion = "24.11";

  # Import your module configs
  imports = [
    ./neovim.nix
    ./kitty.nix
    ./hyprland.nix
    ./waybar.nix
    ./tofi.nix
    ./lf.nix
    ./fnott.nix
    ./atuin.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # User packages (from your original home.nix)
  home.packages = with pkgs; [
    # Add your packages here
    # Copy from your original home.nix home.packages section
  ];

  # Shell configuration
  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Git configuration (copy from your home.nix)
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your@email.com";
  };
}
```

### Step 4.5: Apply Configuration

```bash
cd ~/.config/home-manager

# Build and activate
home-manager switch --flake .#yeehaa
```

---

## Package Management Strategy

### Layer Decision Matrix

| Package Type | Tool | Example | Why |
|--------------|------|---------|-----|
| Window Manager | rpm-ostree | Hyprland | System-level compositor |
| System Libraries | rpm-ostree | Mesa, Vulkan | Required for gaming |
| CLI Tools | Nix | ripgrep, fzf | Declarative, version control |
| Dev Tools | Nix | nodejs, python | Isolated environments |
| GUI Apps | Flatpak | Discord, Firefox | Sandboxed, auto-updates |
| Desktop Utilities | Nix | neovim, kitty | Config integration |
| Dev Environments | Distrobox | Ubuntu, Arch | Full distro access |

### rpm-ostree (System Layer)

**Use for:**
- Hyprland and Wayland compositors
- System-critical libraries
- Hardware drivers
- Display managers

**Commands:**
```bash
# Install
rpm-ostree install <package>

# Remove
rpm-ostree uninstall <package>

# Status
rpm-ostree status

# Rollback
rpm-ostree rollback
```

### Nix/Home-Manager (User Layer)

**Use for:**
- CLI utilities (ripgrep, fd, bat, eza)
- Development tools (LSPs, formatters)
- Terminal applications (neovim, tmux)
- Shell utilities

**Commands:**
```bash
# Edit config
nvim ~/.config/home-manager/home.nix

# Apply changes
home-manager switch --flake ~/.config/home-manager#yeehaa

# Rollback
home-manager generations
home-manager switch --rollback
```

### Flatpak (GUI Applications)

**Use for:**
- Web browsers
- Chat applications
- Media players
- Office suites

**Commands:**
```bash
# Install
flatpak install flathub <app>

# Remove
flatpak uninstall <app>

# Update all
flatpak update
```

---

## Session Management

### Switching Between Hyprland and KDE

1. **At Login Screen (SDDM):**
   - Click your username
   - Look for session selector (usually gear/cog icon or dropdown)
   - Select "Hyprland" or "Plasma (Wayland)"
   - Enter password and log in

2. **Default Session:**
   ```bash
   # Set default to Hyprland
   echo "Hyprland" > ~/.dmrc
   ```

### When to Use Which

**Use Hyprland for:**
- Development work
- Writing/productivity
- Terminal-heavy workflows
- When you need tiling WM efficiency
- Daily computing tasks

**Use KDE Plasma for:**
- Gaming sessions
- When you need HDR
- VRR/high refresh rate gaming
- When games expect full DE
- Media consumption

### Performance Considerations

- Only one session runs at a time (no performance penalty)
- Both share the same home directory (configs are isolated)
- Can leave applications running and switch sessions (with caveats)

---

## Configuration Adaptation

### Hyprland Configuration

Your existing `hyprland.nix` should work mostly as-is, but verify:

1. **Monitor configuration:**
   ```nix
   # For ROG Flow Z13 (2560x1600 @165Hz)
   monitor = eDP-1,2560x1600@165,0x0,1
   ```

2. **Autostart applications:**
   ```nix
   # Ensure these are available via Nix
   exec-once = waybar
   exec-once = fnott
   ```

3. **Environment variables:**
   ```nix
   # Ensure Nix paths are included
   env = PATH,/home/yeehaa/.nix-profile/bin:$PATH
   ```

### Waybar Configuration

Should work as-is from `waybar.nix`. Verify:

1. Modules reference Nix-installed programs
2. CSS paths are correct
3. Custom scripts are executable

### Neovim Configuration

Your `neovim.nix` should work unchanged. The gen.nvim plugin is already set up in the flake.

### Shell Configuration

If using zsh/bash configurations:

```nix
# In home.nix
programs.zsh = {
  enable = true;
  initExtra = ''
    # Source Nix
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
  '';
};
```

---

## Testing Checklist

### Phase 1: Basic Functionality

- [ ] Hyprland launches successfully
- [ ] Can switch to KDE and back
- [ ] Keyboard input works
- [ ] Mouse/touchpad works
- [ ] Touchscreen works (if applicable)
- [ ] Display scaling is correct

### Phase 2: Hyprland Features

- [ ] All keybindings work
- [ ] Waybar displays correctly
- [ ] Notifications work (fnott)
- [ ] Application launcher works (tofi)
- [ ] Wallpaper sets correctly
- [ ] Window rules apply
- [ ] Workspaces function properly

### Phase 3: Applications

- [ ] Kitty terminal opens and works
- [ ] Neovim launches with all plugins
- [ ] File manager (lf) works
- [ ] Browser launches
- [ ] All CLI tools available

### Phase 4: Nix/Home-Manager

- [ ] `home-manager switch` succeeds
- [ ] Nix packages are in PATH
- [ ] Configuration changes apply
- [ ] Rollback works
- [ ] Nix store is accessible

### Phase 5: Gaming (KDE Session)

- [ ] Steam launches
- [ ] Games run properly
- [ ] HDR works (if supported)
- [ ] VRR/high refresh rate works
- [ ] Controller input works
- [ ] Game performance is good

---

## Troubleshooting

### Hyprland Won't Start

**Symptoms:** Black screen, returns to login

**Solutions:**
1. Check logs:
   ```bash
   journalctl --user -b -u hyprland
   ```

2. Try starting from TTY:
   ```bash
   # Switch to TTY (Ctrl+Alt+F3)
   Hyprland
   ```

3. Check Hyprland config:
   ```bash
   hyprland -c ~/.config/hypr/hyprland.conf --dry-run
   ```

4. Verify dependencies:
   ```bash
   rpm-ostree status | grep hyprland
   ```

### Nix Packages Not in PATH

**Symptoms:** Command not found for Nix-installed packages

**Solutions:**
1. Source Nix daemon:
   ```bash
   . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
   ```

2. Add to shell config:
   ```bash
   # In ~/.bashrc or ~/.zshrc
   export PATH="/home/yeehaa/.nix-profile/bin:$PATH"
   ```

3. Verify home-manager installed package:
   ```bash
   nix-env -q
   home-manager packages
   ```

### COPR Updates Breaking System

**Symptoms:** Boot fails after update, can't login

**Solutions:**
1. Rollback to previous deployment:
   ```bash
   # At boot, select previous deployment in grub
   # Or after boot:
   rpm-ostree rollback
   systemctl reboot
   ```

2. Remove COPR repo:
   ```bash
   sudo dnf5 copr disable solopasha/hyprland
   rpm-ostree uninstall hyprland
   ```

3. Pin working deployment:
   ```bash
   sudo ostree admin pin 0
   ```

### SELinux Denials

**Symptoms:** Permission denied errors, applications fail to start

**Solutions:**
1. Check SELinux mode:
   ```bash
   getenforce
   ```

2. Check for denials:
   ```bash
   sudo ausearch -m AVC -ts recent
   ```

3. Temporarily set permissive (for testing only):
   ```bash
   sudo setenforce 0
   ```

4. Proper fix: Create SELinux policy or report issue

### Home-Manager Build Failures

**Symptoms:** `home-manager switch` fails with evaluation errors

**Solutions:**
1. Check for syntax errors:
   ```bash
   nix flake check ~/.config/home-manager
   ```

2. Update channels:
   ```bash
   nix-channel --update
   ```

3. Clear caches:
   ```bash
   nix-collect-garbage -d
   ```

4. Rebuild flake lock:
   ```bash
   cd ~/.config/home-manager
   nix flake update
   ```

### Waybar Not Showing

**Symptoms:** Waybar doesn't appear in Hyprland

**Solutions:**
1. Check if running:
   ```bash
   pgrep waybar
   ```

2. Start manually to see errors:
   ```bash
   waybar
   ```

3. Verify config:
   ```bash
   waybar --log-level debug
   ```

4. Check Hyprland exec-once:
   ```bash
   grep waybar ~/.config/hypr/hyprland.conf
   ```

---

## Maintenance

### Updating System

```bash
# Update Bazzite base + layered packages
rpm-ostree upgrade

# Update Nix packages
home-manager switch --flake ~/.config/home-manager#yeehaa

# Update Flatpaks
flatpak update

# Reboot after rpm-ostree updates
systemctl reboot
```

### Cleaning Up

```bash
# Clean old deployments (keep last 2)
rpm-ostree cleanup -b

# Clean old Nix generations
nix-collect-garbage -d
home-manager expire-generations "-30 days"

# Clean Flatpak
flatpak uninstall --unused
```

### Backup Strategy

```bash
# Backup home-manager config
cd ~/.config/home-manager
git init
git add .
git commit -m "Current config"
git remote add origin <your-repo>
git push

# Note current deployment
rpm-ostree status > ~/system-state-$(date +%F).txt

# List installed Flatpaks
flatpak list > ~/flatpaks-$(date +%F).txt
```

### When Updates Break Things

1. **Identify the problem layer:**
   - System broken? → Rollback rpm-ostree
   - Apps broken? → Rollback home-manager
   - Flatpak issue? → Downgrade specific flatpak

2. **Rollback procedure:**
   ```bash
   # System
   rpm-ostree rollback && reboot

   # Home-manager
   home-manager generations
   home-manager switch --rollback

   # Flatpak
   flatpak update --commit=<old-commit> <app>
   ```

3. **Report issues:**
   - COPR issues → GitHub issues for solopasha/hyprland
   - Bazzite issues → ublue-os/bazzite
   - Nix issues → nix-community/home-manager

---

## Advanced: Custom Bazzite Image

If you want a more integrated approach, you can create a custom Bazzite image with Hyprland baked in.

### Option: Fork and Build Custom Image

1. Fork https://github.com/ublue-os/bazzite
2. Modify recipe to include Hyprland
3. Build with GitHub Actions
4. Rebase to your custom image

This is more complex but eliminates the COPR layer and provides a fully integrated image.

See: https://blue-build.org/ for building custom Fedora Atomic images.

---

## Summary

You now have:

- ✅ Bazzite's gaming-optimized base
- ✅ Hyprland for productivity with your full config
- ✅ KDE Plasma for gaming
- ✅ Nix + home-manager for declarative package management
- ✅ Atomic updates with easy rollback
- ✅ Best of both worlds: NixOS-style configs + Fedora-style gaming

**Quick reference commands:**

```bash
# Switch home-manager config
home-manager switch --flake ~/.config/home-manager#yeehaa

# Update system
rpm-ostree upgrade && reboot

# Rollback system
rpm-ostree rollback && reboot

# Rollback home-manager
home-manager switch --rollback

# Clean old generations
rpm-ostree cleanup -b
nix-collect-garbage -d
```

**Session switching:** At SDDM login, select Hyprland or Plasma from the session menu.

Enjoy your hybrid system! 🚀
