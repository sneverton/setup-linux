#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

export N_PREFIX="${N_PREFIX:-$HOME/.n}"
export PATH="$N_PREFIX/bin:$PATH"

install_n() {
  if command_exists n; then
    log_info "n is already installed."
    return
  fi

  ensure_dir "$N_PREFIX"
  run_command "Installing n into $N_PREFIX" npm install -g --prefix "$N_PREFIX" n
}

install_node_lts() {
  run_command "Installing latest LTS Node.js with n" n lts
}

ensure_node_constraints() {
  local node_major
  local npm_major

  node_major="$(node -p 'process.versions.node.split(".")[0]')"
  npm_major="$(npm -v | cut -d. -f1)"

  if (( node_major < 22 )); then
    abort "GitHub Copilot CLI requires Node.js 22 or newer."
  fi

  if (( npm_major < 10 )); then
    abort "GitHub Copilot CLI requires npm 10 or newer."
  fi
}

install_global_npm_package() {
  local package_name="$1"

  run_command "Installing ${package_name}" npm install -g "$package_name"
}

main() {
  install_n
  install_node_lts

  if [[ "${SETUP_DEBIAN_DRY_RUN:-0}" != "1" ]]; then
    ensure_node_constraints
  fi

  install_global_npm_package "pnpm"
  install_global_npm_package "@openai/codex"
  install_global_npm_package "@anthropic-ai/claude-code"
  install_global_npm_package "@github/copilot"
}

main "$@"
