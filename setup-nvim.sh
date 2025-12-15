#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="$HOME/.config/nvim"
NVIM_REPO="$DOTFILES_DIR/nvim"

echo "Setting up Neovim configuration..."

# Check if nvim config already exists
if [ -e "$NVIM_CONFIG" ]; then
    if [ -L "$NVIM_CONFIG" ]; then
        TARGET=$(readlink "$NVIM_CONFIG")
        if [ "$TARGET" = "$NVIM_REPO" ]; then
            echo "✓ Neovim symlink already correctly configured"
            exit 0
        else
            echo "⚠ Neovim symlink exists but points to: $TARGET"
            echo "  Expected: $NVIM_REPO"
            read -p "Remove and recreate? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$NVIM_CONFIG"
            else
                echo "Aborted."
                exit 1
            fi
        fi
    else
        BACKUP="$NVIM_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        echo "⚠ Existing nvim config found, backing up to:"
        echo "  $BACKUP"
        mv "$NVIM_CONFIG" "$BACKUP"
    fi
fi

# Create symlink
echo "Creating symlink: $NVIM_CONFIG → $NVIM_REPO"
ln -s "$NVIM_REPO" "$NVIM_CONFIG"

echo "✓ Neovim configuration setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open nvim - plugins will auto-install via lazy.nvim"
echo "  2. Run :checkhealth to verify setup"
