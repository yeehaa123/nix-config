{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      # Better scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
      scrollback_pager_history_size = 10;  # MB

      # URL handling
      url_style = "curly";
      open_url_with = "default";
      detect_urls = true;

      # Terminal bell
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # Window
      window_padding_width = 8;
      hide_window_decorations = false;
      confirm_os_window_close = 0;

      # Colors - Gruvbox Dark Hard with pitch black background
      background = "#000000";  # Pure black
      foreground = "#ebdbb2";  # Warm cream

      # Cursor
      cursor = "#ebdbb2";
      cursor_text_color = "#000000";

      # Selection
      selection_background = "#3c3836";
      selection_foreground = "#ebdbb2";

      # Black/bright black
      color0 = "#000000";
      color8 = "#928374";

      # Red/bright red
      color1 = "#cc241d";
      color9 = "#fb4934";

      # Green/bright green
      color2 = "#98971a";
      color10 = "#b8bb26";

      # Yellow/bright yellow
      color3 = "#d79921";
      color11 = "#fabd2f";

      # Blue/bright blue
      color4 = "#458588";
      color12 = "#83a598";

      # Magenta/bright magenta
      color5 = "#b16286";
      color13 = "#d3869b";

      # Cyan/bright cyan
      color6 = "#689d6a";
      color14 = "#8ec07c";

      # White/bright white
      color7 = "#a89984";
      color15 = "#ebdbb2";

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
    };

    keybindings = {
      # Scrollback search (like vim's /)
      "kitty_mod+/" = "launch --type=overlay --stdin-source=@screen_scrollback fzf --no-sort --no-mouse --exact -i";

      # Quick scrollback pager
      "kitty_mod+h" = "show_scrollback";

      # Font size
      "kitty_mod+equal" = "change_font_size all +1.0";
      "kitty_mod+minus" = "change_font_size all -1.0";
      "kitty_mod+0" = "change_font_size all 0";

      # Copy/paste
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";

      # Window management
      "kitty_mod+n" = "new_os_window";
      "kitty_mod+w" = "close_window";
      "kitty_mod+enter" = "new_window";

      # Tab management
      "kitty_mod+t" = "new_tab";
      "kitty_mod+q" = "close_tab";
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";

      # Clear screen and scrollback
      "kitty_mod+k" = "clear_terminal scrollback active";
    };

    extraConfig = ''
      # Kitty modifier key (default is ctrl+shift)
      kitty_mod ctrl+shift

      # On Wayland, let window manager handle Super key
      linux_display_server wayland

      # Advanced scrollback search using fzf
      map kitty_mod+f launch --type=overlay sh -c 'cat /tmp/kitty_scrollback_* | fzf --no-sort --no-mouse --exact -i'

      # Quick command output search
      map kitty_mod+g launch --type=overlay sh -c 'kitty @ get-text --extent all | grep -n "" | fzf'
    '';
  };

  # Create .envrc files easily
  home.packages = with pkgs; [
    nix-direnv
  ];

  # Global direnv config
  home.file.".config/direnv/direnvrc".text = ''
    # Faster nix-direnv
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc

    # Layout functions
    layout_poetry() {
      if [[ ! -f pyproject.toml ]]; then
        log_error 'No pyproject.toml found. Use `poetry init` to create one first.'
        exit 2
      fi

      local VENV=$(poetry env list --full-path | head -1 | cut -d' ' -f1)
      if [[ -z $VENV || ! -d $VENV/bin ]]; then
        log_error 'No poetry virtual environment found. Use `poetry install` to create one first.'
        exit 2
      fi

      export VIRTUAL_ENV=$VENV
      export POETRY_ACTIVE=1
      PATH_add "$VENV/bin"
    }

    # Automatic venv activation
    layout_python() {
      if [[ -d .venv ]]; then
        source .venv/bin/activate
      elif [[ -f requirements.txt ]]; then
        python -m venv .venv
        source .venv/bin/activate
        pip install -r requirements.txt
      fi
    }
  '';
}