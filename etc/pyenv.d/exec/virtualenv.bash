#!/usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"

if [ -n "$PYENV_VIRTUAL_ENV" ]; then
  export PYENV_VERSION="$PYENV_VIRTUAL_ENV"
fi
