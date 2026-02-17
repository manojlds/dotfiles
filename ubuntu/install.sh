#!/usr/bin/env bash
set -euo pipefail

# --- System Update ---
echo ">>> Updating system..."
sudo apt update
sudo apt upgrade -y

# --- Core Build Tools & Libraries ---
echo ">>> Installing build tools and libraries..."
sudo apt install -y \
  build-essential \
  make \
  curl \
  ca-certificates \
  jq \
  git \
  gh \
  tmux \
  unzip \
  postgresql-client-16 \
  libssl-dev \
  libxmlsec1-dev \
  libmagic-dev \
  libmagickwand-dev

# --- Zsh ---
echo ">>> Installing zsh..."
sudo apt install -y zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# --- WezTerm ---
echo ">>> Installing wezterm..."
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install -y wezterm

# --- Google Chrome ---
echo ">>> Installing Google Chrome..."
if ! dpkg -l google-chrome-stable &>/dev/null; then
  curl -fsSL -o /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
  rm /tmp/google-chrome.deb
fi

# --- Tailscale ---
echo ">>> Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
