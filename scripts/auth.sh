#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

prompt_yes_no() {
  local prompt="$1"
  local answer

  read -r -p "$prompt [y/N]: " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

login_github() {
  if ! command_exists gh; then
    log_warn "Skipping GitHub login because gh is not installed."
    return
  fi

  if gh auth status >/dev/null 2>&1; then
    log_info "GitHub CLI is already authenticated."
    return
  fi

  if prompt_yes_no "Authenticate GitHub CLI now?"; then
    gh auth login
  fi
}

login_copilot() {
  if ! command_exists copilot; then
    log_warn "Skipping Copilot login because copilot is not installed."
    return
  fi

  if prompt_yes_no "Authenticate Copilot CLI now?"; then
    copilot login || copilot
  fi
}

login_codex() {
  if ! command_exists codex; then
    log_warn "Skipping Codex login because codex is not installed."
    return
  fi

  if prompt_yes_no "Authenticate Codex now?"; then
    codex --login
  fi
}

login_claude() {
  if ! command_exists claude; then
    log_warn "Skipping Claude Code login because claude is not installed."
    return
  fi

  if prompt_yes_no "Open Claude Code now for first-run login?"; then
    claude
  fi
}

login_doctl() {
  if ! command_exists doctl; then
    log_warn "Skipping doctl login because doctl is not installed."
    return
  fi

  if prompt_yes_no "Authenticate doctl now?"; then
    doctl auth init
  fi
}

main() {
  if [[ ! -t 0 ]]; then
    log_warn "Skipping auth module because no interactive terminal is available."
    return
  fi

  login_github
  login_copilot
  login_codex
  login_claude
  login_doctl
}

main "$@"
