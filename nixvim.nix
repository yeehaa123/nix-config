{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      autoindent = true;
      expandtab = true;
    };

    maps = {
      normal = {
        "<Space>" = {
          action = "<Nop>";
        };
        "<Leader>t" = {
          action = ":NvimTreeToggle<CR>";
        };
      };
      insert."jj" = {
        action = "<esc>";
      };
    };
    globals.mapleader = " ";
    colorschemes.onedark.enable = true;
    plugins = {
      lightline.enable = true;
      nvim-cmp = {
        enable = true;
      };
      commentary = {
        enable = true;
      };
      startify = {
        enable = true;
      };
      treesitter = {
        enable = true;
      };
      project-nvim = {
        enable = true;
      };
      nvim-tree = {
        enable = true;
      };
      telescope = {
        enable = true;
        extensions = {
          project-nvim = {
            enable = true;
          };
          fzf-native = {
            enable = true;
          };
        };
        keymaps = {
          "<Leader>lg" = "live_grep";
          "<Leader>km" = "keymaps";
          "<Leader>ff" = "find_files";
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
      zen-mode-nvim
    ];
  };
}
