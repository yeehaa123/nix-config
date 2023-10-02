{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.username = "yeehaa";
  home.homeDirectory = "/home/yeehaa";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
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

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland/hyprland.conf;
  };


  programs.waybar = { 
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./hyprland/waybar/config.json);
    style = builtins.readFile ./hyprland/waybar/style.css;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro"  "Iosevka" "Meslo"]; })
    pandoc
    zip
    wlogout
    ripgrep
    unzip
    jq 
    fzf
    which
    tree
    nix-output-monitor
    kitty
    google-chrome
    obsidian
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
      us = "source ~/configFiles/update.sh";
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
