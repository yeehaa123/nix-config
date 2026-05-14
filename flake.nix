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
            claude-code = final.unstable.claude-code-bin.overrideAttrs (old: {
              version = "2.1.114";
              src = final.fetchurl {
                url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/2.1.114/linux-x64/claude";
                sha256 = "12bd4b0916deb06be17ffc7b2f0485e140bf00b2db3dcb78469d66723d73c27f";
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
