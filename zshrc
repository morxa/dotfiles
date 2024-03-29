# Path to your oh-my-zsh installation.
export ZSH=/home/$USER/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git notify)
plugins=(git docker pipenv)

# User configuration

bgnotify_threshold=5
bgnotify_when="always"

PATH="$HOME/go/bin:$HOME/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"

PATH="/usr/lib64/ccache:$PATH"
PATH=$PATH:$HOME/.npm/bin
PATH=$HOME/.local/bin:$PATH

CUDABINDIR="/usr/local/cuda-9.0/bin"
if [ -d "$CUDABINDIR" ] ; then
  export PATH="$CUDABINDIR:$PATH"
fi

#export GOPATH=$HOME/go

disable_ccache() {
  export CCACHE_DISABLE=1
}

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR=vim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
source ~/.aliases.sh

BEAR_FILE=compile_commands.json
function m () {
  if [ -e CMakeLists.txt ] || [ -e CMakeCache.txt ]  || [ -e CMakeFiles ] ; then
    USE_BEAR=0
  else
    USE_BEAR=1
    TOPDIR=$PWD
    while [[ "$TOPDIR" != / ]] ; do
      if [ -f $TOPDIR/$BEAR_FILE ] ; then
        BEAR_FILEPATH=$TOPDIR/$BEAR_FILE
        break
      fi
      TOPDIR=$(realpath $TOPDIR/..)
    done
    if [[ "$BEAR_FILEPATH" == "" ]] ; then
        echo "Could not find compile_commands.json anywhere in the tree."
        USE_BEAR=0
    fi
  fi
  if [[ "$USE_BEAR" == 1 ]] ; then
    echo "Using $BEAR_FILEPATH"
    bear --append --output $BEAR_FILEPATH -- make -j`nproc` -l`nproc` $@
  else
    make -j`nproc` -l`nproc` $@
  fi
  # 2>&1 | tee $TOPDIR/build.log
}

if [ "$XDG_SESSION_TYPE" = "x11" ] || [ "$XDG_SESSION_TYPE" = "wayland" ] ; then
  alias vim="vimx --servername vim"
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    export `gnome-keyring-daemon --start`
  fi
fi

# vim mode settings
bindkey -v
export KEYTIMEOUT=1
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

export LC_TIME=en_GB.UTF-8

VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source ~/.rosrc
source ~/.rcllrc

export ANSIBLE_STDOUT_CALLBACK=debug

export NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export MANPATH="$NPM_PACKAGES/share/man:${MANPATH:-$(manpath)}"

if command -v github-copilot-cli &> /dev/null
then
  eval "$(github-copilot-cli alias -- "$0")"
fi



#export READYLOG_PL=~/code/readylog/interpreter/
