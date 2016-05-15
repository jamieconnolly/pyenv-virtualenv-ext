# !/usr/bin/env bats

load test_helper

setup() {
  export VERSION_ORIGIN_HOOK="${BATS_TEST_DIRNAME}/../etc/pyenv.d/version-origin/virtualenv-ext.bash"

  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtualenv selected" {
  stub pyenv-hooks "virtualenv-name : echo"

  run pyenv-version-origin
  assert_success "${PYENV_TEST_DIR}/.python-version"

  unstub pyenv-hooks
}

@test "discovers version from pyenv-virtualenv-name" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""
  create_virtualenv "2.7.11" "foo"

  cat > ".python-venv" <<<"foo"
  run pyenv-version-origin
  assert_success "\`foo' virtual environment"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_virtualenv "2.7.11" "foo"
}

@test "PYENV_VERSION has precedence over local virtual environment" {
  PYENV_VERSION=1 run pyenv-version-origin
  assert_success "PYENV_VERSION environment variable"
}
