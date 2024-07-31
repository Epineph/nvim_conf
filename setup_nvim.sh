#!/bin/bash

NVIM_CONF_DIR="$HOME/.config/nvim"
NVIM_CONF_FILE="$HOME/.config/nvim/init.vim"
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
PLUG_VIM_DIR="$HOME/.local/share/nvim/site/autoload/"
PLUG_VIM_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Function to install vim-plug
install_vim_plug() {
    if [ -f "$PLUG_VIM" ]; then
        echo "File $PLUG_VIM already exists."
        read -r -p "Backup file? (y/n) and make new?" prompt
        if [ "$prompt" == "y" ]; then
            mv "$PLUG_VIM" "$PLUG_VIM_DIR/plug_backup.vim"
            curl -fLo "$PLUG_VIM" --create-dirs "$PLUG_VIM_URL"
        else
            exit 1
        fi
    else
        curl -fLo "$PLUG_VIM" --create-dirs "$PLUG_VIM_URL"
    fi
}

# Function to create Neovim configuration
create_nvim_config() {
    mkdir -p "$NVIM_CONF_DIR"
    chown -R "$USER $NVIM_CONF_DIR"

    cat << 'EOF' > "$NVIM_CONF_FILE"
call plug#begin('~/.vim/plugged')

" General purpose syntax highlighting
Plug 'sheerun/vim-polyglot'

" Python support
Plug 'davidhalter/jedi-vim'

" Bash support
Plug 'arzg/vim-sh'

" R support
Plug 'jalvesaq/Nvim-R'

" JavaScript and TypeScript support
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Linting
Plug 'dense-analysis/ale'

" Syntax highlighting and colors
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'dracula/vim'
Plug 'NLKNguyen/papercolor-theme'

" File explorer
Plug 'preservim/nerdtree'

" Git integration
Plug 'tpope/vim-fugitive'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Commenting
Plug 'tpope/vim-commentary'

" Surround text objects
Plug 'tpope/vim-surround'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Snippets
Plug 'honza/vim-snippets'

" Indent line
Plug 'Yggdroot/indentLine'

" Pairs of handy bracket mappings
Plug 'jiangmiao/auto-pairs'

" LSP Config and Autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" Tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}

" Git signs
Plug 'lewis6991/gitsigns.nvim'

" Bufferline
Plug 'akinsho/bufferline.nvim', {'tag': 'v2.*'}

" Which-key
Plug 'folke/which-key.nvim'

" Sandwich
Plug 'machakann/vim-sandwich'

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
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\}

" Use system clipboard
set clipboard+=unnamedplus

" NERDTree settings
" Toggle NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree

" Airline settings
" Enable tabline in airline
let g:airline#extensions#tabline#enabled = 1

" FZF settings
set rtp+=~/.fzf
" Prefix FZF commands with Fzf
let g:fzf_command_prefix = 'Fzf'

" CoC (Conqueror of Completion) settings
" Enable these CoC extensions for various languages
let g:coc_global_extensions = ['coc-pyright', 'coc-tsserver', 'coc-json', 'coc-html', 'coc-css']

" Enable indentLine plugin
let g:indentLine_enabled = 1

" Enable auto-pairs plugin
let g:auto_pairs_enabled = 1

" Keybindings
" Quick saving with Ctrl-s
nnoremap <C-s> :w<CR>

" Navigate buffers with Ctrl-h and Ctrl-l
nnoremap <C-h> :bprev<CR>
nnoremap <C-l> :bnext<CR>

" Navigate windows with Ctrl-arrow keys
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Open FZF with Ctrl-p
nnoremap <C-p> :Files<CR>

" Comment out lines with Ctrl-/
nnoremap <C-/> :Commentary<CR>

" Surround text with quotes using vim-surround
nmap ds' :call surround#delete("normal")<CR>
nmap cs' :call surround#change("normal")<CR>
nmap ys' :call surround#yank("normal")<CR>

" Which-key configuration
lua << EOF
require("which-key").setup {}
EOF

" Define custom surround for vim-surround
let g:surround_{char2nr('c')} = "\r```\1\r```"

