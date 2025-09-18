#!/usr/bin/env bash

# System Maintenance Dashboard
# A TUI dashboard for system maintenance tasks

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           NixOS System Maintenance Dashboard           ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo

# System Info
echo -e "${GREEN}▶ System Information${NC}"
echo "  Hostname: $(hostname)"
echo "  Kernel: $(uname -r)"
echo "  Uptime: $(uptime -p | sed 's/up //')"
echo

# Disk Usage
echo -e "${GREEN}▶ Disk Usage${NC}"
df -h / | awk 'NR==2 {
    usage=int($5)
    if (usage > 80)
        printf "  ⚠️  Root: %s used of %s (%s%%)\n", $3, $2, $5
    else
        printf "  ✓ Root: %s used of %s (%s%%)\n", $3, $2, $5
}'

# Nix store size
STORE_SIZE=$(du -sh /nix/store 2>/dev/null | cut -f1)
echo "  Nix Store: $STORE_SIZE"
echo

# Memory Usage
echo -e "${GREEN}▶ Memory Usage${NC}"
free -h | awk 'NR==2 {
    printf "  Total: %s | Used: %s | Free: %s\n", $2, $3, $4
}'
echo

# System Generations
echo -e "${GREEN}▶ System Generations${NC}"
GENERATIONS=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -5)
TOTAL_GENS=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l)
echo "  Total Generations: $TOTAL_GENS"
echo "  Latest 5:"
echo "$GENERATIONS" | sed 's/^/    /'
echo

# Failed Services
echo -e "${GREEN}▶ System Health${NC}"
FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [ "$FAILED" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} All services running"
else
    echo -e "  ${RED}⚠${NC} $FAILED failed services"
    systemctl --failed --no-legend | head -3 | sed 's/^/    /'
fi
echo

# Maintenance Options
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Available Maintenance Commands:${NC}"
echo
echo "  [1] Clean garbage & optimize     (sys-clean)"
echo "  [2] Backup configuration         (sys-backup)"
echo "  [3] Check system health          (sys-health)"
echo "  [4] Show failed services         (sys-failed)"
echo "  [5] Show all timers             (sys-timers)"
echo "  [6] Delete old generations      (manual)"
echo "  [7] Update flake inputs         (update)"
echo "  [8] Rebuild system              (rebuild)"
echo "  [q] Quit"
echo
read -p "Select option: " choice

case $choice in
    1)
        echo "Running garbage collection and optimization..."
        sudo nix-collect-garbage -d && sudo nix-store --optimise
        ;;
    2)
        echo "Starting configuration backup..."
        systemctl --user start backup-config.service
        ;;
    3)
        echo "Running health check..."
        sudo systemctl start system-health-check.service
        journalctl -u system-health-check -n 20
        ;;
    4)
        systemctl --failed
        ;;
    5)
        systemctl list-timers --all
        ;;
    6)
        echo "Current generations:"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
        read -p "Keep how many recent generations? " keep
        sudo nix-env --delete-generations +$keep --profile /nix/var/nix/profiles/system
        ;;
    7)
        cd ~/configFiles && nix flake update
        ;;
    8)
        cd ~/configFiles && ./rebuild.sh
        ;;
    q)
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
esac

echo
read -p "Press Enter to continue..."
exec $0