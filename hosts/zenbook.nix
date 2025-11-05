{ config, pkgs, lib, ... }:

{
  # Zenbook-specific overrides
  # This file only contains settings that differ from the main configuration

  home-manager.users.yeehaa = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,highres,auto,1.5"    # Zenbook display at 1.5x scaling
        ",highres,auto,1.333333"    # Secondary screen(s) at 1.333x
      ];

      # Zenbook-specific keybinding with correct scaling
      bind = [
        "$mainMod SHIFT, M, exec, hyprctl keyword monitor \"eDP-1,highres,auto,1.5\""  # Re-enable laptop screen with zenbook scaling
      ];
    };
  };
}
