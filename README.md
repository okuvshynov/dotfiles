# Dotfiles

## Quick Install

### Vim Configuration

```bash
curl -fsSL -H "Accept: application/vnd.github.v3.raw" https://api.github.com/repos/okuvshynov/dotfiles/contents/install-vim.sh | bash
```

### SilverBullet Configuration

```bash
curl -fsSL https://api.github.com/repos/okuvshynov/dotfiles/contents/silverbullet | grep -o '"download_url": "[^"]*\.md"' | cut -d'"' -f4 | xargs -n1 curl -fsSLO
```
