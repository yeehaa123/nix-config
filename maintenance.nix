{ config, pkgs, lib, ... }:

{
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";  # Run every week
    options = "--delete-older-than 14d";  # Keep last 2 weeks
    persistent = true;  # Catch up if the system was powered off
  };

  # Optimize nix store (deduplication)
  # DISABLED: Can cause system freezes during operation
  # Run manually with: sudo nix-store --optimise
  nix.optimise = {
    automatic = false;  # Explicitly disabled to prevent freezes
  };

  # Auto-upgrade system (optional - uncomment if you want)
  # system.autoUpgrade = {
  #   enable = true;
  #   dates = "02:00";
  #   flake = "/home/yeehaa/configFiles";
  #   flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  # };

  # System maintenance scripts
  systemd.services = {
    # Clean temporary files older than 7 days
    clean-tmp = {
      description = "Clean old temporary files";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.findutils}/bin/find /tmp -type f -atime +7 -delete 2>/dev/null || true'";
      };
    };

    # Backup configuration
    backup-config = {
      description = "Backup NixOS configuration";
      serviceConfig = {
        Type = "oneshot";
        User = "yeehaa";
        ExecStart = "${pkgs.writeShellScript "backup-config" ''
          #!/bin/sh
          BACKUP_DIR="$HOME/backups/nixos-config"
          TIMESTAMP=$(date +%Y%m%d_%H%M%S)

          mkdir -p "$BACKUP_DIR"

          # Backup the config directory
          ${pkgs.gnutar}/bin/tar -czf "$BACKUP_DIR/config-$TIMESTAMP.tar.gz" \
            -C "$HOME" configFiles \
            --exclude='.git' \
            --exclude='result' \
            --exclude='*.swp'

          # Keep only last 10 backups
          ls -t "$BACKUP_DIR"/config-*.tar.gz 2>/dev/null | tail -n +11 | xargs -r rm

          echo "Backup completed: $BACKUP_DIR/config-$TIMESTAMP.tar.gz"
        ''}";
      };
    };

    # System health check
    system-health-check = {
      description = "Check system health";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "health-check" ''
          #!/bin/sh

          # Check disk space
          DISK_USAGE=$(${pkgs.coreutils}/bin/df / | awk 'NR==2 {print int($5)}')
          if [ "$DISK_USAGE" -gt 80 ]; then
            ${pkgs.libnotify}/bin/notify-send -u critical "Disk Space Warning" "Root partition is $DISK_USAGE% full"
          fi

          # Check memory usage
          MEM_PERCENT=$(${pkgs.procps}/bin/free | grep Mem | awk '{print int($3/$2 * 100)}')
          if [ "$MEM_PERCENT" -gt 90 ]; then
            ${pkgs.libnotify}/bin/notify-send -u critical "Memory Warning" "Memory usage is at $MEM_PERCENT%"
          fi

          # Check for failed services
          FAILED=$(${pkgs.systemd}/bin/systemctl --failed --no-legend | wc -l)
          if [ "$FAILED" -gt 0 ]; then
            ${pkgs.libnotify}/bin/notify-send -u critical "System Services" "$FAILED services have failed"
          fi

          # Check system load
          LOAD=$(${pkgs.coreutils}/bin/cat /proc/loadavg | awk '{print $1}')
          CORES=$(${pkgs.coreutils}/bin/nproc)
          if (( $(echo "$LOAD > $CORES * 2" | ${pkgs.bc}/bin/bc -l) )); then
            ${pkgs.libnotify}/bin/notify-send -u critical "High Load" "System load is $LOAD"
          fi
        ''}";
      };
    };
  };

  # Timers for the services
  systemd.timers = {
    clean-tmp = {
      description = "Clean temporary files weekly";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };

    backup-config = {
      description = "Backup configuration daily";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    system-health-check = {
      description = "Check system health every 6 hours";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 00,06,12,18:00:00";
        Persistent = true;
      };
    };
  };

  # Add maintenance commands as aliases
  programs.bash.shellAliases = {
    # Maintenance commands
    sys-clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
    sys-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    sys-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    sys-health = "sudo systemctl start system-health-check.service && journalctl -u system-health-check -n 20";
    sys-backup = "sudo systemctl start backup-config.service";

    # Quick status commands
    sys-failed = "systemctl --failed";
    sys-timers = "systemctl list-timers --all";
    sys-boot-time = "systemd-analyze boot";
  };
}