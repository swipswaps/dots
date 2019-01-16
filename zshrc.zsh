export ZSH=$HOME/.oh-my-zsh

if ! [ -d "$ZSH" ]; then
  echo "oh-my-zsh not present"
  return
fi

if ! type "micro" > /dev/null; then
  echo "micro not installed, using vim"
  export EDITOR='vim'
else
  export EDITOR='micro'
fi

if ! type "tmuxinator" > /dev/null; then
  echo "tmuxinator not installed, but is required"
fi

export ARCHFLAGS="-arch x86_64"

ZSH_THEME="gallois"

REQUIRED_ENV=()

for REQUIRED_ENV_I in $REQUIRED_ENV
do
  REQ=${(P)REQUIRED_ENV_I}
  if [ -z "$REQ" ]; then
    echo "Undefined variable: \$$REQUIRED_ENV_I"
  fi
done

plugins=(git git-extras python sudo systemd php composer node npm sudo symfony2 wd command-not-found docker tmux tmuxinator pip fedora dnf fabric jira last-working-dir mvn)

export PATH=$PATH:$RBENV/bin:${HOME}/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

source $ZSH/oh-my-zsh.sh

alias l="ls -lAFh --color=always --group-directories-first"

# Functions
function cd {
    builtin cd "$@" && l
}

function btafix {
	index=`pacmd list-cards | grep bluez_card -B1 | grep index | awk '{print $2}'`;
	# pacmd set-card-profile $index off;
	pacmd set-card-profile $index a2dp_sink;
}

set_term_title(){
   echo -en "\033]0;$1\a"
}

export JAVA_CMD=/usr/bin/java
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
source $HOME/.cargo/env
export PYENV_ROOT="$HOME/.pyenv-git"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
