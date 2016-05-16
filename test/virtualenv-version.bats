#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "no virtual environment selected" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-name ": echo"

  run pyenv-virtualenv-version
  assert_failure ""

  unstub pyenv-hooks
  unstub pyenv-virtualenv-name
}

@test "PYENV_VIRTUAL_ENV_VERSION can be overridden by hook" {
  stub pyenv-hooks "virtualenv-version : echo \"${PYENV_HOOK_PATH}/virtualenv-version/test.bash\""
  stub pyenv-virtualenv-prefix "foo : true"
  create_hook virtualenv-version test.bash <<<"PYENV_VIRTUAL_ENV_VERSION=bar"

  PYENV_VIRTUAL_ENV=foo run pyenv-virtualenv-version
  assert_success "bar"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_hook virtualenv-version test.bash
}

@test "carries original IFS within hooks" {
  stub pyenv-hooks "virtualenv-version : echo \"${PYENV_HOOK_PATH}/virtualenv-version/hello.bash\""
  stub pyenv-virtualenv-prefix "foo : true"
  create_hook virtualenv-version hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  export PYENV_VIRTUAL_ENV=foo
  IFS=$' \t\n' run pyenv-virtualenv-version env
  assert_failure
  assert_line "HELLO=:hello:ugly:world:again"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-prefix
  remove_hook virtualenv-name hello.bash
}

@test "PYENV_VIRTUAL_ENV has precedence over local" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-name ": echo \"foo\""
  stub pyenv-virtualenv-prefix "foo : echo \"${PYENV_ROOT}/versions/2.7.11\""

  run pyenv-virtualenv-version
  assert_success "2.7.11"

  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-prefix "bar : echo \"${PYENV_ROOT}/versions/2.7.10\""

  PYENV_VIRTUAL_ENV=bar run pyenv-virtualenv-version
  assert_success "2.7.10"

  unstub pyenv-hooks
  unstub pyenv-virtualenv-name
  unstub pyenv-virtualenv-prefix
}

@test "doesn't inherit PYENV_VIRTUAL_ENV_VERSION from environment" {
  stub pyenv-hooks "virtualenv-version : echo"
  stub pyenv-virtualenv-name ": echo"

  PYENV_VIRTUAL_ENV_VERSION=ignored run pyenv-virtualenv-version
  assert_failure ""

  unstub pyenv-hooks
  unstub pyenv-virtualenv-name
}
