{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      monitor = ",highres,auto,1.5";

      env = "XCURSOR_SIZE,72";

      exec-once = [
        "hyprpaper"
        "waybar"
        "wl-paste --type text --watch cliphist store"  # Store text clipboard
        "wl-paste --type image --watch cliphist store"  # Store image clipboard
        "${pkgs.kdePackages.polkit-kde-agent-1}/bin/polkit-kde-authentication-agent-1"
        "nm-applet --indicator"
        "[workspace 1 silent] kitty"
        "[workspace 2 silent] google-chrome-stable"
        "[workspace 3 silent] obsidian"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_rules = "";
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0;
      };

      general = {
        gaps_in = 15;
        gaps_out = 15;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      gestures = {
        workspace_swipe = false;
      };

      windowrulev2 = [
        "workspace 1, class:^(alacritty)$"
      ];

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, T, exec, kitty"
        "$mainMod, B, exec, google-chrome-stable"
        "$mainMod, O, exec, obsidian"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, kitty -e lf"
        "$mainMod, V, togglefloating,"
        "$mainMod, A, exec, kitty -e pulsemixer"
        "$mainMod, C, exec, cliphist list | tofi --prompt-text 'Clipboard: ' | cliphist decode | wl-copy"  # Clipboard history

        # TUI shortcuts
        "$mainMod, S, exec, kitty -e btop"          # System monitor
        "$mainMod, G, exec, kitty --directory ~/configFiles -e lazygit"       # Git TUI
        "$mainMod, D, exec, kitty -e lazydocker"    # Docker TUI
        "$mainMod, N, exec, kitty -e nmtui"         # Network manager
        "$mainMod SHIFT, B, exec, kitty -e bluetuith"  # Bluetooth TUI
        "$mainMod, R, exec, tofi-drun --drun-launch=true"
        "$mainMod SHIFT, R, exec, tofi-drun --config ~/.config/tofi/fullscreen.conf --drun-launch=true"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  # Hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload=${./hyprland/wallpaper.jpg}
    wallpaper=,${./hyprland/wallpaper.jpg}
  '';

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}