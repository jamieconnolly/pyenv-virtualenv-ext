#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs pyenv-virtualenv-ext under $PREFIX.

set -e

cd "$(dirname "$0")"

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"
HOOKS_PATH="${PREFIX}/etc/pyenv.d"

mkdir -p "$BIN_PATH" "$HOOKS_PATH"

install -p bin/* "$BIN_PATH"
for hook in etc/pyenv.d/*; do
  if [ -d "$hook" ]; then
    cp -RPp "$hook" "$HOOKS_PATH"
  else
    install -p -m 0644 "$hook" "$HOOKS_PATH"
  fi
done
