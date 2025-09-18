{ config, pkgs, ... }:

{
  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
      relativenumber = true;
      number = true;
      ratios = "1:2:3";
      info = "size";
      scrolloff = 10;
      period = 1;
      tabstop = 4;
      shell = "bash";
      shellopts = "-eu";
      ifs = "\\n";
    };

    commands = {
      # Open commands
      open = ''
        ''${{
          case $(file --mime-type "$f" -bL) in
            text/*|application/json) $EDITOR "$f";;
            video/*) mpv "$f";;
            audio/*) mpv --audio-display=no "$f";;
            image/*) imv "$f" 2>/dev/null || feh "$f";;
            application/pdf) zathura "$f" 2>/dev/null || evince "$f";;
            application/epub*) zathura "$f" 2>/dev/null;;
            application/zip|application/x-tar|application/x-gzip) atool -l "$f" | less;;
            *) xdg-open "$f" ;;
          esac
        }}
      '';

      # Create directory
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read ans
          mkdir -p "$ans"
        }}
      '';

      # Create file
      mkfile = ''
        ''${{
          printf "File Name: "
          read ans
          $EDITOR "$ans"
        }}
      '';

      # Trash instead of delete
      trash = ''
        ''${{
          files=$(printf "$fx" | tr '\n' ';')
          while [ "$files" ]; do
            file=''${files%%;*}
            ${pkgs.trashy}/bin/trash put "$(basename "$file")"
            if [ "$files" = "$file" ]; then
              files=""
            else
              files="''${files#*;}"
            fi
          done
        }}
      '';

      # Extract archives
      extract = ''
        ''${{
          case "$f" in
            *.tar.bz2) tar xjf "$f" ;;
            *.tar.gz)  tar xzf "$f" ;;
            *.tar.xz)  tar xJf "$f" ;;
            *.bz2)     bunzip2 "$f" ;;
            *.gz)      gunzip "$f" ;;
            *.tar)     tar xf "$f" ;;
            *.tbz2)    tar xjf "$f" ;;
            *.tgz)     tar xzf "$f" ;;
            *.zip)     unzip "$f" ;;
            *.Z)       uncompress "$f" ;;
            *.7z)      7z x "$f" ;;
            *.rar)     unrar x "$f" ;;
          esac
        }}
      '';

      # Zip selected files
      zip = ''
        ''${{
          printf "Archive name: "
          read ans
          zip -r "$ans.zip" $(printf "$fx" | tr '\n' ' ')
        }}
      '';

      # Search with ripgrep
      rg = ''
        ''${{
          printf "Search term: "
          read ans
          ${pkgs.ripgrep}/bin/rg --color=always "$ans" | less -R
        }}
      '';

      # Jump with zoxide
      z = ''
        ''${{
          result="$(${pkgs.zoxide}/bin/zoxide query -i)"
          lf -remote "send $id cd \"$result\""
        }}
      '';

      # Preview toggle
      preview-toggle = ''
        :set preview!
        :set ratios 1:2
      '';

      # Show file info
      info = ''
        ''${{
          ${pkgs.bat}/bin/bat --style=plain --paging=always "$f"
        }}
      '';
    };

    keybindings = {
      # Vim-style navigation
      "h" = "updir";
      "j" = "down";
      "k" = "up";
      "l" = "open";

      # Quick navigation
      "gg" = "top";
      "G" = "bottom";
      "gh" = "cd ~";
      "gc" = "cd ~/configFiles";
      "gd" = "cd ~/Downloads";
      "gD" = "cd ~/Documents";
      "gr" = "cd /";

      # Page movement
      "<c-u>" = "half-up";
      "<c-d>" = "half-down";
      "<c-b>" = "page-up";
      "<c-f>" = "page-down";

      # File operations
      "dd" = "cut";
      "yy" = "copy";
      "pp" = "paste";
      "dD" = "trash";
      "dX" = "delete";
      "u" = "clear";  # Clear cut/copy selection

      # Creation
      "o" = "mkfile";
      "O" = "mkdir";

      # Archive operations
      "xe" = "extract";
      "xz" = "zip";

      # Search and jump
      "/" = "search";
      "?" = "search-back";
      "n" = "search-next";
      "N" = "search-prev";
      "f" = "z";  # zoxide jump

      # View
      "i" = "info";
      "zp" = "preview-toggle";
      "zh" = "set hidden!";

      # Shell
      "W" = "$$SHELL";
      "!" = "shell";
      "!!" = "shell-wait";

      # Copy paths
      "Y" = ''$printf "%s" "$fx" | wl-copy'';  # Copy full path
      "yn" = ''$basename "$f" | wl-copy'';     # Copy filename
      "yd" = ''$dirname "$f" | wl-copy'';      # Copy directory path

      # Rename
      "A" = "rename";  # Rename at end (like vim A)
      "I" = "push A<c-a>";  # Rename at beginning
      "cw" = "push A<c-u>";  # Change word (replace filename)
      "cc" = "push A<c-u>";  # Change line (replace filename)

      # Selection
      "<space>" = "toggle";
      "V" = "invert";
      "v" = "toggle";
      "<esc>" = "unselect";

      # Marks (like vim)
      "m" = "mark-save";
      "'" = "mark-load";
      "\""  = "mark-remove";
    };

    # Remove previewer block - we'll define it in extraConfig

    extraConfig = ''
      # Gruvbox colors for lf
      set promptfmt "\033[33;1m%u\033[0m:\033[34;1m%d\033[0m\033[33;1m%f\033[0m"

      # Use trash by default
      cmd delete ''${{
        printf "Delete permanently? [y/N] "
        read ans
        [ "$ans" = "y" ] && rm -rf $fx
      }}

      # Comprehensive previewer for all file types
      set previewer ${pkgs.writeShellScript "lf-preview" ''
        #!/usr/bin/env bash
        file="$1"
        w="$2"
        h="$3"

        # Handle by extension first for images
        case "$file" in
          *.png|*.jpg|*.jpeg|*.gif|*.webp|*.PNG|*.JPG|*.JPEG|*.GIF|*.WEBP)
            # For images, use chafa to create ASCII art preview
            ${pkgs.chafa}/bin/chafa --format=symbols --colors=256 --size="''${w}x''${h}" "$file" 2>/dev/null || echo "Image preview failed"
            exit 0
            ;;
          *.pdf|*.PDF)
            ${pkgs.poppler_utils}/bin/pdftotext -l 10 -nopgbrk -q "$file" - | head -500
            exit 0
            ;;
        esac

        # Fall back to mime type detection for everything else
        mime=$(${pkgs.file}/bin/file -Lb --mime-type "$file")

        case "$mime" in
          # Text files
          text/*|application/json|application/javascript|application/x-shellscript)
            ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --line-range=:500 "$file"
            ;;

          # Markdown
          text/markdown)
            ${pkgs.glow}/bin/glow -s dark "$file"
            ;;

          # Images (fallback if not caught by extension)
          image/*)
            ${pkgs.chafa}/bin/chafa --format=symbols --colors=256 --size="''${w}x''${h}" "$file" 2>/dev/null || echo "Image preview failed"
            ;;

          # Videos (thumbnail)
          video/*)
            CACHE="/tmp/lf-thumb-$(echo "$file" | sha256sum | cut -d' ' -f1).jpg"
            if [ ! -f "$CACHE" ]; then
              ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$file" -o "$CACHE" -s 0 2>/dev/null
            fi
            if [ -f "$CACHE" ]; then
              ${pkgs.chafa}/bin/chafa --format=symbols --colors=256 --size="''${w}x''${h}" "$CACHE" 2>/dev/null || echo "Video preview failed"
            else
              echo "Video: $file"
              ${pkgs.mediainfo}/bin/mediainfo "$file" 2>/dev/null | head -20
            fi
            ;;

          # Archives
          application/zip|application/x-tar|application/x-gzip|application/x-bzip2|application/x-xz|application/x-rar|application/x-7z-compressed)
            ${pkgs.atool}/bin/atool -l "$file" | head -50
            ;;

          # Directories
          inode/directory)
            ${pkgs.eza}/bin/eza --icons --color=always --group-directories-first -la "$file" | head -50
            ;;

          # Office documents
          application/vnd.oasis.opendocument.*)
            ${pkgs.odt2txt}/bin/odt2txt "$file" | head -500
            ;;

          # Fallback
          *)
            ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --line-range=:500 "$file" 2>/dev/null || \
            ${pkgs.file}/bin/file -b "$file"
            ;;
        esac
      ''}
    '';
  };

  # Add trashy for safer file deletion
  home.packages = with pkgs; [
    trashy
    imv  # Image viewer
  ];
}