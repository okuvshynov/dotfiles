#!/bin/bash

set -e

REPO_URL="https://raw.githubusercontent.com/okuvshynov/dotfiles/main"
INSTALL_DIR="$HOME/.claude/commands"

echo "Installing Claude commands..."

mkdir -p "$INSTALL_DIR"

# Download all .md files from claude/commands/
for cmd_file in claude/commands/*.md; do
    if [ -f "$cmd_file" ]; then
        cmd_name=$(basename "$cmd_file")
        echo "Downloading $cmd_name..."
        curl -fsSL "$REPO_URL/claude/commands/$cmd_name" -o "$INSTALL_DIR/$cmd_name"
    fi
done

echo "Installation complete! Commands installed to $INSTALL_DIR"
