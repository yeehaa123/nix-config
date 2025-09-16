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

        # Match tofi's subtle terminal theme
        background = "1e1e2eff";
        border-color = "585b70ff";
        border-size = 1;
        padding-vertical = 6;
        padding-horizontal = 8;
        border-radius = 0;

        default-timeout = 5;

        # Monospace fonts like tofi
        title-font = "monospace:size=12";
        summary-font = "monospace:size=11";
        body-font = "monospace:size=11";

        # Text colors matching tofi
        title-color = "cdd6f4ff";
        summary-color = "cdd6f4ff";
        body-color = "cdd6f4ff";

        # Simple progress bar
        progress-bar-height = 2;
        progress-bar-color = "585b70ff";
      };

      low = {
        background = "1e1e2eff";
        border-color = "585b70ff";
        summary-color = "585b70ff";
      };

      normal = {
        background = "1e1e2eff";
        border-color = "585b70ff";
      };

      critical = {
        background = "1e1e2eff";
        border-color = "f38ba8ff";
        border-size = 2;
        title-color = "f38ba8ff";
      };
    };
  };
}