# Path to your oh-my-zsh installation.
export ZSH="/Users/jason/.oh-my-zsh"
# Neovim will not properly paste text without this, see:
# https://github.com/neovim/neovim/issues/5683
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export EDITOR=nvim

# Aliases
alias e="nvim"
alias cat="bat"
alias c="cargo"

# Fuzzy finder
FZF_DEFAULT_OPTS=
FZF_DEFAULT_OPTS+=" --height 20%"
FZF_DEFAULT_OPTS+=" --color=fg:#D1D5DA,bg:#24292E,hl:#B392F0"
FZF_DEFAULT_OPTS+=" --color=fg+:#D1D5DA,bg+:#24292E,hl+:#B392F0"
FZF_DEFAULT_OPTS+=" --color=info:#f7ca88,prompt:#ffcc99,pointer:#79B8FF"
FZF_DEFAULT_OPTS+=" --color=marker:#FFAB70,spinner:#9a86fd,header:#DBEDFF"
FZF_DEFAULT_OPTS+=" --no-mouse --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_DEFAULT_OPTS

FD_OPTIONS=" --follow --exclude node_modules --exclude .git"

export FZF_CTRL_T_COMMAND="fd --type file $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type directory $FD_OPTIONS"
export FZF_DEFAULT_COMMAND="fd --type file $FD_OPTIONS"

export BAT_PAGER="less -R"

# Colored man pages
man() {
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;34m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;92;49m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[04;35m' \
    command man "$@"
}

# Theme for bat
export BAT_THEME="base16"

# Show hidden files for tab completion
setopt globdots 

plugins=(
    git
    zsh-syntax-highlighting
)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

# Fast Node Manager
eval "$(fnm env)"

# Starship prompt
eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fnm
export PATH=/Users/jason/.fnm:$PATH
eval "`fnm env`"
