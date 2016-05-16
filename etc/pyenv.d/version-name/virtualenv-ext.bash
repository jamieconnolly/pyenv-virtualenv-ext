#!/usr/bin/env bash

if [ -z "$(printenv PYENV_VERSION)" ]; then
  PYENV_VERSION="$(pyenv-virtualenv-name)"
fi
