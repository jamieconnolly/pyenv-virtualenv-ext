#!/usr/bin/env bats

load test_helper

setup() {
  export VERSION_NAME_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/version-name/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-virtualenv-name ": echo"

  run pyenv-version-name
  assert_success "system"

  unstub pyenv-virtualenv-name
}

@test "PYENV_VERSION has precedence over local" {
  stub pyenv-virtualenv-name ": echo \"foo\""
  create_version "2.7.10"
  create_virtualenv "2.7.11" "foo"

  run pyenv-version-name
  assert_success "foo"

  PYENV_VERSION="2.7.10" run pyenv-version-name
  assert_success "2.7.10"

  unstub pyenv-virtualenv-name
  remove_version "2.7.10"
  remove_virtualenv "2.7.11" "foo"
}
