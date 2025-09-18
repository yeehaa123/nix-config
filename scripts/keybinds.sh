#!/usr/bin/env bash

# Keybindings Reference TUI
# A comprehensive guide to all configured keybindings

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

# Function to display a category
show_category() {
    local category="$1"
    clear
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    Keybindings Reference                      ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo

    case "$category" in
        1) # Hyprland
            echo -e "${GREEN}▶ Hyprland Window Manager${NC}"
            echo
            echo -e "${YELLOW}Window Management:${NC}"
            echo "  Super + Q         → Close window"
            echo "  Super + V         → Toggle floating"
            echo "  Super + F         → Toggle fullscreen"
            echo "  Super + P         → Toggle pseudo-tiling"
            echo "  Super + T         → Toggle split"
            echo
            echo -e "${YELLOW}Focus Movement:${NC}"
            echo "  Super + H/←       → Focus left"
            echo "  Super + L/→       → Focus right"
            echo "  Super + K/↑       → Focus up"
            echo "  Super + J/↓       → Focus down"
            echo
            echo -e "${YELLOW}Window Movement:${NC}"
            echo "  Super + Shift + H/← → Move window left"
            echo "  Super + Shift + L/→ → Move window right"
            echo "  Super + Shift + K/↑ → Move window up"
            echo "  Super + Shift + J/↓ → Move window down"
            echo
            echo -e "${YELLOW}Window Resizing:${NC}"
            echo "  Super + Ctrl + H/← → Resize left (hold)"
            echo "  Super + Ctrl + L/→ → Resize right (hold)"
            echo "  Super + Ctrl + K/↑ → Resize up (hold)"
            echo "  Super + Ctrl + J/↓ → Resize down (hold)"
            echo "  Super + Right Click → Resize with mouse"
            echo
            echo -e "${YELLOW}Workspaces:${NC}"
            echo "  Super + 1-9       → Switch to workspace 1-9"
            echo "  Super + 0         → Switch to workspace 10"
            echo "  Super + Shift + 1-9 → Move window to workspace"
            echo "  Super + Mouse Scroll → Switch workspaces"
            echo
            echo -e "${YELLOW}Applications:${NC}"
            echo "  Super + Return    → Kitty terminal"
            echo "  Super + E         → LF file manager"
            echo "  Super + Space     → Tofi launcher (terminal style)"
            echo "  Super + Shift + Space → Tofi launcher (fullscreen)"
            echo "  Super + B         → Chrome browser"
            echo "  Super + O         → Obsidian"
            echo "  Super + S         → System monitor (btop)"
            echo "  Super + A         → Audio control (pulsemixer)"
            echo "  Super + G         → LazyGit"
            echo "  Super + D         → LazyDocker"
            echo "  Super + N         → Network manager (nmtui)"
            echo "  Super + C         → Clipboard history"
            echo "  Super + Shift + B → Bluetooth manager"
            echo "  Super + /         → This keybindings reference"
            echo
            echo -e "${YELLOW}System:${NC}"
            echo "  Super + Shift + E → Exit Hyprland"
            echo "  Super + L (hold)  → Lock screen"
            ;;

        2) # LF File Manager
            echo -e "${GREEN}▶ LF File Manager${NC}"
            echo
            echo -e "${YELLOW}Navigation:${NC}"
            echo "  h               → Go to parent directory"
            echo "  j               → Move down"
            echo "  k               → Move up"
            echo "  l               → Open file/directory"
            echo "  gg              → Go to top"
            echo "  G               → Go to bottom"
            echo "  gh              → Go to home"
            echo "  gc              → Go to ~/configFiles"
            echo "  gd              → Go to ~/Downloads"
            echo "  gD              → Go to ~/Documents"
            echo "  gr              → Go to root (/)"
            echo
            echo -e "${YELLOW}Page Movement:${NC}"
            echo "  Ctrl+u          → Half page up"
            echo "  Ctrl+d          → Half page down"
            echo "  Ctrl+b          → Page up"
            echo "  Ctrl+f          → Page down"
            echo
            echo -e "${YELLOW}File Operations:${NC}"
            echo "  dd              → Cut"
            echo "  yy              → Copy"
            echo "  pp              → Paste"
            echo "  dD              → Trash (safe delete)"
            echo "  dX              → Delete permanently"
            echo "  u               → Clear cut/copy selection"
            echo "  o               → Create new file"
            echo "  O               → Create new directory"
            echo
            echo -e "${YELLOW}Archive Operations:${NC}"
            echo "  xe              → Extract archive"
            echo "  xz              → Create zip archive"
            echo
            echo -e "${YELLOW}Search:${NC}"
            echo "  /               → Search forward"
            echo "  ?               → Search backward"
            echo "  n               → Next search result"
            echo "  N               → Previous search result"
            echo "  f               → Jump with zoxide"
            echo
            echo -e "${YELLOW}View:${NC}"
            echo "  i               → Show file info"
            echo "  zp              → Toggle preview"
            echo "  zh              → Toggle hidden files"
            echo
            echo -e "${YELLOW}Shell:${NC}"
            echo "  W               → Open shell"
            echo "  !               → Shell command"
            echo "  !!              → Shell command (wait)"
            echo
            echo -e "${YELLOW}Clipboard:${NC}"
            echo "  Y               → Copy full path"
            echo "  yn              → Copy filename"
            echo "  yd              → Copy directory path"
            echo
            echo -e "${YELLOW}Rename:${NC}"
            echo "  A               → Rename at end"
            echo "  I               → Rename at beginning"
            echo "  cw/cc           → Replace filename"
            echo
            echo -e "${YELLOW}Selection:${NC}"
            echo "  Space/v         → Toggle selection"
            echo "  V               → Invert selection"
            echo "  Esc             → Clear selection"
            echo
            echo -e "${YELLOW}Marks:${NC}"
            echo "  m               → Save mark"
            echo "  '               → Load mark"
            echo "  \"               → Remove mark"
            ;;

        3) # Terminal (Kitty + Bash)
            echo -e "${GREEN}▶ Terminal (Kitty + Bash)${NC}"
            echo
            echo -e "${YELLOW}Kitty Terminal:${NC}"
            echo "  Ctrl+Shift+C    → Copy"
            echo "  Ctrl+Shift+V    → Paste"
            echo "  Ctrl+Shift+F    → Search scrollback"
            echo "  Ctrl+Shift+U    → Unicode input"
            echo "  Ctrl+Shift+E    → Edit config"
            echo "  Ctrl+Shift+R    → Reload config"
            echo "  Ctrl+Shift++/-/0 → Zoom in/out/reset"
            echo
            echo -e "${YELLOW}Bash Aliases:${NC}"
            echo "  rebuild         → Rebuild NixOS configuration"
            echo "  update          → Update flake inputs"
            echo "  sys-clean       → Clean garbage & optimize"
            echo "  sys-dashboard   → System maintenance dashboard"
            echo "  sys-failed      → Show failed services"
            echo "  sys-timers      → Show all timers"
            echo
            echo -e "${YELLOW}Modern CLI Tools:${NC}"
            echo "  ls/ll/lt        → eza (better ls with icons)"
            echo "  cat             → bat (syntax highlighting)"
            echo "  find            → fd (faster find)"
            echo "  ps              → procs (better ps)"
            echo "  du              → dust (better du)"
            echo "  df              → duf (better df)"
            echo "  top             → btop (better top)"
            echo "  cd              → z/zi (smart jump with zoxide)"
            echo
            echo -e "${YELLOW}Quick Shortcuts:${NC}"
            echo "  c               → Clear screen"
            echo "  e               → Exit"
            echo "  g               → LazyGit"
            echo "  f               → LF file manager"
            echo
            echo -e "${YELLOW}Git Shortcuts:${NC}"
            echo "  gs              → git status"
            echo "  ga              → git add"
            echo "  gc              → git commit"
            echo "  gp              → git push"
            echo "  gl              → git log --oneline --graph"
            echo
            echo -e "${YELLOW}History (Atuin):${NC}"
            echo "  ↑               → Previous command"
            echo "  ↓               → Next command"
            echo "  Ctrl+R          → Search history"
            ;;

        4) # Waybar
            echo -e "${GREEN}▶ Waybar Status Bar${NC}"
            echo
            echo -e "${YELLOW}Interactive Elements:${NC}"
            echo "  Click CPU       → Open btop"
            echo "  Click Memory    → Open btop"
            echo "  Click Network   → Open network manager"
            echo "  Click Volume    → Open pulsemixer"
            echo "  Click Clock     → View calendar"
            echo
            echo -e "${YELLOW}Information Displayed:${NC}"
            echo "  • Current workspace indicator"
            echo "  • Active window title"
            echo "  • CPU usage percentage"
            echo "  • Memory usage percentage"
            echo "  • Network status"
            echo "  • Volume level"
            echo "  • Battery status (if applicable)"
            echo "  • Date and time"
            echo "  • Tray icons"
            ;;

        5) # Vim Motions
            echo -e "${GREEN}▶ Vim Motions (Global)${NC}"
            echo
            echo -e "${YELLOW}Movement:${NC}"
            echo "  h/j/k/l         → Left/Down/Up/Right"
            echo "  w/W             → Next word/WORD"
            echo "  b/B             → Previous word/WORD"
            echo "  e/E             → End of word/WORD"
            echo "  0               → Beginning of line"
            echo "  ^               → First non-blank character"
            echo "  $               → End of line"
            echo "  gg              → Beginning of file"
            echo "  G               → End of file"
            echo "  {/}             → Previous/next paragraph"
            echo
            echo -e "${YELLOW}Editing:${NC}"
            echo "  i/I             → Insert/Insert at beginning"
            echo "  a/A             → Append/Append at end"
            echo "  o/O             → New line below/above"
            echo "  x               → Delete character"
            echo "  dd              → Delete line"
            echo "  yy              → Yank (copy) line"
            echo "  pp              → Paste"
            echo "  u               → Undo"
            echo "  Ctrl+r          → Redo"
            echo
            echo -e "${YELLOW}Visual Mode:${NC}"
            echo "  v               → Character-wise visual"
            echo "  V               → Line-wise visual"
            echo "  Ctrl+v          → Block-wise visual"
            echo
            echo -e "${CYAN}Note: Vim motions work in Neovim and LF${NC}"
            ;;

        6) # System Shortcuts
            echo -e "${GREEN}▶ System Shortcuts${NC}"
            echo
            echo -e "${YELLOW}Audio Control:${NC}"
            echo "  XF86AudioRaiseVolume → Volume up"
            echo "  XF86AudioLowerVolume → Volume down"
            echo "  XF86AudioMute        → Toggle mute"
            echo
            echo -e "${YELLOW}Screen Brightness:${NC}"
            echo "  XF86MonBrightnessUp   → Brightness up"
            echo "  XF86MonBrightnessDown → Brightness down"
            echo
            echo -e "${YELLOW}Quick Commands:${NC}"
            echo "  sys-dashboard   → System maintenance menu"
            echo "  sys-clean       → Garbage collection"
            echo "  sys-health      → Health check"
            echo "  sys-backup      → Backup configuration"
            echo "  rebuild         → Rebuild NixOS"
            echo "  update          → Update flake"
            ;;
    esac
}

# Main menu
while true; do
    clear
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    Keybindings Reference                      ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${GREEN}Select a category:${NC}"
    echo
    echo "  [1] Hyprland Window Manager"
    echo "  [2] LF File Manager"
    echo "  [3] Terminal (Kitty + Bash)"
    echo "  [4] Waybar Status Bar"
    echo "  [5] Vim Motions"
    echo "  [6] System Shortcuts"
    echo "  [q] Quit"
    echo
    echo -e "${CYAN}Tip: This reference is available via 'keybinds' command${NC}"
    echo
    read -p "Select option: " choice

    case "$choice" in
        [1-6])
            show_category "$choice"
            echo
            echo -e "${YELLOW}Press Enter to return to menu...${NC}"
            read
            ;;
        q|Q)
            exit 0
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done