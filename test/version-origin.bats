# !/usr/bin/env bats

load test_helper

setup() {
  export VERSION_ORIGIN_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/version-origin/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-hooks "virtualenv-origin : echo"

  run pyenv-version-origin
  assert_success "${PYENV_TEST_DIR}/.python-version"

  unstub pyenv-hooks
}

@test "detects local virtual environment" {
  stub pyenv-hooks "virtualenv-origin : echo"
  create_virtualenv "2.7.11" "foo"

  cat > ".python-venv" <<<"foo"
  run pyenv-version-origin
  assert_success "${PYENV_TEST_DIR}/.python-venv"

  unstub pyenv-hooks
  remove_virtualenv "2.7.11" "foo"
}

@test "PYENV_VERSION has precedence over local virtual environment" {
  PYENV_VERSION=1 run pyenv-version-origin
  assert_success "PYENV_VERSION environment variable"
}
