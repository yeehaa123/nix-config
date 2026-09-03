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
            # Bun 1.4 is not in nixpkgs yet — unstable is still on 1.3.13 —
            # and the brains repo now requires >= 1.4.0 for `Bun.Image`.
            # Overridden here rather than installed from bun.com so it keeps
            # flowing through bun-wrapped, which injects LD_LIBRARY_PATH so
            # prebuilt native modules can dlopen libstdc++. Drop this whole
            # override once unstable ships 1.4.
            bun = final.unstable.bun.overrideAttrs (old: {
              version = "1.4.0";
              src = final.fetchurl {
                url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.0/bun-linux-x64.zip";
                hash = "sha256-LQP7X7g6yLVnrKCigbLOGhoZ1Ij1bClo2Iw/Jekv5FI=";
              };
            });
            claude-code = final.unstable.claude-code-bin.overrideAttrs (old: {
              version = "2.1.258";
              src = final.fetchurl {
                url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/2.1.258/linux-x64/claude";
                hash = "sha256-cE8TNKxl0+ieHGwddmMpOteGphZq/bcbUHUzffYw+XY=";
              };
            });
            paper-desktop = final.callPackage ./paper.nix {};
            pencil-desktop = final.callPackage ./pencil.nix {};
          })
        ];
      };
    in
    {
      nixosConfigurations = {
        zenbook = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/zenbook-hardware.nix
            ./configuration.nix
            ./hosts/zenbook.nix  # Zenbook-specific overrides
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
            ./hosts/z13-hardware.nix
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
