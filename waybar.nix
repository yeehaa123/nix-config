{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;  # Disable systemd auto-start since Hyprland starts it
    };
    settings = {
      mainbar = {
        position = "bottom";
        height = 30;
        spacing = 10;

        modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "group/hardware" "group/battery" "custom/wlogout" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        "custom/wlogout" = {
          format = " ";
          interval = "once";
          on-click = "wlogout -c 5 -r 5 -p layer-shell";
        };

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          format = "{}% ";
        };

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [ "cpu" "memory" "temperature" ];
        };

        "group/battery" = {
          orientation = "horizontal";
          modules = [ "battery" "battery#bat2" ];
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "kitty -e pulsemixer";
        };
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0px;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 11px;
          min-height: 0;
          transition: 0.3s;
      }

      window#waybar {
          background: rgba(21, 18, 27, 0.7);
          color: #cdd6f4;
      }

      tooltip {
          border-radius: 10px;
          border-width: 1.5px;
          border-style: solid;
          border-color: #11111b;
          transition: 0.3s;
      }

      #workspaces button {
          padding: 5px;
          color: #313244;
          margin-right: 5px;
      }

      #workspaces button.active {
          color: #a6adc8;
      }

      #workspaces button.focused {
          color: #a6adc8;
          background: #eba0ac;
      }

      #workspaces button.urgent {
          color: #11111b;
          background: #a6e3a1;
      }

      #workspaces button:hover {
          color: #cdd6f4;
      }

      #custom-power_profile,
      #custom-wlogout,
      #custom-weather,
      #window,
      #clock,
      #battery,
      #hardware,
      #pulseaudio,
      #network,
      #bluetooth,
      #cpu,
      #memory,
      #workspaces,
      #temperature,
      #tray,
      #backlight {
          padding: 0px 10px;
          margin: 0;
          margin-top: 5px;
      }

      #temperature.critical {
          color: #eba0ac;
      }

      #backlight {
          padding-left: 7px;
      }

      #tray {
          margin-right: 5px;
          padding: 0px 4px;
      }

      #workspaces {
          margin-left: 5px;
          padding-right: 0px;
          padding-left: 5px;
      }

      #custom-power_profile {
          color: #a6e3a1;
      }

      #window {
          border-radius: 20px;
          margin-left: 5px;
          margin-right: 5px;
      }

      #pulseaudio.microphone {
          margin-right: 5px;
          padding-right: 8px;
      }

      #battery {
          margin-right: 5px;
      }

      #custom-weather {
         margin-left: 0px;
      }
    '';
  };
}