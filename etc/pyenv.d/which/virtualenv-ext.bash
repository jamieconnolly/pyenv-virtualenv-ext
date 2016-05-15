#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"
  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    PYENV_COMMAND_PATH="${PYENV_ROOT}/versions/${PYENV_VIRTUAL_ENV}/bin/${PYENV_COMMAND}"
  fi
fi
