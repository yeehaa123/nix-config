{ config, pkgs,  ... }:

{ imports =
  [
    ./maintenance.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = { kernelPackages = pkgs.linuxPackages_latest;
  loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  extraModprobeConfig = ''
  options snd-hda-intel model=auto
  '';
  blacklistedKernelModules = [ "snd_pcsp" ];
};


networking = {
  hostName = "z13"; # Define your hostname.
  networkmanager.enable = true;
  nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networkmanager.dns = "none";
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

  # Enable Hyprland at system level for display manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal configuration for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  # Configure keymap in X11
  environment = {
    systemPackages = with pkgs; [
      # Core system tools only
      gnome-keyring
      vim
      git
      wget
      networkmanagerapplet
      pavucontrol
    ];
  };
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = ["8.8.8.8" "8.8.4.4"];
    };
  };


  # Don't suspend on lid close (for external monitor usage)
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  services = {
    expressvpn.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # X server (needed for XWayland support even on pure Wayland)
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";  # Caps Lock becomes Ctrl
      };
    };

    # ly - TUI display manager with a nice aesthetic
    displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        hide_borders = false;
        save_file = "/var/lib/ly/save";
      };
    };

    printing.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; #
    };
  };

  security = {
    rtkit.enable = true;
    pam.services.ly.enableGnomeKeyring = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yeehaa = {
    isNormalUser = true;
    description = "Jan Hein Hoogstad";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker"];
  };


  # nixpkgs configuration is handled in flake.nix

  system.stateVersion = "23.11"; # Did you read the comment?
}
