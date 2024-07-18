#!/bin/bash

NVIM_CONF_DIR="$HOME/.config/nvim"
NVIM_CONF_FILE="$HOME/.config/nvim/init.vim"
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
PLUG_VIM_DIR="$HOME/.local/share/nvim/site/autoload/"
PLUG_VIM_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
if [ -f "$PLUG_VIM" ]; then
	echo "File $PLUG_VIM already exists."
	read -r -p "Backup file? (y/n) and make new?" prompt
	if [ "$prompt" == "y" ]; then
		sudo mv "$PLUG_VIM" "$PLUG_VIM_DIR/plug_backup.vim"
		curl -fLo $PLUG_VIM --create-dirs $PLUG_VIM_URL
	else
		exit 1
	fi
else
	curl -fLo $PLUG_VIM --create-dirs $PLUG_VIM_URL
fi

if [ ! -f "$NVIM_CONF_FILE" ]; then
	if [ ! -d "$NVIM_CONF_DIR" ]; then
		sudo mkdir -p $HOME/.config/nvim
	fi
	cat << 'EOF' > ~/.config/nvim/init.vim
call plug#begin('~/.vim/plugged')

" Python support
Plug 'davidhalter/jedi-vim'

" Bash support
Plug 'arzg/vim-sh'

" R support
Plug 'jalvesaq/Nvim-R'

" Linting
Plug 'dense-analysis/ale'

" Syntax highlighting and colors
Plug 'morhetz/gruvbox'

call plug#end()

" Enable line numbers
set number

" Set colorscheme
colorscheme gruvbox

" Set indentation for Bash scripts
autocmd FileType sh setlocal shiftwidth=2 tabstop=2

" Enable ALE linting
let g:ale_linters = {
\   'python': ['flake8'],
\   'sh': ['shellcheck'],
\}

" Use system clipboard
set clipboard+=unnamedplus
EOF
nvim +PlugInstall +qall
else
	echo "File $NVIM_CONF_FILE exists!"
	echo "Please make a backup and delete to make a new"
fi



