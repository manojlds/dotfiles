#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux)  PLATFORM="ubuntu" ;;
  Darwin) PLATFORM="macos" ;;
  *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

echo "Detected platform: $PLATFORM"

# Run platform-specific install
echo ""
echo ">>> Running $PLATFORM setup..."
bash "$DOTFILES_DIR/$PLATFORM/install.sh"

# Run common install
echo ""
echo ">>> Running common setup..."
bash "$DOTFILES_DIR/common/install.sh"

# Symlink dotfiles
echo ""
echo ">>> Symlinking config files..."

ln -sf "$DOTFILES_DIR/config/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/config/wezterm.lua" "$HOME/.wezterm.lua"

mkdir -p "$HOME/.config/btop"
ln -sf "$DOTFILES_DIR/config/btop/btop.conf" "$HOME/.config/btop/btop.conf"

mkdir -p "$HOME/bin"
ln -sf "$DOTFILES_DIR/config/bin/sysmon" "$HOME/bin/sysmon"
chmod +x "$DOTFILES_DIR/config/bin/sysmon"

# systemd user environment (mise shims for services like process-compose)
mkdir -p "$HOME/.config/environment.d"
ln -sf "$DOTFILES_DIR/config/environment.d/50-mise.conf" "$HOME/.config/environment.d/50-mise.conf"

# Ensure mise shims in ~/.profile for login shells
if ! grep -q 'mise/shims' "$HOME/.profile" 2>/dev/null; then
  printf '\n# mise shims for runtime-managed tools\nif [ -d "$HOME/.local/share/mise/shims" ] ; then\n    PATH="$HOME/.local/share/mise/shims:$PATH"\nfi\n' >> "$HOME/.profile"
fi

mkdir -p "$HOME/.config/zed"
ln -sf "$DOTFILES_DIR/config/zed/settings.json" "$HOME/.config/zed/settings.json"

mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES_DIR/config/nvim/lua" "$HOME/.config/nvim/lua"

echo ""
echo "=== Setup complete! ==="
echo "Log out and back in for zsh to take effect."
