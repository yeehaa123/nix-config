{ config, pkgs, lib, ... }:

{
  # Z13-specific overrides
  # This file only contains settings that differ from the main configuration

  home-manager.users.yeehaa = {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.mkForce [
        "eDP-1,highres,auto,1.333333"    # Z13 display at 1.333x scaling
        ",highres,auto,1.333333"          # Secondary screen(s) at 1.333x
      ];

      env = lib.mkForce [
        "XCURSOR_SIZE,48"  # Smaller cursor for 1.333x scaling
      ];
    };
  };
}
