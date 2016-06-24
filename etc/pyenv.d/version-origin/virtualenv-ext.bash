#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  if pyenv-virtualenv-name &>/dev/null; then
    PYENV_VIRTUAL_ENV_ORIGIN="$(pyenv-virtualenv-origin || true)"
    if [ -n "$PYENV_VIRTUAL_ENV_ORIGIN" ]; then
      PYENV_VERSION_ORIGIN="$PYENV_VIRTUAL_ENV_ORIGIN"
    fi
  fi
fi
