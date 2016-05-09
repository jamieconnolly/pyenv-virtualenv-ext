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

@test "setting nonexistent virtualenv fails" {
  stub pyenv-virtualenv-prefix "foo : false"

  assert [ ! -e ".python-venv" ]
  run pyenv-virtualenv-file-write ".python-venv" "foo"
  assert_failure
  assert [ ! -e ".python-venv" ]

  unstub pyenv-virtualenv-prefix
}

@test "writes value to arbitrary file" {
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  create_virtualenv "foo"

  assert [ ! -e "my-venv" ]
  run pyenv-virtualenv-file-write "${PWD}/my-venv" "foo"
  assert_success
  assert [ "$(cat my-venv)" = "foo" ]

  unstub pyenv-virtualenv-prefix
  remove_virtualenv "foo"
}
