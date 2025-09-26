#!/bin/bash

set -e

echo "Setting up vim configuration..."

mkdir -p ~/.vim/pack/plugins/start
mkdir -p ~/.vim/pack/plugins/opt

echo "Installing NERDTree..."
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/plugins/start/nerdtree 2>/dev/null || \
    (cd ~/.vim/pack/plugins/start/nerdtree && git pull)

echo "Installing fzf.vim..."
git clone https://github.com/junegunn/fzf.vim.git ~/.vim/pack/plugins/start/fzf.vim 2>/dev/null || \
    (cd ~/.vim/pack/plugins/start/fzf.vim && git pull)

echo "Installing vim-gutentags..."
git clone https://github.com/ludovicchabant/vim-gutentags.git ~/.vim/pack/plugins/start/vim-gutentags 2>/dev/null || \
    (cd ~/.vim/pack/plugins/start/vim-gutentags && git pull)

echo "Installing fzf binary..."
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin --no-key-bindings --no-completion --no-update-rc
else
    echo "fzf already installed, updating..."
    cd ~/.fzf && git pull && ./install --bin --no-key-bindings --no-completion --no-update-rc
fi

echo "Downloading vimrc..."
curl -fsSL https://raw.githubusercontent.com/oleksandr/dotfiles/main/vim/vimrc -o ~/.vimrc

echo "Done! Vim is now configured with NERDTree, fzf, and gutentags."
echo "Use Ctrl+\ to toggle NERDTree and F7 for fzf history."