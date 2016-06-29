#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "fails if no local files exist" {
  stub pyenv-hooks "virtualenv-origin : echo"

  run pyenv-virtualenv-origin
  assert_failure ""

  unstub pyenv-hooks
}

@test "detects PYENV_VIRTUAL_ENV" {
  stub pyenv-hooks "virtualenv-origin : echo"

  PYENV_VIRTUAL_ENV=1 run pyenv-virtualenv-origin
  assert_success "PYENV_VIRTUAL_ENV environment variable"

  unstub pyenv-hooks
}

@test "detects local file" {
  stub pyenv-hooks "virtualenv-origin : echo"

  touch .python-venv
  run pyenv-virtualenv-origin
  assert_success "${PWD}/.python-venv"

  unstub pyenv-hooks
}

@test "reports from hook" {
  create_hook virtualenv-origin test.bash <<<"PYENV_VIRTUAL_ENV_ORIGIN=plugin"
  stub pyenv-hooks "virtualenv-origin : echo \"${PYENV_HOOK_PATH}/virtualenv-origin/test.bash\""

  PYENV_VIRTUAL_ENV=1 run pyenv-virtualenv-origin
  assert_success "plugin"

  remove_hook virtualenv-origin test.bash
  unstub pyenv-hooks
}

@test "carries original IFS within hooks" {
  create_hook virtualenv-origin hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH
  stub pyenv-hooks "virtualenv-origin : echo \"${PYENV_HOOK_PATH}/virtualenv-origin/hello.bash\""

  export PYENV_VIRTUAL_ENV=foo
  IFS=$' \t\n' run pyenv-virtualenv-origin env
  assert_success
  assert_line "HELLO=:hello:ugly:world:again"

  remove_hook virtualenv-origin hello.bash
  unstub pyenv-hooks
}

@test "doesn't inherit PYENV_VIRTUAL_ENV_ORIGIN from environment" {
  stub pyenv-hooks "virtualenv-origin : echo"

  PYENV_VIRTUAL_ENV_ORIGIN=ignored run pyenv-virtualenv-origin
  assert_failure ""

  unstub pyenv-hooks
}
