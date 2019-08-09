set shell=/bin/bash

" Plugins
call plug#begin('~/.local/share/nvim/plugged')

" Theme
Plug 'joshdick/onedark.vim'             " one dark theme

" Gui enhancements
Plug 'itchyny/lightline.vim'            " improved status line
Plug 'machakann/vim-highlightedyank'    " highlight lines while yanking

" Editor enhancements
Plug 'editorconfig/editorconfig-vim'    " consistent code style across editors
Plug 'scrooloose/nerdtree'              " file browser
Plug 'tpope/vim-unimpaired'             " move lines of code around using alt+j/k

" Semantic language support
Plug 'airblade/vim-gitgutter'           " show git changes in the sign column

" Completion plugins
Plug 'neoclide/coc.nvim', { 
    \ 'branch': 'release'
    \ }                                 " intellisense engine for vim8/neovim
Plug 'jiangmiao/auto-pairs'             " auto close parens, braces and brackets
Plug 'scrooloose/nerdcommenter'         " improve commenting of code

" Syntactic language support
Plug 'rust-lang/rust.vim'               " Rust
Plug 'HerringtonDarkholme/yats.vim'     " TypeScript
Plug 'cespare/vim-toml'                 " TOML

call plug#end()

" Autocomplete and plugins
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-css',
    \ 'coc-rls',
    \ 'coc-eslint',
    \ 'coc-prettier'
    \ ]
set completeopt=noinsert,menuone,noselect

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" Do not hijack the Enter key
inoremap <expr><Tab> (pumvisible() ? (empty(v:completed_item) ? "\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible() ? (empty(v:completed_item) ? "\<CR>\<CR>":"\<C-y>"):"\<CR>")

" Editor settings
filetype plugin indent on               " file type detection
set autoindent                          " auto-indent each line
set encoding=utf-8                      " enable utf-8 encoding
set scrolloff=2                         " minimum lines to keep above and below cursor

" Default indentation
set shiftwidth=4                        " spaces to auto-indent 
set tabstop=4                           " tab width of 4 spaces
set expandtab                           " expand tabs to spaces

" GUI settings
syntax on                               " syntax highlighting
set synmaxcol=500                       " no syntax highlight on long lines for perf.
colorscheme onedark                     " onedark color scheme
set ttyfast                             " indicate a fast terminal connection
set lazyredraw                          " reduce updates while not typing
set laststatus=2                        " always show the status line
set cursorline                          " highlight the current line
set background=dark
hi normal guibg=none ctermbg=none       " transparent background
set shortmess+=c                        " suppress 'match x of y' messages

" Change cursor and add incremental commands
if has('nvim')
    " hi Cursor guifg=black guibg=green gui=reverse
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end

" Change highlight colors for coc
hi CocErrorSign     guifg=#E06C75
hi CocWarningSign   guifg=#E5C07B
hi CocInfoSign      guifg=#61AFEF
hi CocHintSign      guifg=#98C379

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Lightline
set noshowmode                          " hide insert status
let g:lightline = {
    \ 'colorscheme': 'one',
    \ }

" Use 24-bit colors in vim/neovim
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Treat .svelte files as html
au! BufNewFile,BufRead *.svelte set ft=html

" Avoid backups
set nowritebackup
set noswapfile
set nobackup

" Keyboard shortcuts
" Remap leader key to ,
let mapleader = ","

" Toggle nerdtree
nnoremap <leader>a :NERDTreeToggle<Cr>

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for coc gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

" Map Ctrl+c and Ctrl+j as Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" No arrow keys -- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Move single selected line
nmap <A-j> ]e
nmap <A-k> [e

" Move multiple selected lines
vmap <A-j> ]egv
vmap <A-k> [egv

" Improve hjkl-movement for soft wrapped rows
nnoremap j gj
nnoremap k gk

" Jump to start and end of line using the home row keys
map H ^
map L $

" Quick save
nmap <leader>w :w<CR>

" TODO: Clipboard
