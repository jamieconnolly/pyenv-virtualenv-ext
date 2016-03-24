#!/usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"

if [ -n "$PYENV_VIRTUAL_ENV" ]; then
  PYENV_COMMAND_PATH="${PYENV_ROOT}/versions/${PYENV_VIRTUAL_ENV}/bin/${PYENV_COMMAND}"
fi
