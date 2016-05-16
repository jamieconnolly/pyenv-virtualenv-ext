#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

@test "in current directory" {
  create_file ".python-venv"
  run pyenv-virtualenv-file
  assert_success "${PYENV_TEST_DIR}/.python-venv"
}

@test "in parent directory" {
  create_file ".python-venv"
  mkdir -p project
  cd project
  run pyenv-virtualenv-file
  assert_success "${PYENV_TEST_DIR}/.python-venv"
}

@test "topmost file has precedence" {
  create_file ".python-venv"
  create_file "project/.python-venv"
  cd project
  run pyenv-virtualenv-file
  assert_success "${PYENV_TEST_DIR}/project/.python-venv"
}

@test "PYENV_DIR has precedence over PWD" {
  create_file "widget/.python-venv"
  create_file "project/.python-venv"
  cd project
  PYENV_DIR="${PYENV_TEST_DIR}/widget" run pyenv-virtualenv-file
  assert_success "${PYENV_TEST_DIR}/widget/.python-venv"
}

@test "PWD is searched if PYENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.python-venv"
  cd project
  PYENV_DIR="${PWD}/widget/blank" run pyenv-virtualenv-file
  assert_success "${PYENV_TEST_DIR}/project/.python-venv"
}

@test "finds virtual environment file in target directory" {
  create_file "project/.python-venv"
  run pyenv-virtualenv-file "${PWD}/project"
  assert_success "${PYENV_TEST_DIR}/project/.python-venv"
}

@test "fails when no virtual environment file in target directory" {
  run pyenv-virtualenv-file "$PWD"
  assert_failure
}
