#!/usr/bin/env bash

# lf preview script optimized for kitty terminal
file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

# Clear previous image if any
if [ -n "$KITTY_WINDOW_ID" ]; then
    kitty +kitten icat --clear --stdin=no --silent --transfer-mode=memory > /dev/tty
fi

case "$(file -Lb --mime-type "$file")" in
    image/*)
        if [ -n "$KITTY_WINDOW_ID" ]; then
            # Use kitty's image protocol for crisp image display
            kitty +kitten icat --silent --stdin=no --transfer-mode=memory \
                --place="${w}x${h}@${x}x${y}" "$file" > /dev/tty

            # Print file info below image
            printf "\n\n"
            file -b "$file"
            printf "\n"
            exiftool "$file" 2>/dev/null | head -20 || true
        else
            # ASCII art fallback
            chafa --format=symbols --size="${w}x${h}" "$file"
            echo
            file -b "$file"
        fi
        ;;
    *)
        # Use the original preview for non-images
        ~/.config/lf/previewer "$@"
        ;;
esac