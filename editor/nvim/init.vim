" --------------------------------------------
" # Plugins
" -------------------------------------------- 

" Use Plug as package manager
call plug#begin('~/.local/share/nvim/plugged')

  " Color schemes
  Plug 'imjasonmiller/vim-colors-github-primer' 
  Plug 'christianchiarulli/nvcode-color-schemes.vim'
  Plug 'shinchu/lightline-gruvbox.vim'

  " User interface enhancements
  Plug 'itchyny/lightline.vim'        " Improved status line
  Plug 'itchyny/vim-gitbranch'        " Current git branch in status line

  " Editor enhancements
  Plug 'tpope/vim-unimpaired'         " Useful bracket mappings
  Plug 'tpope/vim-commentary'         " Commenting using motions
  Plug 'tpope/vim-surround'           " Ease working with parentheses and others

  " Semantic language support
  Plug 'neovim/nvim-lspconfig'        " Common configurations
  Plug 'kabouzeid/nvim-lspinstall'    " Add :LspInstall <language> command
  Plug 'hrsh7th/nvim-cmp'             " Completion framework
  Plug 'hrsh7th/vim-vsnip'            " Snippet engine

  " Improve highlighting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " Completion sources for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'         
  Plug 'hrsh7th/cmp-vsnip'            
  Plug 'hrsh7th/cmp-path'             
  Plug 'hrsh7th/cmp-buffer'

  " Enable features of rust-analyzer, such as inlay hints and more
  Plug 'simrat39/rust-tools.nvim'

  " Extend interface for LSP
  Plug 'glepnir/lspsaga.nvim'

  " Syntactic language support
  Plug 'plasticboy/vim-markdown'
  Plug 'cespare/vim-toml' 
  Plug 'stephpy/vim-yaml' 
  Plug 'rust-lang/rust.vim'
  Plug 'ron-rs/ron.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'othree/html5.vim'
  Plug 'yuezk/vim-js'
  Plug 'cakebaker/scss-syntax.vim'
  Plug 'posva/vim-vue'
  Plug 'jparise/vim-graphql'
  Plug 'lervag/vimtex'

  " Fuzzy finder
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  " Git decorations
  Plug 'lewis6991/gitsigns.nvim'

call plug#end()

" --------------------------------------------
" # Editor settings
" --------------------------------------------

" Enable true-color
if (has("termguicolors"))
  " Allow true-color inside of tmux, see `:h xterm-true-color`
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

syntax enable

" colorscheme github_primer_dark
colorscheme gruvbox

" Set default encoding to UTF-8, but allow for Simplified Chinese
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" Indentation
filetype plugin indent on           " Load plugin files for filetypes
set shiftwidth=2                    " Auto-indentation of two spaces
set tabstop=2                       " Tab width of two spaces
set expandtab                       " Expand tabs to spaces

" Columns
set signcolumn=yes                  " Always draw sign column to prevent the buffer from moving 
set number relativenumber           " Relative line numbers

" Performance
set synmaxcol=500                   " Disable syntax highlighting on long lines
set lazyredraw                      " Disable updates during non-typed commands such as macros

" Improve status line
set laststatus=2                    " Always display the status line
set shortmess+=c                    " Do not display ins-completion messages

" Improve search
set incsearch                       " Show search pattern matches
set ignorecase                      " Ignore casing in searches
set smartcase                       " Override ignorecase if pattern contains uppercase
set gdefault                        " Substitute all matches on a line

" Wrapping
set formatoptions+=tc               " Wrap text and comments using textwidth
set formatoptions-=o                " Do not insert comment leader on pressing 'o' or 'O' in normal mode
set colorcolumn=80                  " Highlight long lines

set hidden                          " Do not unload a buffer when it is abandoned

set mouse=a                         " Enable mouse usage for all modes

set scrolloff=2                     " Minimum lines to keep above and below cursor

" Completion
set completeopt=noinsert,menuone,noselect
set inccommand=nosplit              " Incremental updates while performing substition

" Use the clipboard for all operations instead of using the `+` and/or `*` registers.
set clipboard+=unnamedplus

" Disable backups
set nobackup
set noswapfile
set nowritebackup

" --------------------------------------------
" # Lightline
" --------------------------------------------
lua << EOF
  require('gitsigns').setup()
