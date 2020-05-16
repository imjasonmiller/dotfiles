set shell=/bin/bash

" Plugins
call plug#begin('~/.local/share/nvim/plugged')

" Theme
Plug '~/work/2020/vim-colors-github'

" Gui enhancements
Plug 'itchyny/lightline.vim'            " improved status line
Plug 'itchyny/vim-gitbranch'            " current git branch in status line
Plug 'machakann/vim-highlightedyank'    " highlight lines while yanking

" Editor enhancements
Plug 'editorconfig/editorconfig-vim'    " consistent code style across editors
Plug 'tpope/vim-unimpaired'             " move lines of code around using alt+j/k
Plug 'airblade/vim-rooter'              " set working directory to project root

" Semantic language support
Plug 'airblade/vim-gitgutter'           " show git changes in the sign column

" Completion plugins
Plug 'neoclide/coc.nvim', {
    \ 'branch': 'release'
    \ }                                 " intellisense engine for vim8/neovim
Plug 'tpope/vim-surround'               " easily delete, change and add pairs.
Plug 'jiangmiao/auto-pairs'             " auto close pairs
Plug 'scrooloose/nerdcommenter'         " improve commenting of code
Plug 'junegunn/fzf', {
    \ 'dir': '~/.fzf',
    \ 'do': './install --all'
    \ }
Plug 'junegunn/fzf.vim'                 " fuzzy finder
Plug 'godlygeek/tabular'                " align text

" Syntactic language support
Plug 'rust-lang/rust.vim'               " rust
" Plug 'arzg/vim-rust-syntax-ext'         " rust extended
Plug 'pangloss/vim-javascript'          " javascript
Plug 'leafgarland/typescript-vim'       " typescript
Plug 'maxmellon/vim-jsx-pretty'         " jsx for javascript and typescript
Plug 'jparise/vim-graphql'              " graphql
Plug 'StanAngeloff/php.vim'             " php
Plug 'plasticboy/vim-markdown'          " markdown
Plug 'cespare/vim-toml'                 " toml
Plug 'lervag/vimtex'                    " latex
Plug 'ron-rs/ron.vim'                   " rust object notation
Plug 'cstrahan/vim-capnp'               " cap'n proto

" Tools for plugin development
Plug 'tpope/vim-scriptease'

call plug#end()

" Regular regular expressions
source ~/.config/nvim/regex.vim

" Autocomplete and plugins
let g:coc_global_extensions = [
    \ 'coc-explorer',
    \ 'coc-tsserver',
    \ 'coc-css',
    \ 'coc-rust-analyzer',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-vimtex'
    \ ]

set completeopt=noinsert,menuone,noselect

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
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set encoding=utf-8                      " enable utf-8 encoding
set scrolloff=2                         " minimum lines to keep above and below cursor
set hidden                              " do not unload buffer after switching 
set mouse=a                             " enable mouse usage in terminal

" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Wrapping options
set formatoptions=tc                    " wrap text and comments using textwidth
set formatoptions+=r                    " continue comments on enter in insert mode
set formatoptions+=q                    " enable formatting of comments with gq
set formatoptions+=n                    " detect lists for formatting
set formatoptions+=b                    " auto-wrap in insert mode, do not wrap old long lines
set formatoptions-=o                    " do not insert comment leader on 'o' from normal mode 

" Improve search
set incsearch                           " show pattern matches
set ignorecase                          " ignore cases in term
set smartcase                           " override ignorecase if term contains uppercase
set gdefault                            " substitute all matches in a line

" Spell check in LaTeX and Markdown
set spelllang=nl,en_us
au FileType tex,markdown,text setlocal spell

" Rust code style guidelines
au Filetype rust set colorcolumn=100

" Default indentation
set shiftwidth=4                        " spaces to auto-indent
set tabstop=4                           " tab width of 4 spaces
set expandtab                           " expand tabs to spaces

" GUI settings
if (has("termguicolors"))
    set termguicolors               " Use 24-bit colors in vim/neovim
endif

set termguicolors                                                                                                                                                                                         
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"                                                                                                                                                                    
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"  

let g:github_colors_soft = 1
let g:github_colors_extra_functions = 1

colorscheme github-dark
syntax on                               " syntax highlighting
set synmaxcol=500                       " no syntax highlight on long lines for perf.
set ttyfast                             " indicate a fast terminal connection
set lazyredraw                          " reduce updates while not typing
set laststatus=2                        " always show the status line
set nofoldenable                        " disable code folding
set shortmess+=c                        " suppress 'match x of y' messages
set number relativenumber               " hybrid relative line numbers
set colorcolumn=80                      " hightlight long lines

" Show and highlight invisible characters
set nolist                              " hide by default, as they are toggled
set listchars=""                        " characters that will be shown
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:¬                   " non-breaking space
set listchars+=trail:•                  " trailing whitespace
hi WhiteSpace guifg=#C678DD             " purple color for characters

" Debugger for Rust
packadd! termdebug
let g:termdebug_wide=1
let g:termdebugger="rust-gdb"
hi debugBreakpoint term=reverse guifg=#212734 guibg=#FFAD5C
hi debugPC term=reverse guibg=#545167

" Change cursor and add incremental commands
if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit 
end

" Change highlight colors for coc
hi CocErrorSign         guifg=#E06C75
hi CocWarningSign       guifg=#E5C07B
hi CocInfoSign          guifg=#61AFEF
hi CocHintSign          guifg=#98C379
hi CocRustChainingHint  guifg=#54595f

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" React comment support for .tsx and .jsx files
let g:NERDCustomDelimiters = {
  \ 'javascript.jsx': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
  \ 'typescript.tsx': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' }
  \ }

