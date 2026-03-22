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
  openjdk-17-jdk \
  postgresql-client-16 \
  libssl-dev \
  libxmlsec1-dev \
  libmagic-dev \
  libmagickwand-dev \
  pandoc \
  fzf \
  inotify-tools

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

# --- Cursor (Desktop) ---
echo ">>> Installing Cursor desktop..."
if ! dpkg -l cursor &>/dev/null; then
  ARCH="$(dpkg --print-architecture)"
  case "$ARCH" in
    amd64) CURSOR_CHANNEL="linux-x64-deb" ;;
    arm64) CURSOR_CHANNEL="linux-arm64-deb" ;;
    *)
      echo ">>> Unsupported architecture for Cursor desktop: $ARCH. Skipping."
      CURSOR_CHANNEL=""
      ;;
  esac

  if [ -n "$CURSOR_CHANNEL" ]; then
    curl -fsSL -o /tmp/cursor.deb "https://api2.cursor.sh/updates/download/golden/${CURSOR_CHANNEL}/cursor/latest"
    sudo apt install -fy /tmp/cursor.deb
    rm /tmp/cursor.deb
  fi
else
  echo ">>> Cursor desktop already installed, skipping."
fi

# --- Neovim (latest stable from GitHub) ---
echo ">>> Installing neovim..."
sudo apt install -y ripgrep fd-find
NVIM_VER=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')
curl -Lo /tmp/nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VER}/nvim-linux-x86_64.tar.gz"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm /tmp/nvim-linux64.tar.gz

# --- btop ---
echo ">>> Installing btop..."
sudo apt install -y btop

# --- RustDesk ---
echo ">>> Installing RustDesk..."
if ! dpkg -l rustdesk &>/dev/null; then
  RUSTDESK_VER=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.tag_name')
  curl -Lo /tmp/rustdesk.deb "https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VER}/rustdesk-${RUSTDESK_VER}-x86_64.deb"
  sudo apt install -fy /tmp/rustdesk.deb
  rm /tmp/rustdesk.deb
fi

# --- Tailscale ---
echo ">>> Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# --- Beszel Hub (official binary install script) ---
echo ">>> Installing Beszel Hub (official script)..."
curl -sL https://get.beszel.dev/hub -o /tmp/install-hub.sh
chmod +x /tmp/install-hub.sh
sudo /tmp/install-hub.sh
rm -f /tmp/install-hub.sh
