#!/usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"

if [ -n "$PYENV_VIRTUAL_ENV" ]; then
  export PYENV_VERSION="$PYENV_VIRTUAL_ENV"
  PYENV_COMMAND_PATH="$(pyenv-which "$PYENV_COMMAND")"
  PYENV_BIN_PATH="${PYENV_COMMAND_PATH%/*}"
fi
