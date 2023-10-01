{ config, pkgs,  ... }:

{ imports =
    [ 
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };


  # Configure keymap in X11
  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      gnome.gnome-keyring
      wget
      vim
      git
      networkmanagerapplet
      nodejs_20
    ];
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
        };
        autoLogin = {
          enable = false;
          user = "yeehaa";
        };
      };
      layout = "us";
      xkbVariant = "";
      xkbOptions = "ctrl:nocaps";
    };

    printing.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security = {
    rtkit.enable = true;
    pam.services.sddm.enableGnomeKeyring= true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yeehaa = {
    isNormalUser = true;
    description = "Jan Hein Hoogstad";
    extraGroups = [ "networkmanager" "wheel" ];
  };


  powerManagement.resumeCommands = ''
      ${pkgs.utillinux}/bin/rfkill unblock wlan
    '';

  system.stateVersion = "23.05"; # Did you read the comment?

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })];
  };
}
