#!/bin/bash

declare SCA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

function _sca_completion() {
  wordlist=$("${SCA_DIR}/sca_runner.sh" COMPLETION "$COMP_CWORD" "${COMP_WORDS[*]}")
  COMPREPLY=($(compgen -W "$wordlist" -- "$2"))
  return 0
}

complete -F _sca_completion sca
alias sca="${SCA_DIR}/sca.sh"

