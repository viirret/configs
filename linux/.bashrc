# .BASHRC

[[ $- != *i* ]] && return

if [ -f ~/configs/scripts/shell_aliases.sh ]; then
    source ~/configs/scripts/shell_aliases.sh
fi

export PS1=' \[\e[0;35m\]\u\e[0;36m-> \e[0;32m\w\e[0;37m '

# Set vi keys to terminal.
set -o vi

# mkdir + cd
mkcd() {
    mkdir $1
    cd $1
}

# history settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=1000

export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
