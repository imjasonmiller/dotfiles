" Plugins
call plug#begin('~/.local/share/nvim/plugged')

" Theme
Plug 'joshdick/onedark.vim'             " one dark theme

" Gui enhancements
Plug 'w0rp/ale'                         " check syntax and lint
Plug 'itchyny/lightline.vim'            " improved status line
Plug 'machakann/vim-highlightedyank'    " highlight lines while yanking

" Editor enhancements
Plug 'scrooloose/nerdtree'              " File browser
Plug 'tpope/vim-unimpaired'             " move lines of code around using alt+j/k

" Semantic language support
Plug 'ncm2/ncm2'                        " autocompletion
Plug 'roxma/nvim-yarp'                  " remote plugin framework required by ncm2
Plug 'airblade/vim-gitgutter'           " show git changes in the sign column

" Completion plugins
Plug 'ncm2/ncm2-bufword'                " autocomplete words from current buffer
Plug 'ncm2/ncm2-path'                   " filepath completion
Plug 'jiangmiao/auto-pairs'             " auto close parens, braces and brackets
Plug 'scrooloose/nerdcommenter'         " easy commenting of code

" Syntactic language support
Plug 'rust-lang/rust.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

call plug#end()

" Change cursor and add incremental commands
if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end

" Linter (only on save)
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 1
let g:ale_rust_rls_config = {
    \ 'rust': {
        \ 'all_targets': 1,
        \ 'build_on_save': 1,
        \ 'clippy_preference': 'on'
    \ }
\ }
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_linters = {'rust': ['rls']}
highlight link ALEWarningSign Todo
highlight link ALEErrorSign WarningMsg
highlight link ALEVirtualTextWarning Todo
highlight link ALEVirtualTextInfo Todo
highlight link ALEVirtualTextError WarningMsg
highlight ALEError guibg=none
highlight ALEWarning guibg=none
let g:ale_sign_warning = "●"
let g:ale_sign_error = "●"
let g:ale_sign_info = "●"
let g:ale_sign_hint = "●"

nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" Autocomplete
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" Do not hijack the Enter key
inoremap <expr><Tab> (pumvisible() ? (empty(v:completed_item) ? "\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible() ? (empty(v:completed_item) ? "\<CR>\<CR>":"\<C-y>"):"\<CR>")

" Editor settings
filetype plugin indent on               " file type detection
set autoindent                          " auto-indent each line
set encoding=utf-8                      " enable utf-8 encoding
set scrolloff=2                         " minimum lines to keep above and below cursor

" Default indentation
set shiftwidth=4                        " 
set tabstop=4                           " tab width of 4 spaces
set expandtab                           " expand tabs to space

" GUI settings
syntax on                               " syntax highlighting
set synmaxcol=500                       " no syntax highlight on long lines for perf.
colorscheme onedark                     " onedark color scheme
set ttyfast                             " indicate a fast terminal connection
set lazyredraw                          " reduce updates while not typing
set laststatus=2                        " always show the status line
set cursorline                          " highlight the current line
hi normal guibg=none ctermbg=none       " transparent background
set shortmess+=c                        " suppress 'match x of y' messages

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

" Keyboard shortcuts
" Remap leader key to ,
let mapleader = ","

" Toggle nerdtree
nnoremap <leader>a :NERDTreeToggle<Cr>

" Ctrl+c and Ctrl+j as Esc
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

" Move single lines
nmap <A-j> [e
nmap <A-k> ]e

" Move multiple lines selected
vmap <A-j> [egv
vmap <A-k> ]egv

" Vertical movement by screen lines
nnoremap j gj
nnoremap k gk

" Jump to start and end of line using the home row keys
map H ^
map L $

" Quick save
nmap <leader>w :w<CR>

" TODO: Clipboard

