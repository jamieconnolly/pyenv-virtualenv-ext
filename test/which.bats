#!/usr/bin/env bats

load test_helper

setup() {
  export WHICH_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/which/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtualenv selected" {
  stub pyenv-hooks "virtualenv-name : echo"

  run pyenv-which foo
  assert_failure "pyenv: foo: command not found"

  unstub pyenv-hooks
}

@test "discovers version from pyenv-virtualenv-name" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""
  create_virtualenv "2.7.11" "foo"

  cat > ".python-venv" <<<"foo"
  run pyenv-which bar
  assert_success "${PYENV_ROOT}/versions/foo/bin/bar"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_virtualenv "2.7.11" "foo"
}

@test "PYENV_VERSION has precedence over local virtual environment" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""
  create_virtualenv "2.7.11" "foo"

  cat > ".python-venv" <<<"foo"
  run pyenv-which bar
  assert_success "${PYENV_ROOT}/versions/foo/bin/bar"

  PYENV_VERSION=2.7.11 run pyenv-which bar
  assert_success "${PYENV_ROOT}/versions/2.7.11/bin/bar"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_virtualenv "2.7.11" "foo"
}
