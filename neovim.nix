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
        xclip
        wl-clipboard
      ];


      plugins = with pkgs.vimPlugins; [

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        {
          plugin = none-ls-nvim;
          config = toLuaFile ./nvim/plugin/none-ls.lua;
        }
        lualine-nvim
        plenary-nvim
        nvim-web-devicons
        gen-nvim
        neodev-nvim
        limelight-vim
        {
          plugin = goyo-vim;
          config = toLuaFile ./nvim/plugin/goyo.lua;
        }

        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-svelte
            p.tree-sitter-css
            p.tree-sitter-astro
            p.tree-sitter-typescript
            p.tree-sitter-ocaml
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
          config = toLua ''
            require("project_nvim").setup({
              -- Disable LSP detection to avoid the deprecated function call
              detection_methods = { "pattern" },
              patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            })
          '';
        }
        vim-nix
      ];

      extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/mappings.lua}
      '';
    };
  }
