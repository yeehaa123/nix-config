{
  description = "Yeehaa's NixOS Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    hyprland = { 
      url = "github:hyprwm/Hyprland";
    };

    plugin-obsidian = { 
      url = "github:epwalsh/obsidian.nvim";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };


    overlay-nvim = (final: prev: {
      vimPlugins = prev.vimPlugins // {
        nvim-obsidian = prev.vimUtils.buildVimPlugin {
          name = "nvim-obsidian";
          src = inputs.plugin-obsidian;
        };
      };
    });
  in
  {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-nvim ]; })
          ./configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
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
