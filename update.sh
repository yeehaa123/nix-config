sudo cp ./*.nix /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#default

