{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./hyprland.nix
    ./waybar.nix
    ./tofi.nix
    ./fnott.nix
    ./atuin.nix
    ./kitty.nix
    ./lf.nix
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

    # File preview tools for lf
    file          # File type detection
    mediainfo     # Media file info
    ffmpegthumbnailer  # Video thumbnails
    poppler_utils # PDF previews (pdftotext)
    epub2txt2     # EPUB preview
    fontpreview   # Font previews
    chafa         # Terminal image viewer
    exiftool      # Image metadata
    glow          # Markdown preview
    jq            # JSON preview
    atool         # Archive preview
    unzip         # ZIP listing
    odt2txt       # Office documents

    # Shell enhancements
    zoxide        # Smart directory jumping (z command)
    eza           # Modern ls replacement with icons
    bat           # Cat with syntax highlighting
    fd            # Fast find replacement
    duf           # Better df for disk usage
    atuin         # Better shell history
    tealdeer      # Simplified man pages (tldr)
    bottom        # Another resource monitor
    du-dust       # Better du
    procs         # Modern ps replacement

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
    tidal-hifi
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

        # Gruvbox Dark Hard colors
        colors = {
          primary = {
            background = "#000000";  # Pure black
            foreground = "#ebdbb2";  # Warm cream
          };
          normal = {
            black = "#000000";
            red = "#cc241d";
            green = "#98971a";
            yellow = "#d79921";
            blue = "#458588";
            magenta = "#b16286";
            cyan = "#689d6a";
            white = "#a89984";
          };
          bright = {
            black = "#928374";
            red = "#fb4934";
            green = "#b8bb26";
            yellow = "#fabd2f";
            blue = "#83a598";
            magenta = "#d3869b";
            cyan = "#8ec07c";
            white = "#ebdbb2";
          };
        };
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;

      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

        # Initialize zoxide for smart cd
        eval "$(zoxide init bash)"

        # Better fzf defaults
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --prompt="❯ "'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

        # Preview files with bat when using fzf
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      '';

      shellAliases = {
        # Nix aliases
        rebuild = "~/configFiles/rebuild.sh";
        update = "nix flake update ~/configFiles";

        # Maintenance commands
        sys-clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
        sys-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        sys-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
        sys-health = "sudo systemctl start system-health-check.service && journalctl -u system-health-check -n 20";
        sys-backup = "systemctl --user start backup-config.service";
        sys-dashboard = "~/configFiles/scripts/sys-dashboard.sh";

        # Quick status commands
        sys-failed = "systemctl --failed";
        sys-timers = "systemctl list-timers --all";
        sys-boot-time = "systemd-analyze boot";

        # Modern replacements
        ls = "eza --icons --group-directories-first";
        ll = "eza --icons --group-directories-first -la";
        lt = "eza --icons --group-directories-first --tree";
        cat = "bat --style=plain";
        find = "fd";
        ps = "procs";
        du = "dust";
        df = "duf";
        top = "btop";

        # Quick shortcuts
        c = "clear";
        e = "exit";
        g = "lazygit";
        f = "lf";
        keybinds = "~/configFiles/scripts/keybinds.sh";
        kb = "~/configFiles/scripts/keybinds.sh";

        # Git shortcuts
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline --graph";

        # Clipboard
        clip = "wl-copy";
        paste = "wl-paste";
      };
    };
    
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;  # Better Nix integration
    };

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  }
