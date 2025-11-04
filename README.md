# NixOS Configuration

Personal NixOS/Hyprland configuration with Gruvbox Dark Hard theme.

## 🚀 Installation

**→ [INSTALL.md](INSTALL.md) - Complete Installation Guide**

This guide covers:
- Downloading official NixOS ISO
- Creating bootable USB
- Running automated installation script
- Deploying this complete configuration

Quick install on official NixOS ISO:
```bash
curl -L https://raw.githubusercontent.com/yeehaa123/nix-config/main/install.sh | sudo bash
```

---

## 📦 What's Included

- **Window Manager:** Hyprland (tiling Wayland compositor)
- **Display Manager:** greetd + tuigreet (lightweight Wayland-native)
- **Status Bar:** Waybar
- **Terminal:** Kitty
- **Editor:** Neovim (with LSP, plugins, gen.nvim)
- **Launcher:** Tofi
- **Notifications:** Fnott
- **File Manager:** lf
- **Shell History:** Atuin
- **Music:** Tidal HiFi
- **Theme:** Gruvbox Dark Hard (consistent across all apps)

## 🎨 Features

- Declarative configuration via Nix flakes
- Home-manager for user environment
- Consistent theming across terminal, editor, and UI
- Optimized for development workflow
- Latest kernel for hardware support
- Automated system maintenance tasks

## 📝 Configuration Structure

```
.
├── INSTALL.md                  # Installation guide
├── install.sh                  # Automated NixOS installer
├── flake.nix                   # Main flake configuration
├── configuration.nix           # NixOS system config
├── home.nix                    # Home-manager config
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

**Note:** `hardware-configuration.nix` is machine-specific and NOT stored in git. Each system generates its own in `/etc/nixos/` via `nixos-generate-config`.

## 🔧 Quick Commands

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#nixos

# Update everything
nix flake update
sudo nixos-rebuild switch --flake .#nixos

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Clean old generations
sudo nix-collect-garbage -d
```

## 🛠️ Key Bindings

Run the interactive keybindings reference:
```bash
keybinds
# or
kb
```

## 🎯 Development Tools

Included in this configuration:
- **Languages:** Node.js, Rust, OCaml, Go
- **LSPs:** typescript-language-server, svelte-language-server, rust-analyzer
- **Formatters:** prettier, stylua, rustfmt
- **Build Tools:** pnpm, cargo, dune, make, gcc
- **Databases:** Turso CLI, sqld
- **DevOps:** Terraform, Docker, lazydocker
- **Version Control:** Git, lazygit, gh (GitHub CLI)

## 🎵 Multimedia

- **Music:** Tidal HiFi (high-fidelity streaming), cmus (terminal player)
- **Audio:** PipeWire with ALSA and PulseAudio support

## 📂 File Management

- **TUI:** lf (fast file manager with preview support)
- **Preview Tools:** bat, chafa, glow, mediainfo, exiftool
- **Archive Support:** atool, unzip

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use it as inspiration for your own setup
- Open issues if you find bugs
- Suggest improvements via PRs

## 📄 License

Personal configuration - use at your own risk and adapt to your needs.

---

**Last Updated:** 2025-01-06
