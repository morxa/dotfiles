# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH=$PATH:$HOME/.npm/bin
export PATH


#if [ -f `which powerline-daemon` ]; then
#  powerline-daemon -q
#  POWERLINE_BASH_CONTINUATION=1
#  POWERLINE_BASH_SELECT=1
#  . /usr/share/powerline/bash/powerline.sh
#fi

#GIT_PROMPT_ONLY_IN_REPO=1
if [[ -f ~/.bash-git-prompt/gitprompt.sh ]] ; then
  GIT_PROMPT_START="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
  source ~/.bash-git-prompt/gitprompt.sh
fi

#source ~/.rosrc
source ~/.rcllrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
