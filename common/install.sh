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

# --- Rust CLI tools (jj + zellij) ---
echo ">>> Installing Rust CLI tools (jj, zellij) with cargo..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"
cargo install --locked --bin jj jj-cli
cargo install --locked zellij

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

# --- Nix + devenv ---
echo ">>> Installing nix..."
if ! command -v nix-env &>/dev/null; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

echo ">>> Installing devenv..."
if ! command -v devenv &>/dev/null; then
  if command -v nix-env &>/dev/null; then
    nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable
  elif [ -x /nix/var/nix/profiles/default/bin/nix-env ]; then
    /nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable
  else
    echo ">>> nix-env not available yet. Open a new shell and re-run install.sh to install devenv."
  fi
else
  echo ">>> devenv already installed, skipping."
fi

# --- mise ---
echo ">>> Installing mise..."
curl https://mise.run | sh

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

# --- Cursor CLI ---
echo ">>> Installing cursor cli..."
curl -fsSL https://cursor.com/install | bash

# --- Codex CLI ---
echo ">>> Installing codex cli..."
npm install -g @openai/codex

# --- Pi Coding Agent ---
echo ">>> Installing pi coding agent..."
npm install -g @mariozechner/pi-coding-agent

# --- Local secrets template ---
echo ">>> Preparing local secrets template..."
SECRETS_DIR="$HOME/.config/dotfiles"
SECRETS_FILE="$SECRETS_DIR/secrets.env"
mkdir -p "$SECRETS_DIR"
if [ ! -f "$SECRETS_FILE" ]; then
  cat > "$SECRETS_FILE" <<'EOF'
# Local secrets for shell tools (not tracked in git)
# Fill in values and keep this file private.

# export OPENAI_API_KEY=""
# export ANTHROPIC_API_KEY=""
# export GEMINI_API_KEY=""
EOF
fi
chmod 600 "$SECRETS_FILE"
