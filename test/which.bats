#!/usr/bin/env bats

load test_helper

setup() {
  export WHICH_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/which/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  assert [ ! -d "${PYENV_ROOT}/versions" ]
  run pyenv-which py.test
  assert_failure "pyenv: py.test: command not found"
}

@test "PYENV_VERSION has precedence over virtual environment" {
  create_version "2.7.12"
  create_executable "2.7.12" "py.test"

  PYENV_VERSION=2.7.12 run pyenv-which py.test
  assert_success "${PYENV_ROOT}/versions/2.7.12/bin/py.test"

  create_virtualenv "3.5.2" "foo"
  create_executable "3.5.2" "foo" "py.test"
  stub pyenv-prefix "3.5.2/envs/foo : echo \"${PYENV_ROOT}/versions/3.5.2/envs/foo\""
  stub pyenv-version-name ": echo \"3.5.2\""
  stub pyenv-virtualenv-name ": echo \"foo\""

  run pyenv-which py.test
  assert_success "${PYENV_ROOT}/versions/3.5.2/envs/foo/bin/py.test"

  remove_version "2.7.12"
  remove_virtualenv "3.5.2" "foo"
  remove_executable "2.7.12" "py.test"
  remove_executable "3.5.2" "foo" "py.test"
  unstub pyenv-prefix
  unstub pyenv-version-name
  unstub pyenv-virtualenv-name
}

@test "PYENV_VIRTUAL_ENV has precedence over pyenv-virtualenv-name" {
  create_virtualenv "2.7.12" "bar"
  create_virtualenv "2.7.12" "foo"
  create_executable "2.7.12" "bar" "py.test"
  create_executable "2.7.12" "foo" "py.test"
  stub pyenv-prefix "2.7.12/envs/foo : echo \"${PYENV_ROOT}/versions/2.7.12/envs/foo\""
  stub pyenv-version-name ": echo \"2.7.12\""
  stub pyenv-virtualenv-name ": echo \"foo\""

  run pyenv-which py.test
  assert_success "${PYENV_ROOT}/versions/2.7.12/envs/foo/bin/py.test"

  stub pyenv-prefix "2.7.12/envs/bar : echo \"${PYENV_ROOT}/versions/2.7.12/envs/bar\""
  stub pyenv-version-name ": echo \"2.7.12\""

  PYENV_VIRTUAL_ENV=bar run pyenv-which py.test
  assert_success "${PYENV_ROOT}/versions/2.7.12/envs/bar/bin/py.test"

  remove_virtualenv "2.7.12" "bar"
  remove_virtualenv "2.7.12" "foo"
  remove_executable "2.7.12" "bar" "py.test"
  remove_executable "2.7.12" "foo" "py.test"
  unstub pyenv-prefix
  unstub pyenv-version-name
  unstub pyenv-virtualenv-name
}

@test "handles system-based virtual environment" {
  create_virtualenv "system" "foo"
  create_executable "system" "foo" "py.test"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  stub pyenv-version-name ": echo \"system\""
  stub pyenv-virtualenv-name ": echo \"foo\""

  run pyenv-which py.test
  assert_success "${PYENV_ROOT}/versions/foo/bin/py.test"

  remove_virtualenv "system" "foo"
  remove_executable "system" "foo" "py.test"
  unstub pyenv-prefix
  unstub pyenv-version-name
  unstub pyenv-virtualenv-name
}

@test "missing virtual environment" {
  create_virtualenv "2.7.12" "foo"
  create_executable "2.7.12" "foo" "py.test"
  stub pyenv-hooks "virtualenv-origin : echo"
  stub pyenv-version-name ": echo \"2.7.12\""

  PYENV_VIRTUAL_ENV=bar run pyenv-which py.test
  assert_failure "pyenv: \`bar' is not a virtual environment (set by PYENV_VIRTUAL_ENV environment variable)"

  remove_virtualenv "2.7.12" "foo"
  remove_executable "2.7.12" "foo" "py.test"
  unstub pyenv-hooks
  unstub pyenv-version-name
}
