#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment" {
  assert [ ! -e "${PWD}/.python-venv" ]
  run pyenv-virtualenv-local
  assert_failure "pyenv: no local virtual environment configured for this directory"
}

@test "virtual environment" {
  cat > ".python-venv" <<<"foo"
  run pyenv-virtualenv-local
  assert_success "foo"
}

@test "discovers virtual environment file in parent directory" {
  cat > ".python-venv" <<<"foo"
  mkdir -p "subdir"
  cd "subdir"
  run pyenv-virtualenv-local
  assert_success "foo"
}

@test "ignores PYENV_DIR" {
  mkdir -p project widget
  cat > "project/.python-venv" <<<"foo"
  cat > "widget/.python-venv" <<<"bar"

  cd project
  PYENV_DIR="${PYENV_TEST_DIR}/widget" run pyenv-virtualenv-local
  assert_success "foo"
}

@test "sets local virtual environment" {
  create_virtualenv "2.7.12" "foo"
  stub pyenv-version-name ": echo \"2.7.12\""
  stub pyenv-virtualenv-prefix "2.7.12/envs/foo : echo \"${PYENV_ROOT}/versions/2.7.12\""

  assert [ ! -e ".python-venv" ]
  run pyenv-virtualenv-local foo
  assert_success ""
  assert [ "$(cat .python-venv)" = "foo" ]

  remove_virtualenv "2.7.12" "foo"
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "changes local virtual environment" {
  create_virtualenv "2.7.12" "foo"
  create_virtualenv "2.7.12" "bar"

  cat > ".python-venv" <<<"foo"
  run pyenv-virtualenv-local
  assert_success "foo"

  stub pyenv-version-name ": echo \"2.7.12\""
  stub pyenv-virtualenv-prefix "2.7.12/envs/bar : echo \"${PYENV_ROOT}/versions/2.7.12\""

  run pyenv-virtualenv-local bar
  assert_success ""
  assert [ "$(cat .python-venv)" = "bar" ]

  remove_virtualenv "2.7.12" "foo"
  remove_virtualenv "2.7.12" "bar"
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "unsets local virtual environment" {
  touch .python-venv
  run pyenv-virtualenv-local --unset
  assert_success ""
  assert [ ! -e .python-venv ]
}
