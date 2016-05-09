#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "fails without arguments" {
  run pyenv-virtualenv-file-read
  assert_failure
}

@test "fails for invalid file" {
  run pyenv-virtualenv-file-read "non-existent"
  assert_failure
}

@test "fails for blank file" {
  echo > my-venv
  run pyenv-virtualenv-file-read my-venv
  assert_failure
}

@test "reads simple virtualenv file" {
  cat > my-venv <<<"foo"
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "ignores leading spaces" {
  cat > my-venv <<<"  foo"
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "reads only the first word from file" {
  cat > my-venv <<<"foo bar baz"
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "loads only the first line in file" {
  cat > my-venv <<IN
foo
bar
IN
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "ignores leading blank lines" {
  cat > my-venv <<IN
foo
IN
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "handles the file with no trailing newline" {
  echo -n "foo" > my-venv
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}

@test "ignores carriage returns" {
  cat > my-venv <<< $'foo\r'
  run pyenv-virtualenv-file-read my-venv
  assert_success "foo"
}
