# guard against executing this block twice due to bats internals
if [ -z "$PYENV_TEST_DIR" ]; then
  PYENV_TEST_DIR="${BATS_TMPDIR}/pyenv-virtualenv-ext"
  export PYENV_TEST_DIR="$(mktemp -d "${PYENV_TEST_DIR}.XXX" 2>/dev/null || echo "$PYENV_TEST_DIR")"

  export PYENV_ROOT="${PYENV_TEST_DIR}/root"
  export PYENV_HOOK_PATH="${PYENV_ROOT}/pyenv.d"

  PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
  PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/bin:$PATH"
  PATH="${PYENV_TEST_DIR}/bin:$PATH"
  export PATH
fi

teardown() {
  rm -fr "${PYENV_TEST_DIR:?}"
}

stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift

  export "${prefix}_STUB_PLAN"="${PYENV_TEST_DIR}/${program}-stub-plan"
  export "${prefix}_STUB_RUN"="${PYENV_TEST_DIR}/${program}-stub-run"
  export "${prefix}_STUB_END"=

  mkdir -p "${PYENV_TEST_DIR}/bin"
  ln -sf "${BATS_TEST_DIRNAME}/stubs/stub" "${PYENV_TEST_DIR}/bin/${program}"

  touch "${PYENV_TEST_DIR}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${PYENV_TEST_DIR}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${PYENV_TEST_DIR}/bin/${program}"

  export "${prefix}_STUB_END"=1

  local STATUS=0
  "$path" || STATUS="$?"

  rm -f "$path"
  rm -f "${PYENV_TEST_DIR}/${program}-stub-plan" "${PYENV_TEST_DIR}/${program}-stub-run"
  return "$STATUS"
}

assert() {
  if ! "$@"; then
    flunk "assertion failed: $@"
  fi
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${PYENV_TEST_DIR}:TEST_DIR:g" >&2
  return 1
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "command succeeded, but it was expected to fail"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

create_executable() {
  mkdir -p "$1/bin"
  touch "$1/bin/$2"
  chmod +x "$1/bin/$2"
}

remove_executable() {
  rm -f "$1/bin/$2"
}

create_hook() {
  mkdir -p "${PYENV_HOOK_PATH}/$1"
  touch "${PYENV_HOOK_PATH}/$1/$2"
  if [ ! -t 0 ]; then
    cat > "${PYENV_HOOK_PATH}/$1/$2"
  fi
}

remove_hook() {
  rm -f "${PYENV_HOOK_PATH}/$1/$2"
}

create_version() {
  create_executable "${PYENV_ROOT}/versions/$1" "python"
}

remove_version() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

create_virtualenv() {
  if [ "$1" = "system" ]; then
    create_executable "${PYENV_ROOT}/versions/$2" "python"
  else
    create_version "$1"
    create_executable "${PYENV_ROOT}/versions/$1/envs/$2" "python"
  fi
}

remove_virtualenv() {
  remove_version "$1"
  remove_executable "${PYENV_ROOT}/versions/$1/envs/$2" "python"
}
