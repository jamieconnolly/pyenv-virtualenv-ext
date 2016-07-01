#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  stub pyenv-help "--usage virtualenv-file-write : echo \"Usage: pyenv virtualenv-file-write <file> <virtualenv>\""

  run pyenv-virtualenv-file-write
  assert_failure "Usage: pyenv virtualenv-file-write <file> <virtualenv>"

  unstub pyenv-help

  run pyenv-virtualenv-file-write "one" ""
  assert_failure
}

@test "setting nonexistent virtual environment fails" {
  stub pyenv-version-name ": echo \"2.7.12:3.5.2\""
  stub pyenv-virtualenv-prefix "2.7.12/envs/foo : false"

  assert [ ! -e ".python-venv" ]
  run pyenv-virtualenv-file-write ".python-venv" "foo"
  assert_failure
  assert [ ! -e ".python-venv" ]

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "writes value to arbitrary file" {
  create_virtualenv "2.7.12" "foo"
  stub pyenv-version-name ": echo \"2.7.12:3.5.2\""
  stub pyenv-virtualenv-prefix "2.7.12/envs/foo : echo \"${PYENV_ROOT}/versions/2.7.12\""

  assert [ ! -e "my-venv" ]
  run pyenv-virtualenv-file-write "${PWD}/my-venv" "foo"
  assert_success ""
  assert [ "$(cat my-venv)" = "foo" ]

  remove_virtualenv "2.7.12" "foo"
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}
