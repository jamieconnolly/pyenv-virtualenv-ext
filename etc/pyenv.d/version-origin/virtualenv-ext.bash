#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  PYENV_VIRTUAL_ENV_ORIGIN="$(pyenv-virtualenv-origin)"
  if [ -n "$PYENV_VIRTUAL_ENV_ORIGIN" ]; then
    PYENV_VERSION_ORIGIN="$PYENV_VIRTUAL_ENV_ORIGIN"
  fi
fi
