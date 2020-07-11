export ZSH=/opt/oh-my-zsh

if ! [ -d "$ZSH" ]; then
  echo "oh-my-zsh not present"
  return
fi

if ! type "micro" > /dev/null; then
  export EDITOR='vim'
else
  export EDITOR='micro'
fi

export ARCHFLAGS="-arch x86_64"

ZSH_THEME="gallois"

plugins=(git git-extras python sudo systemd wd command-not-found last-working-dir)

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
