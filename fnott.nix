{ config, pkgs, ... }:

{
  # Fnott configuration - matching tofi terminal style
  services.fnott = {
    enable = true;
    settings = {
      main = {
        anchor = "center";
        max-width = 350;
        min-width = 0;

        notification-margin = 3;

        # Gruvbox Dark Hard theme
        background = "000000ff";  # Pure black
        border-color = "3c3836ff";  # Dark gray
        border-size = 1;
        padding-vertical = 6;
        padding-horizontal = 8;
        border-radius = 0;

        default-timeout = 5;

        # Monospace fonts
        title-font = "monospace:size=12";
        summary-font = "monospace:size=11";
        body-font = "monospace:size=11";

        # Gruvbox text colors
        title-color = "fabd2fff";  # Yellow for titles
        summary-color = "ebdbb2ff";  # Cream for summary
        body-color = "ebdbb2ff";  # Cream for body

        # Simple progress bar
        progress-bar-height = 2;
        progress-bar-color = "b8bb26ff";  # Green
      };

      low = {
        background = "000000ff";
        border-color = "3c3836ff";
        summary-color = "928374ff";  # Gray for low priority
      };

      normal = {
        background = "000000ff";
        border-color = "3c3836ff";
      };

      critical = {
        background = "000000ff";
        border-color = "fb4934ff";  # Red border
        border-size = 2;
        title-color = "fb4934ff";  # Red title
      };
    };
  };
}