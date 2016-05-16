#!/usr/bin/env bats

load test_helper

setup() {
  export VERSION_NAME_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/version-name/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-version-file ": echo \"1\""
  stub pyenv-version-file-read "1 : echo \"2.7.11\""
  stub pyenv-virtualenv-name ": echo"
  create_version "2.7.11"

  run pyenv-version-name
  assert_success "2.7.11"

  unstub pyenv-version-file
  unstub pyenv-version-file-read
  unstub pyenv-virtualenv-name
  remove_version "2.7.11"
}

@test "PYENV_VERSION has precedence over local" {
  stub pyenv-version-file ": echo \"1\""
  stub pyenv-version-file-read "1 : echo \"2.7.10\""
  stub pyenv-virtualenv-name ": echo \"foo\""
  create_version "2.7.10"
  create_virtualenv "2.7.11" "foo"

  run pyenv-version-name
  assert_success "foo"

  PYENV_VERSION="2.7.10" run pyenv-version-name
  assert_success "2.7.10"

  unstub pyenv-version-file
  unstub pyenv-version-file-read
  unstub pyenv-virtualenv-name
  remove_version "2.7.10"
  remove_virtualenv "2.7.11" "foo"
}
