{
  description = "Yeehaa's NixOS Flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";  # Match your nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    plugin-obsidian = {
      url = "github:epwalsh/obsidian.nvim";
      flake = false;
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
          nvim-obsidian = prev.vimUtils.buildVimPlugin {
            name = "nvim-obsidian";
            src = inputs.plugin-obsidian;
          };
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
        default = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
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
