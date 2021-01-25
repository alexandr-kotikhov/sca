#!/bin/bash

SCA_DIR=$(cd "$(dirname $0)"; pwd)

# shellcheck source=./sca_common.sh
source "${SCA_DIR}/sca_common.sh"

# execute an action via sca_runner.sh
# $1 - action: RUN/HELP
# $2 - script name
# it assigns SCRIPT_DIR and SCRIPT_FILE_NAME environment variables
function execute() {
  export SCRIPT_DIR=$(dirname "$2")
  export SCRIPT_FILE_NAME=$(basename "$2")
  "$SCA_DIR/sca_runner.sh" "$@"
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
    help "$@"
    return 0

  else
    scaWalk "${op}*" "^.+\.sh$"

    if [[ "${#sca_scripts[@]}" == "1" ]]; then
      execute RUN "${sca_scripts[0]}" "$@"

    elif [[ "${#sca_scripts[@]}" == "0" ]]; then
      echo "A script not defined."
      help "$@"

    else
      echo "An ambiguous selection of scripts."
      help "$@"

    fi

    return $?
  fi
}

process "$@"

