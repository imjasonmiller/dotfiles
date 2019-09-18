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
Plug 'junegunn/fzf', {
    \ 'dir': '~/.fzf',
    \ 'do': './install --all'
    \ }
Plug 'junegunn/fzf.vim'                 " fuzzy finder

" Syntactic language support
Plug 'rust-lang/rust.vim'               " Rust
Plug 'HerringtonDarkholme/yats.vim'     " TypeScript
Plug 'cespare/vim-toml'                 " TOML
Plug 'lervag/vimtex'                    " LaTeX

call plug#end()

" Autocomplete and plugins
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-css',
    \ 'coc-rls',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-vimtex'
    \ ]
set completeopt=noinsert,menuone,noselect

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" Do not hijack the Enter key
inoremap <expr><Tab> (pumvisible() ? (empty(v:completed_item) ? "\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible() ? (empty(v:completed_item) ? "\<CR>\<CR>":"\<C-y>"):"\<CR>")

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Editor settings
filetype plugin indent on               " file type detection
set autoindent                          " auto-indent each line
set encoding=utf-8                      " enable utf-8 encoding
set scrolloff=2                         " minimum lines to keep above and below cursor
set mouse=a                             " enable mouse usage in terminal

" Spell check in LaTeX and Markdown
set spelllang=nl,en_us
autocmd FileType tex,markdown,text setlocal spell

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

" Show and highlight invisible characters
set nolist                              " hide by default, as they are toggled
set listchars=""                        " characters that will be shown
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:¬                   " non-breaking space
set listchars+=trail:•                  " trailing whitespace
hi WhiteSpace guifg=#C678DD             " purple color for characters

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

" Search with ripgrep
if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" Fuzzy finder
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Hide fuzzy finder status line
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Use 24-bit colors in vim/neovim
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Treat .svelte files as html
au! BufNewFile,BufRead *.svelte set ft=html

" Settings for vimtex
let g:vimtex_view_method = 'zathura'

" Avoid backups
set nowritebackup
set noswapfile
set nobackup

" Keyboard shortcuts
" Remap leader key to ,
let mapleader = "\<Space>"

" Toggle NERDtree
nnoremap <leader>a :NERDTreeToggle<Cr>

" Search with ripgrep
noremap <leader>s :Rg

" Fuzzy finder
nnoremap <silent> <leader>o :Files<CR>
nnoremap <silent> <leader>O :Files!<CR>
nnoremap <silent> <leader>` :Marks<CR>

" Toggle invisible characters
nnoremap <leader>t :set invlist<Cr>

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap keys for coc gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

" Switch between buffers using <leader>
nnoremap <leader><leader> <C-^>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

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

" Correct previous spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

set clipboard+=unnamedplus
