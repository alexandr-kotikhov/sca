#!/bin/bash

declare -A sca_commands=()
declare -a sca_scripts=()

function logErr() {
  echo "$*" >&2
}

function scaScan() {
  local prev
  local cmd
  local description
  readonly file="$1"
  while IFS="" read -r line || [ -n "$line" ]; do
    if [[ $line == "function "* ]]; then # start with 'function'
      cmd=$(echo "$line" | sed -En 's/function\s+cmd_(\w+)\(\).*/\1/p')
      if [[ ! "$cmd" == "" ]]; then
        if [[ "$prev" == "## "* ]]; then
          description="${prev:2}"
        else
          description=""
        fi
        sca_commands["$cmd"]="$description"
      fi
    fi
    prev="$line"
  done < "$file"
}

function scaHelp() {
  readonly file_name=$(basename "$1")
  for i in ${!sca_commands[*]}; do
    printf "%-s %-25s %-60s\n" "${file_name}" $i "${sca_commands["$i"]}"
  done
}

function scaExec() {
  local op="$1"
  shift

  local matches=()
  for i in ${!sca_commands[*]}; do
    if [[ "$i" == "$op"* ]]; then
      matches+=("$i")
    fi
  done

  if [[ "${#matches[@]}" == "1" ]]; then
    local cmd="cmd_${matches[0]}"
    run_before
    $cmd "$@"
    run_after

  elif [[ "${#matches[@]}" == "0" ]]; then
    if [[ "$op" == "help" ]]; then
      scaHelp ""
    else
      logErr "Нет такой команды '$op'"
      scaHelp ""
    fi

  else
    logErr "Возможны несколько команд, уточните."
    scaHelp "$op"

  fi
}

function scaTake() {
  if [ -d "$1/.sca" ]; then
    while read -r i; do
      local name=$(basename "$i")
      # skip not a scripts
      if [[ "$name" =~ ^[[:alnum:]]+$ ]]; then
        sca_scripts+=("$i")
      fi
    done <<< $(find "$1/.sca" -type f -iname "$2")
  fi
}

function scaWalk() {
  local dir=$(pwd)
  sca_scripts=()
  while [[ ! "${dir}" == "/" && ! "${dir}" == "$HOME" ]]; do
    scaTake "${dir}" "$1"
    dir=$(dirname "${dir}")
  done
  scaTake "$HOME" "$1"
}


function scaCompletionWords() {
  declare -i -r COMP_CWORD=$1
  shift
  declare -a -r COMP_WORDS=($@)

  if [ ${COMP_CWORD} -eq 1 ]; then
    scaWalk "*"
    declare arr=()
    for i in ${sca_scripts[*]}; do
      arr+=("$(basename "$i")")
    done
    echo -n "${arr[*]}"

  elif [ ${COMP_CWORD} -eq 2 ]; then
    scaWalk "${COMP_WORDS[1]}*"
    if [ ${#sca_scripts[@]} -eq 1 ]; then
      scaScan "${sca_scripts[0]}"
      echo -n "${!sca_commands[*]}"
    fi

  else
    return 0

  fi
  echo -n " help"

}