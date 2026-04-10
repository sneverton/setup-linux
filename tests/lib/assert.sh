#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_eq() {
  local actual="$1"
  local expected="$2"
  local message="$3"

  if [[ "$actual" != "$expected" ]]; then
    fail "$message (expected: '$expected', got: '$actual')"
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"

  if [[ "$haystack" != *"$needle"* ]]; then
    fail "$message (missing: '$needle')"
  fi
}

assert_file_exists() {
  local path="$1"
  local message="$2"

  if [[ ! -e "$path" ]]; then
    fail "$message (missing file: $path)"
  fi
}

assert_symlink_target() {
  local path="$1"
  local expected_target="$2"
  local message="$3"
  local actual_target

  if [[ ! -L "$path" ]]; then
    fail "$message (not a symlink: $path)"
  fi

  actual_target="$(readlink "$path")"
  assert_eq "$actual_target" "$expected_target" "$message"
}
