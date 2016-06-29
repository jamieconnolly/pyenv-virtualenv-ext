#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-hooks "virtualenv-name : echo"

  assert [ ! -d "${PYENV_ROOT}/versions" ]
  run pyenv-virtualenv-name
  assert_failure ""

  unstub pyenv-hooks
}

@test "PYENV_VIRTUAL_ENV can be overridden by hook" {
  create_hook virtualenv-name test.bash <<<"PYENV_VIRTUAL_ENV=bar"
  create_virtualenv "2.7.12" "foo"
  create_virtualenv "2.7.12" "bar"
  stub pyenv-hooks "virtualenv-name : echo \"${PYENV_HOOK_PATH}/virtualenv-name/test.bash\""
  stub pyenv-version-name ": echo \"2.7.12\""

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-name
  assert_success "bar"

  remove_hook virtualenv-name test.bash
  remove_virtualenv "2.7.12" "foo"
  remove_virtualenv "2.7.12" "bar"
  unstub pyenv-hooks
  unstub pyenv-version-name
}

@test "carries original IFS within hooks" {
  create_hook virtualenv-name hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH
  create_virtualenv "2.7.12" "foo"
  stub pyenv-hooks "virtualenv-name : echo \"${PYENV_HOOK_PATH}/virtualenv-name/hello.bash\""
  stub pyenv-version-name ": echo \"2.7.12\""

  export PYENV_VIRTUAL_ENV=foo
  IFS=$' \t\n' run pyenv-virtualenv-name env
  assert_success
  assert_line "HELLO=:hello:ugly:world:again"

  remove_hook virtualenv-name hello.bash
  remove_virtualenv "2.7.12" "foo"
  unstub pyenv-hooks
  unstub pyenv-version-name
}

@test "PYENV_VIRTUAL_ENV has precedence over local" {
  create_virtualenv "2.7.12" "foo"
  create_virtualenv "system" "bar"
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-version-name ": echo \"2.7.12\""

  cat > ".python-venv" <<<"foo"
  run pyenv-virtualenv-name
  assert_success "foo"

  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-version-name ": echo \"system\""

  PYENV_VIRTUAL_ENV=bar run pyenv-virtualenv-name
  assert_success "bar"

  remove_virtualenv "2.7.12" "foo"
  remove_virtualenv "system" "bar"
  unstub pyenv-hooks
  unstub pyenv-version-name
}

@test "missing virtual environment" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-version-name ": echo \"2.7.12\""
  stub pyenv-virtualenv-origin "echo \"PYENV_VIRTUAL_ENV environment variable\""

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-name
  assert_failure "pyenv: \`foo' is not a virtual environment (set by PYENV_VIRTUAL_ENV environment variable)"

  unstub pyenv-hooks
  unstub pyenv-version-name
  unstub pyenv-virtualenv-origin
}
