alias dup="sudo dnf upgrade"

ANSIBLE_AI_ARGS='--ssh-extra-args="-i /home/till/.ssh/tim-aws-understand.pem" -u ubuntu -i ec2.py'
alias ansibleai="ansible $ANSIBLE_AI_ARGS"
alias plai="ansible-playbook $ANSIBLE_AI_ARGS"
FAWKESROOT=~/code/fawkes-robotino

function rb () {
  mosh robotino-base-$1
}

function rl () {
  mosh robotino-laptop-$1
}

function rll () {
  mosh robotino-laptop-local-$1
}

alias sg="~/code/fawkes-robotino/bin/skillgui"

alias xcc="xclip -selection clipboard"

FC=~/code/fawkes
FR=~/code/fawkes-robotino
FRC=~/code/fawkes-robotino/fawkes
alias cdfr="cd $FR"
alias cdfc="cd $FC"
alias cdfrc="cd $FRC"
alias cdcx="cd $FRC/src/plugins/clips-executive/clips"
alias cda="cd $FR/src/clips-specs/rcll/"
alias cdg="cd $FRC/src/plugins/gologpp/"
alias cdcg="cd $FC/src/plugins/gologpp/"
alias gk="./gazsim.bash -x kill"
alias kf='pass Fedora/fas | kinit thofmann@FEDORAPROJECT.ORG'
alias dnfqraw='dnf repoquery --repo=rawhide'
alias ssh="TERM=linux ssh"

function gitcleanbranches ()
{
  local main_branch
  git rev-parse --verify -q main
  if [ $? -eq 0 ] ; then
    main_branch=main
  else
    main_branch=master
  fi
  git rev-parse --verify -q $main_branch
  if [ $? -ne 0 ] ; then
    echo "Failed to get main branch, neither 'master' nor 'main' is valid" >&2
    return 1
  fi
  for b in $(git branch --merged $main_branch | grep -vw "$main_branch\$" | grep -vw '^*') ; do
    git branch -d $b
  done
}

function gitpn ()
{
  local_branch=$(git symbolic-ref --short -q HEAD)
  git push --set-upstream origin ${local_branch}:thofmann/${local_branch}
}

alias v=vim

function xrun ()
{
  if [[ "$XDG_SESSION_TYPE" == "wayland" ]] ; then
    GDK_BACKEND=x11 \
      QT_QPA_PLATFORM=xcb \
      SDL_VIDEODRIVER=x11 \
      _JAVA_AWT_WM_NONREPARENTING=1 \
      WINIT_UNIX_BACKEND=x11 \
      SDL_VIDEODRIVER=wayland \
      $@
  else
    $@
  fi
}

alias rviz="xrun rviz"

function rv () {
  ROS_MASTER_URI=http://robotino-base-$1:11311/ rviz
}

function vnc () {
  ssh kirk.kbsg.rwth-aachen.de wakemachine $1 || (echo "Failed to wake $1"; exit 1)
  ret=1
  while [ $ret -ne 0 ] ; do ping -q -c 1 $1; ret=$?; sleep 1; done
  ssh $1 startvnc.bash
  vncviewer -via $1 $1:${2-1105}
}

compdef vnc=ssh

function restart () {
  local TARGETHOST="$1"
  local SUDO=""
  local SSHUSER=""
  if [ $# -eq 2 ] ; then
    if  [ "$1" = "--sudo" ] ; then
      SUDO="sudo"
      TARGETHOST="$2"
    else
      echo "Usage: restart [--sudo] <host>" >&2
      return 1
    fi
  elif [ $# -ne 1 ] ; then
    echo "Usage: restart [--sudo] <host>" >&2
    return 1
  else
    SSHUSER="root"
  fi
  local FQDN=$TARGETHOST
  local TAILSCALE_HOST="$TARGETHOST.tailnet-d0ca.ts.net"
  if [ "$TARGETHOST" != "elefant" ] ; then
    FQDN="$TARGETHOST.fritz.box"
  fi
  echo "Restarting $TARGETHOST ..."
  local USERARGS="${SSHUSER:+$SSHUSER@}"
  ssh ${USERARGS}$TAILSCALE_HOST shutdown -r || (echo "Failed to restart $TARGETHOST"; return 1)
  echo "Waiting for $TARGETHOST to be online"
  run_and_notify.bash --fail-first ssh ${USERARGS}$FQDN /bin/true
  echo "Unlocking LUKS drive"
  pass machines/$TARGETHOST/luks | ssh ${USERARGS}$FQDN systemd-tty-ask-password-agent || (echo "Failed to unlock LUKS drive"; return 1)
  run_and_notify.bash ssh ${USERARGS}$TAILSCALE_HOST /bin/true
}

compdef restart=ssh
