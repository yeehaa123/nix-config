{ pkgs,  ... }:

{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        luajitPackages.lua-lsp
        nodePackages."@astrojs/language-server"
        rnix-lsp
        xclip
        wl-clipboard
      ];


      plugins = with pkgs.vimPlugins; [

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        vim-autoformat

        lualine-nvim
        plenary-nvim
        nvim-web-devicons
        {
          plugin = nvim-obsidian;
          config = toLuaFile ./nvim/plugin/obsidian.lua;
        }
        neodev-nvim
        limelight-vim
        {
          plugin = goyo-vim;
          config = toLuaFile ./nvim/plugin/goyo.lua;
        }

        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-css
            p.tree-sitter-astro
            p.tree-sitter-typescript
            p.tree-sitter-vim
            p.tree-sitter-markdown
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-rust
            p.tree-sitter-python
            p.tree-sitter-json
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        {
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }

        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }
        cmp-nvim-lsp
        telescope-fzf-native-nvim
        telescope-undo-nvim
        telescope-file-browser-nvim
        telescope-symbols-nvim
        telescope-github-nvim

        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }


        {
          plugin = project-nvim;
          config = toLua "require(\"project_nvim\").setup()";
        }
        vim-nix
      ];

      extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/mappings.lua}
      '';
    };
  }
