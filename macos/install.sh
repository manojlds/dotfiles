#!/usr/bin/env bash
set -euo pipefail

# --- Homebrew ---
echo ">>> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Brew Packages ---
echo ">>> Installing brew packages..."
brew install \
  curl \
  jq \
  git \
  gh \
  tmux \
  openssl \
  libxmlsec1 \
  imagemagick \
  libmagic \
  libpq \
  zsh

# --- Cask Apps ---
echo ">>> Installing cask apps..."
brew install --cask \
  wezterm \
  google-chrome \
  tailscale

# --- Set default shell to zsh ---
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi
