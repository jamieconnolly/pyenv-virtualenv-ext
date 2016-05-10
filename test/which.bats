#!/usr/bin/env bats

load test_helper

setup() {
  export WHICH_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/which/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtualenv selected" {
  stub pyenv-virtualenv-name ": echo"

  run pyenv-which foo
  assert_failure "pyenv: foo: command not found"

  unstub pyenv-virtualenv-name
}

@test "discovers version from pyenv-virtualenv-name" {
  stub pyenv-virtualenv-name ": echo \"foo\""
  create_virtualenv "2.7.11" "foo"
  create_executable "foo" "bar"

  run pyenv-which bar
  assert_success "${PYENV_ROOT}/versions/foo/bin/bar"

  unstub pyenv-virtualenv-name
  remove_virtualenv "2.7.11" "foo"
  remove_executable "foo" "bar"
}
