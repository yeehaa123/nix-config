{
  description = "Yeehaa's NixOS Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-23.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    plugin-obsidian = { 
      url = "github:epwalsh/obsidian.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };


    overlay-nvim = (final: prev: {
      vimPlugins = prev.vimPlugins // {
        nvim-obsidian = prev.vimUtils.buildVimPluginFrom2Nix {
          name = "nvim-obsidian";
          src = inputs.plugin-obsidian;
        };
      };
    });
  in
  {
    nixosModules = {
      gnome = { pkgs, ... }: {
        config = {
          environment.gnome.excludePackages = (with pkgs; [
            gnome-photos
            gnome-tour
          ]) ++ (with pkgs.gnome; [
            cheese # webcam tool
            gnome-music
            gedit # text editor
            epiphany # web browser
            geary # email reader
            gnome-characters
            tali # poker game
            iagno # go game
            hitori # sudoku game
            atomix # puzzle game
            yelp # Help view
            gnome-contacts
            gnome-initial-setup
          ]);
          programs.dconf.enable = true;
          environment.systemPackages = with pkgs; [
            gnome.gnome-tweaks
          ];
        };
      };
    };
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
