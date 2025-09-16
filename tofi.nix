{ config, pkgs, ... }:

{
  # Default tofi configuration - Terminal-style appearance
  xdg.configFile."tofi/config".text = ''
    # Window - compact terminal-like box
    width = 500
    height = 300
    border-width = 1
    outline-width = 0
    padding-left = 8
    padding-top = 8
    padding-right = 8
    padding-bottom = 8
    result-spacing = 3
    num-results = 8
    corner-radius = 0

    # Position (centered)
    anchor = center

    # Font
    font = monospace
    font-size = 12

    # Colors - subtle terminal theme
    background-color = #1e1e2e
    text-color = #cdd6f4
    selection-color = #1e1e2e
    selection-background = #585b70
    prompt-color = #89b4fa
    border-color = #585b70

    # Prompt
    prompt-text = "> "

    # Behavior
    hide-cursor = false
    text-cursor = true
    history = true
    fuzzy-match = true
    require-match = true
    auto-accept-single = true
    hide-input = false

    # Performance
    drun-launch = true
    terminal = kitty
  '';

  # Fullscreen overlay configuration
  xdg.configFile."tofi/fullscreen.conf".text = ''
    # Window - fullscreen overlay
    width = 100%
    height = 100%
    border-width = 0
    outline-width = 0
    padding-left = 35%
    padding-top = 35%
    result-spacing = 25
    num-results = 5

    # Font
    font = JetBrainsMono Nerd Font
    font-size = 32

    # Colors (matching your Hyprland theme)
    background-color = #1e1e2ecc
    text-color = #cdd6f4
    selection-color = #33ccff
    prompt-color = #00ff99

    # Behavior
    hide-cursor = true
    text-cursor = true
    history = true
    fuzzy-match = true
    require-match = true
    auto-accept-single = true
    hide-input = false
    prompt-text = "  "

    # Performance
    drun-launch = true
    terminal = kitty
  '';
}