" Define custom surround for vim-sandwich
let g:sandwich#recipes += [{
    \   'buns': ['```vim', '```'],
    \   'input': ['cv'],
    \   'filetype': ['markdown'],
    \}]

EOF
}

# Install vim-plug
install_vim_plug

# Create Neovim configuration
create_nvim_config

# Install plugins
nvim +PlugInstall +qall

# Function to display help
show_help() {
    cat << 'EOF'
Neovim Setup Help
=================

This script sets up Neovim with a comprehensive configuration and installs a variety of useful plugins.

Keybindings:
------------

- **Quick saving:** 
  - `<C-s>`: Save the current file.

- **Buffer navigation:**
  - `<C-h>`: Go to the previous buffer.
  - `<C-l>`: Go to the next buffer.

- **Window navigation:**
  - `<C-j>`: Move to the window below.
  - `<C-k>`: Move to the window above.
  - `<C-h>`: Move to the window to the left.
  - `<C-l>`: Move to the window to the right.

- **FZF integration:**
  - `<C-p>`: Open the file search using FZF.

- **Commenting:**
  - `<C-/>`: Comment or uncomment the selected line or block of code.

- **Surround text with quotes:**
  - `ds'`: Delete surrounding quotes.
  - `cs'`: Change surrounding quotes.
  - `ys'`: Add surrounding quotes.

- **Surround text with triple backticks in vim-surround:**
  - `S c`: Surround the selected text with triple backticks for code blocks.

- **Surround text with triple backticks in vim-sandwich:**
  - `s cv`: Surround the selected text with triple backticks for code blocks.

Plugins Installed:
------------------

- **sheerun/vim-polyglot**: General purpose syntax highlighting.
- **davidhalter/jedi-vim**: Python support.
- **arzg/vim-sh**: Bash support.
- **jalvesaq/Nvim-R**: R support.
- **pangloss/vim-javascript**: JavaScript support.
- **leafgarland/typescript-vim**: TypeScript support.
- **peitalin/vim-jsx-typescript**: JSX and TypeScript support.
- **dense-analysis/ale**: Asynchronous linting.
- **morhetz/gruvbox**: Gruvbox colorscheme.
- **joshdick/onedark.vim**: One Dark colorscheme.
- **arcticicestudio/nord-vim**: Nord colorscheme.
- **ayu-theme/ayu-vim**: Ayu colorscheme.
- **dracula/vim**: Dracula colorscheme.
- **NLKNguyen/papercolor-theme**: PaperColor colorscheme.
- **preservim/nerdtree**: File explorer.
- **tpope/vim-fugitive**: Git integration.
- **vim-airline/vim-airline**: Status line.
- **vim-airline/vim-airline-themes**: Status line themes.
- **junegunn/fzf**: Fuzzy finder.
- **junegunn/fzf.vim**: Fuzzy finder integration.
- **tpope/vim-commentary**: Commenting.
- **tpope/vim-surround**: Surround text objects.
- **neoclide/coc.nvim**: Autocompletion.
- **honza/vim-snippets**: Snippets.
- **Yggdroot/indentLine**: Indent line.
- **jiangmiao/auto-pairs**: Bracket mappings.
- **neovim/nvim-lspconfig**: LSP Config.
- **hrsh7th/nvim-cmp**: Autocomplete plugin.
- **hrsh7th/cmp-nvim-lsp**: LSP completion source.
- **hrsh7th/cmp-buffer**: Buffer completion source.
- **hrsh7th/cmp-path**: Path completion source.
- **saadparwaiz1/cmp_luasnip**: LuaSnip completion source.
- **L3MON4D3/LuaSnip**: Snippet engine.
- **nvim-treesitter/nvim-treesitter**: Tree-sitter for better syntax highlighting.
- **nvim-telescope/telescope.nvim**: Telescope fuzzy finder.
- **lewis6991/gitsigns.nvim**: Git signs.
- **akinsho/bufferline.nvim**: Bufferline.
- **folke/which-key.nvim**: Which-key for displaying possible key bindings.
- **machakann/vim-sandwich**: Surround text objects with advanced options.

For more details, check the Neovim configuration file at $NVIM_CONF_FILE.
EOF
}

show_help

