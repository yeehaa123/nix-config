{ config, pkgs, lib, ... }:

{
  # Zenbook-specific overrides
  networking.hostName = "zenbook";

  # No disk swap on this machine; compressed RAM swap keeps memory spikes
  # (e.g. parallel tsc builds) from freezing the system before OOM kicks in
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Zenbook stays awake on lid close (external monitor usage)
  services.logind = {
    lidSwitch = lib.mkForce "ignore";
    lidSwitchDocked = lib.mkForce "ignore";
    lidSwitchExternalPower = lib.mkForce "ignore";
  };

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
