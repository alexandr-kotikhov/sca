#!/bin/bash

declare SCA_DIR=$(cd "$(dirname $0)"; pwd)
source "${SCA_DIR}/sca_common.sh"

# these functions can be substituted in the script connected via 'source' below
function run_before() {
  return 0
}

function run_after() {
  return 0
}

function process() {
  local action="$1"
  shift

  if [[ "$action" == "HELP" ]]; then
    scaScan "$1"
    scaHelp "$@"
  elif [[ "$action" == "RUN" ]]; then
    scaScan "$1"
    source "$1"
    shift
    scaExec "$@"
  elif [[ "$action" == "COMPLETION" ]]; then
    scaCompletionWords "$@"
  fi
}

process "$@"
