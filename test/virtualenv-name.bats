#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-hooks "virtualenv-name : echo"

  run pyenv-virtualenv-name
  assert_success

  unstub pyenv-hooks
}

@test "PYENV_VIRTUAL_ENV can be overridden by hook" {
  stub pyenv-hooks "virtualenv-name : echo \"${PYENV_HOOK_PATH}/virtualenv-name/test.bash\""
  stub pyenv-virtualenv-prefix "bar : true"
  create_hook virtualenv-name test.bash <<<"PYENV_VIRTUAL_ENV=bar"

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-name
  assert_success "bar"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_hook virtualenv-name test.bash
}

@test "carries original IFS within hooks" {
  stub pyenv-hooks "virtualenv-name : echo \"${PYENV_HOOK_PATH}/virtualenv-name/hello.bash\""
  stub pyenv-virtualenv-prefix "foo : true"
  create_hook virtualenv-name hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  export PYENV_VIRTUAL_ENV=foo
  IFS=$' \t\n' run pyenv-virtualenv-name env
  assert_success
  assert_line "HELLO=:hello:ugly:world:again"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_hook virtualenv-name hello.bash
}

@test "PYENV_VIRTUAL_ENV has precedence over local" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-prefix "foo : true"

  cat > ".python-venv" <<<"foo"
  run pyenv-virtualenv-name
  assert_success "foo"

  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-prefix "bar : true"

  PYENV_VIRTUAL_ENV=bar run pyenv-virtualenv-name
  assert_success "bar"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
}

@test "missing virtual environment" {
  stub pyenv-hooks "virtualenv-name : echo"
  stub pyenv-virtualenv-origin "echo \"PYENV_VIRTUAL_ENV environment variable\""
  stub pyenv-virtualenv-prefix "foo : false"

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-name
  assert_failure "pyenv: virtualenv \`foo' is not a virtual environment (set by PYENV_VIRTUAL_ENV environment variable)"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-origin
  unstub pyenv-virtualenv-prefix
}
