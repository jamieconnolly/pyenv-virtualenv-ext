#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  PYENV_VERSION_ORIGIN="$(pyenv-virtualenv-origin)"
fi
