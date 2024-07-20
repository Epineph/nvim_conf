#!/bin/bash

# Uninstall Neovim
if command -v nvim &> /dev/null; then
    echo "Uninstalling Neovim..."
    sudo pacman -Rns --noconfirm neovim
else
    echo "Neovim is not installed."
fi

# Remove Neovim configuration and data
echo "Removing Neovim configuration and data..."
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Remove vim-plug
echo "Removing vim-plug..."
rm -rf ~/.local/share/nvim/site/autoload/plug.vim

echo "Neovim and all related files have been removed."

