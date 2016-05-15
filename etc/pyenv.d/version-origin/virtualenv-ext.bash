#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  PYENV_VIRTUAL_ENV="$(pyenv-virtualenv-name)"
  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    PYENV_VERSION_ORIGIN="\`$PYENV_VIRTUAL_ENV' virtual environment"
  fi
fi
