#!/usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

find_local_virtualenv_file() {
  local root="$1"
  while ! [[ "$root" =~ ^//[^/]*$ ]]; do
    if [ -e "${root}/.python-venv" ]; then
      echo "${root}/.python-venv"
      return 0
    fi
    [ -n "$root" ] || break
    root="${root%/*}"
  done
  return 1
}

VIRTUALENV_FILE="$(find_local_virtualenv_file "$PWD")"

if [ -e "$VIRTUALENV_FILE" ]; then
  VIRTUALENV="$(pyenv-version-file-read "$VIRTUALENV_FILE" || true)"

  if pyenv-virtualenv-prefix "$VIRTUALENV" 1>/dev/null 2>&1; then
    export PYENV_VERSION="$VIRTUALENV"
    PYENV_COMMAND_PATH="$(pyenv-which "$PYENV_COMMAND")"
    PYENV_BIN_PATH="${PYENV_COMMAND_PATH%/*}"
  fi
fi
