#!/bin/bash

NVIM_CONF_DIR="$HOME/.config/nvim"
NVIM_CONF_FILE="$HOME/.config/nvim/init.vim"
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
PLUG_VIM_DIR="$HOME/.local/share/nvim/site/autoload/"
PLUG_VIM_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Download vim-plug if not already present
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

# Check if the Neovim configuration file exists
if [ ! -f "$NVIM_CONF_FILE" ]; then
    if [ ! -d "$NVIM_CONF_DIR" ]; then
        sudo mkdir -p $HOME/.config/nvim
        sudo chown -R $USER $HOME/.config/nvim
    fi

    # Create the init.vim configuration file
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
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'

" Language Servers
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Treesitter for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" Enable line numbers
set number

" Set default colorscheme
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

" Treesitter configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

" LSP configuration
lua <<EOF
local lspconfig = require'lspconfig'
local lspinstall = require'lspinstall'

lspinstall.setup()

local servers = lspinstall.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup{}
end
EOF
EOF

    nvim +PlugInstall +qall

    echo "Neovim configuration installed. Please choose a color scheme:"
    echo "1) gruvbox"
    echo "2) onedark"
    echo "3) nord"
    echo "4) ayu"

    read -p "Select a color scheme (1-4): " color_choice

    case $color_choice in
        1)
            sed -i 's/colorscheme .*/colorscheme gruvbox/' $NVIM_CONF_FILE
            ;;
        2)
            sed -i 's/colorscheme .*/colorscheme onedark/' $NVIM_CONF_FILE
            ;;
        3)
            sed -i 's/colorscheme .*/colorscheme nord/' $NVIM_CONF_FILE
            ;;
        4)
            sed -i 's/colorscheme .*/colorscheme ayu/' $NVIM_CONF_FILE
            ;;
        *)
            echo "Invalid choice. Keeping default gruvbox."
            ;;
    esac

    echo "Neovim setup complete. Start nvim to enjoy your new setup!"
else
    echo "File $NVIM_CONF_FILE exists!"
    echo "Please make a backup and delete to make a new"
fi

