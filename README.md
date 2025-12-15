# Dotfiles

## Quick Install

### Neovim Configuration

```bash
./setup-nvim.sh
```

This creates a symlink from `~/.config/nvim` to the dotfiles repo, so any changes you make are automatically tracked. Plugins will auto-install via lazy.nvim on first launch.

### Claude Code Commands

```bash
./setup-claude.sh
```

This creates a symlink from `~/.claude/commands` to the dotfiles repo. Custom slash commands (`/up2speed`, `/feature`, etc.) are then available in all Claude Code sessions.

### Vim Configuration

```bash
curl -fsSL -H "Accept: application/vnd.github.v3.raw" https://api.github.com/repos/okuvshynov/dotfiles/contents/install-vim.sh | bash
```

### SilverBullet Configuration

```bash
curl -fsSL https://api.github.com/repos/okuvshynov/dotfiles/contents/silverbullet | grep -o '"download_url": "[^"]*\.md"' | cut -d'"' -f4 | xargs -n1 curl -fsSLO
```
