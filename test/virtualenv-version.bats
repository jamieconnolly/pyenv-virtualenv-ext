#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "completes with names of executables" {
  stub pyenv-virtualenvs ": printf \"bar\nfoo\""

  run pyenv-virtualenv-version --complete
  assert_success
  assert_output <<OUT
bar
foo
OUT
  unstub pyenv-virtualenvs
}

@test "no virtual environment selected" {
  stub pyenv-hooks "virtualenv-name : echo"

  run pyenv-virtualenv-version
  assert_failure ""

  unstub pyenv-hooks
}

@test "PYENV_VIRTUAL_ENV_VERSION can be overridden by hook" {
  create_hook virtualenv-version test.bash <<<"PYENV_VIRTUAL_ENV_VERSION=bar"
  stub pyenv-hooks "virtualenv-version : echo \"${PYENV_HOOK_PATH}/virtualenv-version/test.bash\""
  stub pyenv-virtualenv-prefix "foo : true"

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-version
  assert_success "bar"

  remove_hook virtualenv-version test.bash
  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
}

@test "carries original IFS within hooks" {
  create_hook virtualenv-version hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH
  stub pyenv-hooks "virtualenv-version : echo \"${PYENV_HOOK_PATH}/virtualenv-version/hello.bash\""

  export PYENV_VIRTUAL_ENV=foo
  IFS=$' \t\n' run pyenv-virtualenv-version env
  assert_failure
  assert_line "HELLO=:hello:ugly:world:again"

  remove_hook virtualenv-version hello.bash
  unstub pyenv-hooks
}

@test "first argument has precedence over local and PYENV_VIRTUAL_ENV" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-name ": echo \"foo\""
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""

  run pyenv-virtualenv-version
  assert_success "2.7.11"

  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-prefix "bar : echo \"${PYENV_ROOT}/versions/3.4.4\""

  run pyenv-virtualenv-version bar
  assert_success "3.4.4"

  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-prefix "baz : echo \"${PYENV_ROOT}/versions/3.5.1\""

  PYENV_VIRTUAL_ENV=bar run pyenv-virtualenv-version baz
  assert_success "3.5.1"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-name
  unstub pyenv-virtualenv-prefix
}

@test "PYENV_VIRTUAL_ENV has precedence over local" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-name ": echo \"foo\""
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""

  run pyenv-virtualenv-version
  assert_success "2.7.11"

  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-prefix "bar : echo \"${PYENV_ROOT}/versions/3.5.1\""

  PYENV_VIRTUAL_ENV=bar run pyenv-virtualenv-version
  assert_success "3.5.1"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-name
  unstub pyenv-virtualenv-prefix
}

@test "missing virtual environment" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-prefix "foo : false"

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-version
  assert_failure ""

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
}
