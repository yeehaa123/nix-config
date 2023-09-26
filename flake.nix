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
    flake-utils.url = "github:numtide/flake-utils";
    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, nixpkgs, home-manager,flake-utils, vim-extra-plugins,  ... }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ vim-extra-plugins.overlays.default ];
    };
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
    packages = {
      neovimplus = pkgs.neovim.override {
        configure = {
          packages.example = with pkgs.vimExtraPlugins; {
            start = [
              vim-moonfly-colors
            ];
          };
        };
      };
    };
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = with self.nixosModules; [
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
          }];
      };
    };
  };
}
