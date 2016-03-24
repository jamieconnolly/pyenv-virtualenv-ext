#!/usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

VIRTUALENV_FILE="$(pyenv-virtualenv-file "$PWD")"

if [ -e "$VIRTUALENV_FILE" ]; then
  VIRTUALENV="$(pyenv-version-file-read "$VIRTUALENV_FILE" || true)"

  if pyenv-virtualenv-prefix "$VIRTUALENV" 1>/dev/null 2>&1; then
    export PYENV_VERSION="$VIRTUALENV"
    PYENV_COMMAND_PATH="$(pyenv-which "$PYENV_COMMAND")"
    PYENV_BIN_PATH="${PYENV_COMMAND_PATH%/*}"
  fi
fi
