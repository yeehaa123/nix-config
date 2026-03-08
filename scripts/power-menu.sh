#!/usr/bin/env bash

choice=$(printf "Lock\nSleep\nReboot\nShutdown\nExit Hyprland" | tofi --prompt-text "Power: ")

case "$choice" in
  Lock)
    swaylock ;;
  Sleep)
    # Re-enable laptop screen in case it was disabled (docked mode)
    case "$(hostname)" in
      z13)     hyprctl keyword monitor "eDP-1,highres,auto,1.25" 2>/dev/null ;;
      zenbook) hyprctl keyword monitor "eDP-1,highres,auto,1.5" 2>/dev/null ;;
    esac
    systemctl suspend ;;
  Reboot)
    systemctl reboot ;;
  Shutdown)
    systemctl poweroff ;;
  "Exit Hyprland")
    hyprctl dispatch exit ;;
esac
