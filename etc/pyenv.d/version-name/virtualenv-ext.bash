#!/usr/bin/env bash

if [ -z "$(printenv PYENV_VERSION)" ]; then
  PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"
  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    PYENV_VERSION="$PYENV_VIRTUAL_ENV"
  fi
fi