" Lightline
set noshowmode                          " hide insert status
let g:lightline = {
    \ 'colorscheme': 'github_dark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name',
    \   'cocstatus': 'coc#status'
    \ },
    \ 'component_type': {
    \   'coc_error'        : 'error',
    \   'coc_warning'      : 'warning',
    \   'coc_info'         : 'tabsel',
    \   'coc_hint'         : 'middle',
    \   'coc_fix'          : 'middle',
    \ },
    \ 'component_expand': {
    \   'coc_error'        : 'LightlineCocErrors',
    \   'coc_warning'      : 'LightlineCocWarnings',
    \   'coc_info'         : 'LightlineCocInfos',
    \   'coc_hint'         : 'LightlineCocHints',
    \   'coc_fix'          : 'LightlineCocFixes',
    \ },
\ }

" function! s:lightline_coc_diagnostic(kind, sign) abort
  " let info = get(b:, 'coc_diagnostic_info', 0)
  " " coc#util#get_config('diagnostic').warningSign
  " if empty(info) || get(info, a:kind, 0) == 0
    " return ''
  " endif
  " try
    " let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
  " catch
    " let s = ''
  " endtry
  " return printf('%s %d', s, info[a:kind])
" endfunction
function! s:lightline_coc_diagnostic(kind, sign) abort
    let info = get(b:, 'coc_diagnostic_info', 0)
    if empty(info) || get(info, a:kind, 0) == 0
        return ''
    endif
    return printf('%s %d', a:sign, info[a:kind])
endfunction

function! LightlineCocErrors() abort
  return s:lightline_coc_diagnostic('error', '●')
endfunction

function! LightlineCocWarnings() abort
  return s:lightline_coc_diagnostic('warning', '●')
endfunction

function! LightlineCocInfos() abort
  return s:lightline_coc_diagnostic('information', '●')
endfunction

function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', '●')
endfunction
\ }

autocmd User CocDiagnosticChange call lightline#update()

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

" Add preview for fzf
command! -bang -nargs=? -complete=dir FzfFiles
    \ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)

" Use ripgrep for fzf:
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

" Hide fuzzy finder status line
au! FileType fzf
au  FileType fzf set laststatus=0 noshowmode noruler
  \| au BufLeave <buffer> set laststatus=2 showmode ruler


" Markdown options
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1

" Treat .svelte files as html
au! BufNewFile,BufRead *.svelte set ft=html

" Syntax highlight support for React with JavaScript or TypeScript 
au! BufNewFile,BufRead *.jsx set ft=javascript.jsx
au! BufNewFile,BufRead *.tsx set ft=typescript.tsx

" Settings for vimtex
let g:vimtex_view_method = 'zathura'

" Avoid backups
set nowritebackup
set noswapfile
set nobackup

" Keyboard shortcuts
" Remap leader key to ,
let mapleader = "\<Space>"

" Preserve selection when (de)indenting in visual mode
vnoremap > >gv
vnoremap < <gv

" Do not hijack the Enter key
inoremap <expr><Tab> (pumvisible() ? (empty(v:completed_item) ? "\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible() ? (empty(v:completed_item) ? "\<CR>\<CR>":"\<C-y>"):"\<CR>")

" Debugging
nmap <leader>dd :Termdebug<space>
nmap <silent> <leader>dD :call TermDebugSendCommand('quit')<cr>:Gdb<cr>y<cr>
nmap <leader>dr :Run<cr>
nmap <leader>dR :Stop<cr>
nmap <leader>db :Break<cr>
nmap <leader>dB :Clear<cr>
nmap <leader>ds :Step<cr>
nmap <leader>dn :Over<cr>
nmap <leader>df :Finish<cr>
nmap <leader>dc :Continue<cr>
nmap <leader>dp :Evaluate<cr>
nmap <leader>de :Evaluate<space>
nmap <leader>dl :call TermDebugSendCommand('info locals')<cr>
nmap <leader>da :call TermDebugSendCommand('info args')<cr>

" Toggle NERDtree
nnoremap <leader>a :NERDTreeToggle<Cr>
nnoremap <leader>pv :NERDTreeFind<CR>
nmap <leader>e :CocCommand explorer<CR>

" Search with ripgrep
noremap <leader>s :Rg<Space>

" Fuzzy finder
nnoremap <silent> <leader>o :Files<CR>
nnoremap <silent> <leader>O :Files!<CR>
nnoremap <silent> <leader>` :Marks<CR>
nmap <leader>; :Buffers<CR>

" Align search result to middle of page
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Toggle whitespace characters
nnoremap <leader>t :set invlist<Cr>

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Go-to's 
nmap <silent> ga <Plug>(coc-codeaction)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
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
" https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Jump to start and end of line using the home row keys
map H ^
map L $

" Quick save
nmap <leader>w :w<CR>

" Correct previous spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Quit all
noremap <C-q> :confirm qall<CR>

let g:clipboard = {
    \ 'name': 'wayland',
    \ 'copy': {
        \ '+': 'wl-copy --type text/plain',
        \ '*': 'wl-copy --type text/plain --primary',
    \ },
    \ 'paste': {
        \ '+': {-> systemlist('wl-paste | tr -d "\r"')}, 
        \ '*': {-> systemlist('wl-paste --primary | tr -d "\r"')},
    \ },
\ }

set clipboard=unnamedplus

