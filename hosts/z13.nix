{ config, pkgs, lib, ... }:

{
  # Z13-specific overrides
  networking.hostName = "z13";

  # Reduce USB descriptor timeout to avoid ~60s boot delay from phantom USB 3-3 port
  boot.kernelParams = [ "usbcore.initial_descriptor_timeout=200" ];

  services.udev.extraRules = ''
    # Disable phantom USB port 3-3 to prevent future enumeration attempts
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_port", KERNELS=="usb3", ATTR{port_number}=="2", \
      ATTR{disable}="1"

    # Rebind keyboard cover touchpad from hid_asus to hid-multitouch for proper scrolling
    ACTION=="add", SUBSYSTEM=="hid", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1a30", \
      DRIVERS=="asus", \
      RUN+="${pkgs.bash}/bin/bash -c 'echo $kernel > /sys/bus/hid/drivers/asus/unbind 2>/dev/null; echo $kernel > /sys/bus/hid/drivers/hid-multitouch/bind 2>/dev/null'"
  '';

  home-manager.users.yeehaa = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,highres,auto,1.25"    # Z13 display at 1.25x scaling
        ",highres,auto,1.333333"     # Secondary screen(s) at 1.333x
      ];

      # Z13-specific keybinding with correct scaling
      bind = [
        "$mainMod SHIFT, M, exec, hyprctl keyword monitor \"eDP-1,highres,auto,1.25\""  # Re-enable laptop screen with z13 scaling
      ];
    };
  };
}
