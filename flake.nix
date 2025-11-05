{
  description = "Yeehaa's NixOS Flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";  # Match your nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    plugin-gen = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };

  };
  outputs = { self, nixpkgs, home-manager, hyprland, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Define overlays first
      overlay-nvim = (final: prev: {
        vimPlugins = prev.vimPlugins // {
          gen-nvim = prev.vimUtils.buildVimPlugin {
            name = "gen-nvim";
            src = inputs.plugin-gen;
          };
        };
      });

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      overlay-waybar = (final: prev: {
        waybar = prev.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      });

      # Single pkgs definition with all overlays
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          overlay-nvim
          overlay-unstable
          overlay-waybar
          (final: prev: {
            bun = final.unstable.bun;
          })
        ];
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            /etc/nixos/hardware-configuration.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.pkgs = pkgs;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };
                users.yeehaa.imports = [
                  ./home.nix
                ];
              };
            }
          ];
        };

        z13 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            /etc/nixos/hardware-configuration.nix
            ./configuration.nix
            ./hosts/z13.nix  # Z13-specific overrides (display scaling)
            home-manager.nixosModules.home-manager
            {
              nixpkgs.pkgs = pkgs;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };
                users.yeehaa.imports = [
                  ./home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
