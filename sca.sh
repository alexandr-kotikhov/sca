#!/bin/bash

SCA_DIR=$(cd "$(dirname $0)"; pwd)

source "${SCA_DIR}/sca_common.sh"

function execute() {
  local ACTION=$1
  shift
  export SCRIPT_DIR=$(dirname "$1")
  export SCRIPT_FILE_NAME=$(basename "$1")
  "$SCA_DIR/sca_runner.sh" "$ACTION" "$@"
}

function help() {
  echo "Usages: sca SCRIPT COMMAND [arguments]"
  scaWalk "*" "^.+\.sh$"
  for i in ${sca_scripts[*]}; do
    execute "HELP" "$i" "$@"
  done
}


function process() {
  local op=$1
  shift

  if [[ "$op" == "" || "$op" == "help" ]]; then
    help "$*"
    return 0

  else
    scaWalk "${op}*" "^.+\.sh$"

    if [[ "${#sca_scripts[@]}" == "1" ]]; then
      execute RUN "${sca_scripts[0]}" "$*"

    elif [[ "${#sca_scripts[@]}" == "0" ]]; then
      echo "A script not defined."
      help "$*"

    else
      echo "An ambiguous selection of scripts."
      help "$*"

    fi

    return $?
  fi
}

process "$@"

