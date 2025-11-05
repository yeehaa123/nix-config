{ config, pkgs, lib, ... }:

{
  # Z13-specific overrides
  # This file only contains settings that differ from the main configuration

  home-manager.users.yeehaa = {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.mkForce [
        "eDP-1,highres,auto,1.25"    # Z13 display at 1.25x scaling
        ",highres,auto,1.333333"          # Secondary screen(s) at 1.333x
      ];

      # Override keybinding to use correct scaling for z13
      # Appending after default bindings allows this to override the default Super+Shift+M
      bind = lib.mkAfter [
        "$mainMod SHIFT, M, exec, hyprctl keyword monitor \"eDP-1,highres,auto,1.25\""  # Re-enable laptop screen with z13 scaling
      ];
    };
  };
}
