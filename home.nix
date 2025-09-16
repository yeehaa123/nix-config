{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./hyprland.nix
    ./waybar.nix
    ./tofi.nix
    ./fnott.nix
  ];

  home.username = "yeehaa";
  home.homeDirectory = "/home/yeehaa";

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  xresources.properties = {
    "Xcursor.size" = 24;
  };

  programs.git = {
    enable = true;
    userName = "Jan Hein Hoogstad";
    userEmail = "yeehaa@offcourse.io";
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
  };

    fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Development tools
    direnv
    nodejs_20
    nodePackages.node-gyp
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages.pnpm
    ocaml
    opam
    dune_2
    pkg-config
    turso-cli
    sqld
    gnumake
    gcc
    hugo
    gmp
    rustc
    cargo
    prettierd
    stylua
    stylelint
    terraform
    rust-analyzer
    tree-sitter
    rustPackages.clippy
    patchelf

    # Wayland tools
    tofi
    swaylock
    grim
    slurp
    wl-clipboard
    cliphist      # Clipboard history manager
    hyprpaper
    brightnessctl
    wlogout
    kdePackages.polkit-kde-agent-1
    pulsemixer
    fnott
    libnotify  # For notify-send command

    # TUI applications
    lf            # Fast file manager
    htop          # Process viewer
    btop          # Beautiful resource monitor
    ncdu          # Disk usage analyzer
    bandwhich     # Network utilization
    bluetuith     # Bluetooth TUI
    cmus          # Music player
    gopass        # Password manager
    gopass-jsonapi
    lazygit       # Git TUI
    lazydocker    # Docker TUI

    # Fonts
    nerd-fonts.meslo-lg

    # User applications
    pkgs.fontconfig
    pandoc
    gh
    zip
    ripgrep
    unzip
    jq
    fzf
    which
    tree
    nix-output-monitor
    nil
    bun
    kitty
    openssl
    xclip
    brave
    thunderbird
    google-chrome
    android-file-transfer
    obsidian
    expressvpn
    stdenv.cc.cc.lib
  ];

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          normal.family = "MesloLGSNerdFont";
          italic.family = "MesloLGSNerdFont";
          bold.family = "MesloLGSNerdFont";
          size = 14;
          draw_bold_text_with_bright_colors = true;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;

      bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';

      shellAliases = {
        rebuild = "~/configFiles/rebuild.sh";
        update = "nix flake update ~/configFiles";
      };
    };
    
    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  }
