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

mkdir -p "$HOME/.config/zed"
ln -sf "$DOTFILES_DIR/config/zed/settings.json" "$HOME/.config/zed/settings.json"

echo ""
echo "=== Setup complete! ==="
echo "Log out and back in for zsh to take effect."
