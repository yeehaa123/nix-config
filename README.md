# NixOS Configuration

Personal NixOS/Hyprland configuration with Gruvbox Dark Hard theme.

## 🚀 Installation Guides

Choose the guide that matches your target system:

### 📱 Installing on Bazzite (ROG Flow Z13 / Gaming Devices)

**→ [BAZZITE-HYPRLAND-SETUP.md](BAZZITE-HYPRLAND-SETUP.md) ← START HERE**

Use this for:
- ASUS ROG Flow Z13 (2025)
- Any gaming handheld/laptop where you want Bazzite's gaming stack
- Systems where you want Hyprland + KDE dual-boot
- When you need better hardware support for newest devices

This guide sets up:
- Bazzite as base OS (gaming optimizations)
- Hyprland for productivity (via rpm-ostree)
- KDE Plasma for gaming (switch at login)
- Nix + home-manager for packages/dotfiles

### 💻 Installing on Pure NixOS

**→ [INSTALL.md](INSTALL.md)**

Use this for:
- Desktop PCs
- Servers
- Laptops with good NixOS hardware support
- When you want pure NixOS experience

This guide:
- Boots from official NixOS ISO
- Runs automated install script
- Deploys this full configuration

---

## 📦 What's Included

- **Window Manager:** Hyprland (tiling Wayland compositor)
- **Status Bar:** Waybar
- **Terminal:** Kitty
- **Editor:** Neovim (with LSP, plugins, gen.nvim)
- **Launcher:** Tofi
- **Notifications:** Fnott
- **File Manager:** lf
- **Shell History:** Atuin
- **Theme:** Gruvbox Dark Hard (consistent across all apps)

## 🎨 Features

- Declarative configuration via Nix flakes
- Home-manager for user environment
- Consistent theming across terminal, editor, and UI
- Optimized for development workflow
- Gaming-ready (on Bazzite setup)

## 📝 Configuration Structure

```
.
├── BAZZITE-HYPRLAND-SETUP.md  # Guide for Bazzite + Hyprland + Nix
├── INSTALL.md                  # Guide for pure NixOS
├── install.sh                  # Automated NixOS installer
├── flake.nix                   # Main flake configuration
├── configuration.nix           # NixOS system config
├── home.nix                    # Home-manager config
├── hardware-configuration.nix  # Hardware-specific settings
├── hyprland.nix               # Hyprland window manager
├── waybar.nix                 # Status bar
├── neovim.nix                 # Neovim configuration
├── kitty.nix                  # Terminal emulator
├── tofi.nix                   # Application launcher
├── lf.nix                     # File manager
├── fnott.nix                  # Notifications
├── atuin.nix                  # Shell history
└── maintenance.nix            # System maintenance tasks
```

## 🔧 Quick Commands

### On Bazzite (after setup):
```bash
# Update home-manager config
home-manager switch --flake ~/.config/home-manager#yeehaa

# Update system
rpm-ostree upgrade && reboot

# Rollback if something breaks
rpm-ostree rollback && reboot
```

### On NixOS:
```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#nixos

# Update everything
nix flake update
sudo nixos-rebuild switch --flake .#nixos

# Rollback
sudo nixos-rebuild switch --rollback
```

## 🎯 Repository Purpose

This repository serves two purposes:

1. **Personal Configuration:** My daily-driver setup that I maintain and evolve
2. **Installation Automation:** Easy deployment to new machines using either:
   - Pure NixOS (for traditional installations)
   - Bazzite + Nix hybrid (for gaming-focused devices)

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use it as inspiration for your own setup
- Open issues if you find bugs
- Suggest improvements via PRs

## 📄 License

Personal configuration - use at your own risk and adapt to your needs.

---

**Last Updated:** 2025-01-06

**Primary Machines:**
- Desktop: Pure NixOS
- ROG Flow Z13 (2025): Bazzite + Hyprland + Nix
