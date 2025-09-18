#!/usr/bin/env bash

# Hyprland Keybindings Cheat Sheet

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                 Hyprland Keybindings Cheat Sheet              ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo

echo -e "${YELLOW}▶ Window Management${NC}"
echo "  Super + Q                → Close window"
echo "  Super + V                → Toggle floating"
echo "  Super + F                → Toggle fullscreen"
echo "  Super + P                → Toggle pseudo-tiling"
echo "  Super + T                → Toggle split"
echo

echo -e "${YELLOW}▶ Focus Movement${NC}"
echo "  Super + H/←              → Focus left"
echo "  Super + L/→              → Focus right"
echo "  Super + K/↑              → Focus up"
echo "  Super + J/↓              → Focus down"
echo

echo -e "${YELLOW}▶ Window Movement${NC}"
echo "  Super + Shift + H/←      → Move window left"
echo "  Super + Shift + L/→      → Move window right"
echo "  Super + Shift + K/↑      → Move window up"
echo "  Super + Shift + J/↓      → Move window down"
echo

echo -e "${YELLOW}▶ Window Resizing${NC}"
echo "  Super + Ctrl + H/←       → Resize left (hold)"
echo "  Super + Ctrl + L/→       → Resize right (hold)"
echo "  Super + Ctrl + K/↑       → Resize up (hold)"
echo "  Super + Ctrl + J/↓       → Resize down (hold)"
echo "  Super + Right Click      → Resize with mouse"
echo

echo -e "${YELLOW}▶ Workspaces${NC}"
echo "  Super + 1-9              → Switch to workspace 1-9"
echo "  Super + 0                → Switch to workspace 10"
echo "  Super + Shift + 1-9      → Move window to workspace"
echo "  Super + Mouse Scroll     → Switch workspaces"
echo

echo -e "${YELLOW}▶ Applications${NC}"
echo "  Super + Return           → Terminal (kitty)"
echo "  Super + E                → File manager (lf)"
echo "  Super + Space            → App launcher"
echo "  Super + Shift + Space    → App launcher (fullscreen)"
echo "  Super + B                → Browser (Chrome)"
echo "  Super + O                → Obsidian"
echo "  Super + S                → System monitor (btop)"
echo "  Super + A                → Audio control (pulsemixer)"
echo "  Super + G                → Git interface (lazygit)"
echo "  Super + D                → Docker interface (lazydocker)"
echo "  Super + N                → Network manager (nmtui)"
echo "  Super + C                → Clipboard history"
echo "  Super + Shift + B        → Bluetooth manager"
echo

echo -e "${YELLOW}▶ System${NC}"
echo "  Super + Shift + E        → Exit Hyprland"
echo "  Super + /                → Show this cheat sheet"
echo

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Press any key to exit...${NC}"
read -n 1 -s