EOF

function! LightlineGitbranch()
    let branch = get(b:, 'gitsigns_head', '')
    let status = get(b:, 'gitsigns_status', '')
    if len(status) > 0
        let status = " " . status
    endif
    return (winwidth(0) < 70 || branch == "") ? "" : " " . branch . status
endfunction

set noshowmode                      " Hide insert status
    " \ 'colorscheme': 'github_primer_dark',
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'LightlineGitbranch',
    \ },
\ }

" --------------------------------------------
" # Completion
" --------------------------------------------
"  Change highlight colors within LSPSaga diagnostics
hi DiagnosticHint         guifg=#586069
hi DiagnosticError        guifg=#E06C75
hi DiagnosticWarning 	    guifg=#E5C07B
hi DiagnosticInformation  guifg=#61AFEF
" Highlight colors for signs within column
hi LspDiagnosticsSignHint         guifg=#586069
hi LspDiagnosticsSignError        guifg=#E06C75
hi LspDiagnosticsSignWarning      guifg=#E5C07B
hi LspDiagnosticsSignInformation  guifg=#61AFEF

lua << EOF
-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "javascript", "typescript", "html", "css", "scss", "vue" },
  -- ignore_install = { "" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Disable the inlay diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

local function install_servers()
  local required_servers = { "css", "html", "typescript", "graphql", "vue", "tailwindcss" }
  local installed_servers = require'lspinstall'.installed_servers()

  for _, server in pairs(required_servers) do
    if not vim.tbl_contains(installed_servers, server) then
      require'lspinstall'.install_server(server)
    end
  end
end

-- Config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    -- Enable snippet support
    capabilities = capabilities,
    -- Map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

local function setup_servers()
  require'lspinstall'.setup()

  local servers = require'lspinstall'.installed_servers()

  for i, server in pairs(servers) do
    local config = make_config()

    -- Language server setup for Rust is handled by rust-tools 
    if server == "rust" then goto continue end

    require'lspconfig'[server].setup(config)

    ::continue::
  end
end

install_servers()
setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- The rust-tools plugin will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        runnables = {
          -- Whether to use a telescope for the selection menu
          use_telescope = true,
        },
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

local saga = require 'lspsaga'

saga.init_lsp_saga {
  -- error_sign = '●',
  error_sign = '■',
  warn_sign = '■',
  hint_sign = '■',
  infor_sign = '■',
  code_action_prompt = {
    sign = false
  },
}
EOF

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" --------------------------------------------
" # Autocommands
" --------------------------------------------

" Rust code style guidelines
au Filetype rust set colorcolumn=100

" Spell check in LaTeX and Markdown
set spelllang=nl,en_us
au FileType tex,markdown,text setlocal spell
 
" Highlighted yank
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}
augroup END

" No line numbers in terminal mode
au TermOpen * setlocal nonumber norelativenumber

" --------------------------------------------
" # Key mapping 
" --------------------------------------------

" Remap leader key to <space>
let mapleader = "\<Space>"

" Map <ctrl + c> and <ctrl + j> to <esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Disable arrow keys and force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Jump to start and end of line using the home row keys
map H ^
map L $

" Switch between current and previous buffer using <leader>
nnoremap <leader><leader> <C-^>

" Switch buffers using <left> and <right>
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Center search results
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Move a single selected line in normal mode using <alt + j> or <alt + k>
nmap <A-j> ]e
nmap <A-k> [e

" Move multiple selected lines in visual mode using <alt + j> or <alt + k>
vmap <A-j> ]egv
vmap <A-k> [egv

" Quick save
nmap <leader>w :w<CR>

" Code navigation
nnoremap <leader> rn    <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> K     <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gs    <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
nnoremap <leader> D     <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <leader>a     <cmd>lua require('lspsaga.codeaction').code_action()<CR>
" nnoremap <leader>e     <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <leader>e     <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent> g[    <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> g]    <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

" Telescope
nnoremap <leader>ff     <cmd>Telescope find_files<cr>
nnoremap <leader>fg     <cmd>Telescope live_grep<cr>
nnoremap <leader>fb     <cmd>Telescope buffers<cr>
nnoremap <leader>fh     <cmd>Telescope help_tags<cr>
