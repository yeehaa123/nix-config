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

    # Colors - Gruvbox Dark Hard
    background-color = #000000
    text-color = #ebdbb2
    selection-color = #000000
    selection-background = #fabd2f
    prompt-color = #b8bb26
    border-color = #3c3836

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

    # Colors - Gruvbox Dark Hard (fullscreen)
    background-color = #000000dd
    text-color = #ebdbb2
    selection-color = #fabd2f
    prompt-color = #b8bb26

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