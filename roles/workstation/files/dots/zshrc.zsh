export ZSH=~/.oh-my-zsh

if ! [ -d "$ZSH" ]; then
  echo "oh-my-zsh not present"
  return
fi

if ! type "micro" > /dev/null; then
  export EDITOR='vim'
else
  export EDITOR='micro'
fi

export VISUAL=$EDITOR

ZSH_THEME="gallois"

plugins=(git git-extras python pip pipenv sudo systemd wd command-not-found zsh-interactive-cd)

export PATH=${HOME}/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

source $ZSH/oh-my-zsh.sh

alias l="ls -lAFh --color=always --group-directories-first"

# Functions
function cd {
    builtin cd "$@" && l
}

set_term_title(){
   echo -en "\033]0;$1\a"
}

eval "$(bw completion --shell zsh); compdef _bw bw;"

if [[ $UID == 0 || $EUID == 0 ]]; then
  export PS1="%{$fg[cyan]%}[%~% ]%{$FG[202]%}[root]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b "
fi
