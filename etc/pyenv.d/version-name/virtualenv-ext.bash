#!/usr/bin/env bash

if [ -z "$(printenv PYENV_VERSION)" ]; then
  PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"
  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    PYENV_VIRTUAL_ENV_PREFIX="$(pyenv-virtualenv-prefix "$PYENV_VIRTUAL_ENV")"
    PYENV_VERSION="$(basename "$PYENV_VIRTUAL_ENV_PREFIX")"
  fi
fi
