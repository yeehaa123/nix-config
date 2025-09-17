{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      # UI settings - minimal and integrated
      style = "compact";
      inline_height = 8;  # Smaller, more integrated view
      show_preview = true;
      show_help = false;
      preview_max_length = 50;  # Compact preview

      # Borders and spacing
      border = true;
      border_style = "single";  # Simple line borders

      # Search behavior
      search_mode = "fuzzy";
      filter_mode = "host";  # Only show commands from this machine
      filter_mode_shell_up_key_binding = "session";  # Up arrow = current session only

      # Immediate search
      immediate = true;  # Start searching immediately

      # Use built-in theme instead of custom colors
      # This avoids any theme configuration issues

      # History settings
      history_filter = [
        "^ls$"
        "^cd$"
        "^pwd$"
        "^clear$"
        "^exit$"
        "^c$"
        "^l$"
        "^ll$"
      ];

      # Better defaults
      exit_mode = "return-original";
      enter_accept = true;  # Enter runs the command

      # Stats and timing
      show_total_duration = false;  # Cleaner without duration
      dialect = "us";  # Date format

      # Sync disabled
      auto_sync = false;
      update_check = false;
    };
  };
}