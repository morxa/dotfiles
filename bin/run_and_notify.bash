#! /bin/bash
#
# run_and_notify.bash
# Copyright (C) 2021 Till Hofmann <hofmann@kbsg.rwth-aachen.de>
#
# Distributed under terms of the MIT license.
#

set -e
set -u
set -o pipefail

ARGS=$(getopt --options '+h,1' --longoptions 'fail-first,help,no-retry' -- "$@")

eval set -- "$ARGS"
unset ARGS

FAIL_FIRST=false
RETRY=true

usage () {
  echo "
  Usage: $0 [-h|--help] [--fail-first] [-1|--no-retry] <command>

  Run a command repeatedly and send a notification when it succeeds.

  Example:
    \$ $0 ping -c 1 google.com
  This will ping google.com until it reaches the host and then send a notification.

  This is especially useful when you reboot a host and want to wait until it has rebooted:
    \$ ssh target.example.com shutdown -r
    \$ $0 --fail-first ping -c 1 target.example.com

  optional arguments:
    -h, --help   show this help message and exit
    --fail-first first run the command until it fails, then continue until it succeeds.
    -1,--no-retry Only run the command once.
  "
}

while true; do
  case "$1" in
    '-h'|'--help')
      usage
      exit 0
      ;;
    '--fail-first')
      FAIL_FIRST=true
      shift
      continue
      ;;
    '-1'|'--no-retry')
      RETRY=false
      shift
      continue
      ;;
    '--')
      shift
      break
      ;;
    *)
      echo 'Error parsing arguments!' >&2
      exit 1
      ;;
  esac
done

echo "Running $@"
ret=0
$@ || ret=1
echo; echo

if $FAIL_FIRST ; then
  echo "Waiting for the command to fail."
  echo; echo
  while [ $ret -eq 0 ] ; do
    sleep 1
    ret=0
    $@ || ret=1
  done
fi

echo "Waiting for the command to succeed."
echo; echo

while $RETRY && [[ $ret -ne 0 ]] ; do
  sleep 1
  ret=0
  $@ || ret=1
done

if [[ $ret -eq 0 ]] ; then
  notify-send "Command succeeded" "$*"
else
  notify-send "Command failed" "$*"
fi
