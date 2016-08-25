#!/usr/bin/env bash

if [ -z "$PYENV_VERSION" ]; then
  PYENV_VIRTUAL_ENV="${PYENV_VIRTUAL_ENV:-$(pyenv-virtualenv-name 2>/dev/null || true)}"

  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    OLDIFS="$IFS"
    IFS=: PYENV_VERSION=($(pyenv-version-name))
    IFS="$OLDIFS"

    if [ "$PYENV_VERSION" = "system" ]; then
      PYENV_PREFIX="$(pyenv-prefix "$PYENV_VIRTUAL_ENV" 2>/dev/null || true)"
    else
      PYENV_PREFIX="$(pyenv-prefix "${PYENV_VERSION}/envs/${PYENV_VIRTUAL_ENV}" 2>/dev/null || true)"
    fi

    if [ -d "$PYENV_PREFIX" ]; then
      PYENV_COMMAND_PATH="${PYENV_PREFIX}/bin/${PYENV_COMMAND}"
    else
      echo "pyenv: \`$PYENV_VIRTUAL_ENV' is not a virtual environment (set by $(pyenv-virtualenv-origin))" >&2
      exit 1
    fi
  fi
fi
