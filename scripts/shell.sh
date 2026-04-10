#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Oh My Zsh already installed."
    return
  fi

  run_command \
    "Installing Oh My Zsh" \
    bash -lc 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
}

install_zsh_plugin() {
  local repo="$1"
  local destination="$2"

  if [[ -d "$destination" ]]; then
    log_info "Plugin already present at $destination"
    return
  fi

  ensure_dir "$(dirname "$destination")"
  run_command "Cloning $(basename "$destination")" git clone "https://github.com/${repo}.git" "$destination"
}

set_default_shell() {
  local zsh_path
  local current_shell
  local passwd_entry

  if is_dry_run && ! command_exists zsh; then
    zsh_path="/usr/bin/zsh"
  else
    zsh_path="$(command -v zsh)"
  fi

  if command_exists getent && passwd_entry="$(getent passwd "$USER" 2>/dev/null)"; then
    current_shell="$(cut -d: -f7 <<<"$passwd_entry")"
  else
    current_shell="${SHELL:-}"
  fi

  if [[ "$current_shell" == "$zsh_path" ]]; then
    log_info "Default shell already set to zsh."
    return
  fi

  run_command "Setting default shell to zsh" sudo usermod --shell "$zsh_path" "$USER"
}

main() {
  install_oh_my_zsh
  install_zsh_plugin "zsh-users/zsh-autosuggestions" "$HOME/.zsh/zsh-autosuggestions"
  install_zsh_plugin "zsh-users/zsh-syntax-highlighting" "$HOME/.zsh/zsh-syntax-highlighting"
  set_default_shell
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
