#!/bin/bash
export ZSH=$HOME/.oh-my-zsh

# alias
alias e="nvim"

alias cat="bat"

alias c="cargo"

alias figma-linux="GDK_BACKEND=x11 figma-linux"

# Take a note
alias note="nvim $(date +~/docs/notes/%Y/%Y-%m-%d.md)"

# fuzzy finder
FZF_DEFAULT_OPTS=
FZF_DEFAULT_OPTS+=" --height 20%"
FZF_DEFAULT_OPTS+=" --color=fg:#a4a1b5,bg:#2a2734,hl:#ffcc99"
FZF_DEFAULT_OPTS+=" --color=fg+:#a4a1b5,bg+:#2a2734,hl+:#ffcc99"
FZF_DEFAULT_OPTS+=" --color=info:#9a86fd,prompt:#ffcc99,pointer:#c678dd"
FZF_DEFAULT_OPTS+=" --color=marker:#f8fafd,spinner:#9a86fd,header:#f3f4f6"
FZF_DEFAULT_OPTS+=" --no-mouse --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_DEFAULT_OPTS

FD_OPTIONS=" --follow --exclude node_modules --exclude .git"

export FZF_CTRL_T_COMMAND="fd --type file $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type directory $FD_OPTIONS"
export FZF_DEFAULT_COMMAND="fd --type file $FD_OPTIONS"

# colored man pages in one dark theme
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

# bat theme
export BAT_THEME="TwoDark"

# show hidden files for tab completion
setopt globdots 

plugins=(
    git
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# Set locale
# Prevents repeating command characters in zsh
# https://unix.stackexchange.com/q/90772  
export LC_CTYPE=en_US.UTF-8

# fzf fuzzy find
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Greeting
# OS
echo -e "$(uname -ro | awk '{ print "\\e[1mOS: \\e[0;32m"$0"\\e[0m"}')"
# Uptime
echo -e "$(uptime -p | sed 's/^up //' | awk '{ print "\\e[1mUptime: \\e[0;32m"$0"\\e[0m" }')"
# Hostname
echo -e "$(uname -n | awk '{ print "\\e[1mHostname: \\e[0;32m"$0"\\e[0m" }')"
# Disk usage
echo -e "\\e[1mDisk usage:\\e[0m"
echo ""
echo -ne "$(
    df -l -h | grep -E 'dev/(sda)' |
    awk '{ printf "\\t%s\\t%4s /%4s  %s\\n\\n", $6, $3, $2, $5 }' |
    sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\e[0;31m\1\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\e[0;33m\1\\e[0m/' |
    paste -sd ''
)"
echo ""

function todo_prompt() {
    # Random number between 0-10
    r=$(( ( RANDOM % 100 ) + 1 ))

    if [[ -s ~/todo ]]; then
        sort -bnk 2 -t ';' ~/todo | 
        while IFS=';' read -r -A line; do
            if [[ $r -lt ${line[2]} ]]; then
                if [[ ${line[2]} -le 100 ]]; then
                    echo -ne "\\e[0;31m"
                fi

                if [[ ${line[2]} -lt 80 ]]; then
                    echo -ne "\\e[0;33m"
                fi

                if [[ ${line[2]} -lt 75 ]]; then
                    echo -ne "\\e[0;32m"
                fi

                if [[ ${line[2]} -lt 50 ]]; then
                    echo -ne "\\e[0;36m"
                fi

                echo -e "[${line[1]}] $( echo $line[3] | xargs)\e[0m"
            fi
        done
    fi
}

# precmd() {
    todo_prompt
# }

# Theme
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jason/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jason/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jason/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jason/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

