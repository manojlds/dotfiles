#!/usr/bin/env bash
set -euo pipefail

# --- Starship Prompt ---
echo ">>> Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# --- uv (Python package manager) ---
echo ">>> Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uv python install 3.12

# --- nvm & Node.js ---
echo ">>> Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

# --- Jujutsu (jj) ---
echo ">>> Installing jujutsu (jj) with cargo..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"
cargo install --locked --bin jj jj-cli

# --- FiraCode Nerd Font ---
if ! fc-list 2>/dev/null | grep -qi "FiraCode Nerd Font"; then
  echo ">>> Installing FiraCode Nerd Font..."
  FIRACODE_URL=$(curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' \
    | jq -r '.assets[] | select(.name == "FiraCode.zip") | .browser_download_url')
  TMPDIR=$(mktemp -d)
  curl -L -o "$TMPDIR/FiraCode.zip" "$FIRACODE_URL"

  OS="$(uname -s)"
  if [ "$OS" = "Darwin" ]; then
    unzip -o "$TMPDIR/FiraCode.zip" -d "$HOME/Library/Fonts"
  else
    sudo mkdir -p /usr/share/fonts/FiraCode
    sudo unzip -o "$TMPDIR/FiraCode.zip" -d /usr/share/fonts/FiraCode
    sudo fc-cache -fv
  fi
  rm -rf "$TMPDIR"
else
  echo ">>> FiraCode Nerd Font already installed, skipping."
fi

# --- Bun ---
echo ">>> Installing bun..."
curl -fsSL https://bun.sh/install | bash

# --- Zed Editor ---
echo ">>> Installing Zed editor..."
curl -fsSL https://zed.dev/install.sh | sh

# --- Opencode ---
echo ">>> Installing opencode..."
curl -fsSL https://opencode.ai/install | bash

# --- Amp ---
echo ">>> Installing amp..."
curl -fsSL https://ampcode.com/install.sh | bash

# --- Claude Code ---
echo ">>> Installing claude code..."
curl -fsSL https://claude.ai/install.sh | bash

# --- Pi Coding Agent ---
echo ">>> Installing pi coding agent..."
npm install -g @mariozechner/pi-coding-agent

# --- Oh My Pi ---
echo ">>> Installing oh-my-pi..."
bun install -g @oh-my-pi/pi-coding-agent
