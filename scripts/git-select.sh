#!/usr/bin/env bash

# Find all git repos under home directory (max depth 3 for performance)
repo=$(find ~ -maxdepth 3 -type d -name ".git" 2>/dev/null | \
       sed 's|/\.git$||' | \
       fzf --prompt="Select repo: " --height=40% --reverse)

if [ -n "$repo" ]; then
    cd "$repo" && lazygit
fi