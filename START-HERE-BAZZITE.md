# 🚀 Setting Up This Config on Bazzite

## For: ROG Flow Z13 (2025) or any Bazzite system

**You want to run Hyprland + your Nix config on top of Bazzite.**

### 📖 Full Guide

→ **[BAZZITE-HYPRLAND-SETUP.md](BAZZITE-HYPRLAND-SETUP.md)**

This comprehensive guide will walk you through:

1. ✅ Installing Hyprland on Bazzite
2. ✅ Setting up Nix + home-manager
3. ✅ Migrating this NixOS config to work on Bazzite
4. ✅ Switching between Hyprland (work) and KDE (gaming)

### ⚡ Quick Start

```bash
# 1. Clone this repo on your Bazzite system
git clone https://github.com/yeehaa123/nix-config.git
cd nix-config

# 2. Open the full guide
cat BAZZITE-HYPRLAND-SETUP.md
# Or open in browser: https://github.com/yeehaa123/nix-config/blob/main/BAZZITE-HYPRLAND-SETUP.md

# 3. Follow Phase 1: Install Hyprland
sudo dnf5 copr enable solopasha/hyprland
rpm-ostree install hyprland xdg-desktop-portal-hyprland waybar
# ... see full guide for complete steps

# 4. Then continue with Phases 2-4 in the guide
```

### 🎯 What You'll End Up With

- **Bazzite base** - Gaming optimizations, Steam, great hardware support
- **Hyprland session** - Your tiling WM with all configs for work
- **KDE Plasma session** - Better for gaming (HDR, VRR, etc.)
- **Nix packages** - All your CLI tools, neovim, etc. managed declaratively
- **Switch at login** - Choose Hyprland or KDE from SDDM

### ⏱️ Time Estimate

- Phase 1 (Hyprland): 15-20 minutes + reboot
- Phase 2 (Nix): 10-15 minutes
- Phase 3 (Home-manager): 10 minutes
- Phase 4 (Config migration): 30-60 minutes

**Total: ~2 hours** (including testing)

### 📚 Other Installation Options

Not using Bazzite? See [README.md](README.md) for:
- **Pure NixOS installation** - Traditional NixOS setup
- **Manual installation** - Custom setup options

---

**Ready?** Open [BAZZITE-HYPRLAND-SETUP.md](BAZZITE-HYPRLAND-SETUP.md) and let's go! 🚀
