#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS="$HOME/.claude/commands"
COMMANDS_REPO="$DOTFILES_DIR/claude/commands"

echo "Setting up Claude Code commands..."

# Ensure ~/.claude directory exists
mkdir -p "$HOME/.claude"

# Check if commands already exists
if [ -e "$CLAUDE_COMMANDS" ]; then
    if [ -L "$CLAUDE_COMMANDS" ]; then
        TARGET=$(readlink "$CLAUDE_COMMANDS" | sed 's:/$::')
        if [ "$TARGET" = "$COMMANDS_REPO" ]; then
            echo "✓ Claude commands symlink already correctly configured"
            exit 0
        else
            echo "⚠ Claude commands symlink exists but points to: $TARGET"
            echo "  Expected: $COMMANDS_REPO"
            read -p "Remove and recreate? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$CLAUDE_COMMANDS"
            else
                echo "Aborted."
                exit 1
            fi
        fi
    else
        BACKUP="$CLAUDE_COMMANDS.backup.$(date +%Y%m%d_%H%M%S)"
        echo "⚠ Existing commands found, backing up to:"
        echo "  $BACKUP"
        mv "$CLAUDE_COMMANDS" "$BACKUP"
    fi
fi

# Create symlink
echo "Creating symlink: $CLAUDE_COMMANDS → $COMMANDS_REPO"
ln -s "$COMMANDS_REPO" "$CLAUDE_COMMANDS"

echo "✓ Claude Code commands setup complete!"
echo ""
echo "Available commands:"
for cmd in "$COMMANDS_REPO"/*.md; do
    echo "  /$(basename "$cmd" .md)"
done
