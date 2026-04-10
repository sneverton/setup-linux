#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

install_github_cli() {
  run_command "Creating GitHub CLI keyring directory" sudo mkdir -p -m 755 /etc/apt/keyrings
  run_command \
    "Installing GitHub CLI GPG key" \
    bash -lc 'wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null'
  run_command "Fixing GitHub CLI key permissions" sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  run_command \
    "Configuring GitHub CLI apt repository" \
    bash -lc 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null'
  run_command "Updating apt cache" sudo apt-get update
  run_command "Installing GitHub CLI" sudo apt-get install -y gh
}

install_release_binary() {
  local repo="$1"
  local version="$2"
  local archive_url="$3"
  local binary_name="$4"
  local temp_dir

  temp_dir="$(mktemp -d)"

  run_command "Downloading ${binary_name} ${version}" curl -fsSL "$archive_url" -o "$temp_dir/archive.tar.gz"
  run_command "Extracting ${binary_name}" tar -xzf "$temp_dir/archive.tar.gz" -C "$temp_dir"
  run_command "Installing ${binary_name}" sudo install "$temp_dir/$binary_name" /usr/local/bin/"$binary_name"
  rm -rf "$temp_dir"
}

install_lazygit() {
  local version

  if is_dry_run; then
    version="v0.0.0"
  else
    version="$(fetch_latest_github_tag "jesseduffield/lazygit")"
  fi

  install_release_binary \
    "jesseduffield/lazygit" \
    "$version" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version#v}_Linux_x86_64.tar.gz" \
    "lazygit"
}

install_doctl() {
  local version
  local temp_dir

  if is_dry_run; then
    version="v0.0.0"
  else
    version="$(fetch_latest_github_tag "digitalocean/doctl")"
  fi

  temp_dir="$(mktemp -d)"

  run_command \
    "Downloading doctl ${version}" \
    curl -fsSL "https://github.com/digitalocean/doctl/releases/download/${version}/doctl-${version#v}-linux-amd64.tar.gz" -o "$temp_dir/doctl.tar.gz"
  run_command "Extracting doctl" tar -xzf "$temp_dir/doctl.tar.gz" -C "$temp_dir"
  run_command "Installing doctl" sudo install "$temp_dir/doctl" /usr/local/bin/doctl
  rm -rf "$temp_dir"
}

main() {
  install_github_cli
  install_lazygit
  install_doctl
}

main "$@"
