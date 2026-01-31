#!/usr/bin/bash
set -euo pipefail

# =============================================================================
# Installation Script - Part 3
# Installs Homebrew packages, Kubernetes tools, NVIDIA toolkit, GRUB theme,
# Spotify, and system configurations
# =============================================================================

# Configuration
readonly REPO_DIR="${REPO_DIR:-$HOME/Development/Linux_Mint}"
readonly LOG_FILE="${LOG_FILE:-$HOME/.linux_mint_setup.log}"
readonly DOWNLOADS_DIR="$HOME/Downloads"
readonly EXTERNAL_DRIVE="${EXTERNAL_DRIVE:-/media/$USER/Seagate}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log() {
  local level="$1"
  shift
  local message="$*"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

msg_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
  log "INFO" "$1"
}

msg_success() {
  echo -e "${GREEN}[OK]${NC} $1"
  log "SUCCESS" "$1"
}

msg_warning() {
  echo -e "${YELLOW}[WARN]${NC} $1"
  log "WARNING" "$1"
}

msg_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
  log "ERROR" "$1"
}

# Utility functions
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    msg_info "Created directory: $dir"
  fi
}

is_mounted() {
  local path="$1"
  mountpoint -q "$path" 2>/dev/null
}

# =============================================================================
# Installation Functions
# =============================================================================

update_system() {
  msg_info "Updating system..."
  sudo apt update
  sudo apt upgrade -y
  msg_success "System updated"
}

install_homebrew_packages() {
  msg_info "Installing Homebrew packages..."

  if ! command_exists brew; then
    msg_error "Homebrew not found. Please install it first."
    return 1
  fi

  local packages=(
    fd
    git-delta
    vim
    lazygit
    eza
    onefetch
    tldr
    zoxide
    asdf
    fastfetch
    glow
  )

  for package in "${packages[@]}"; do
    msg_info "Installing brew package: $package"
    brew install "$package" || msg_warning "Failed to install $package"
  done

  msg_success "Homebrew packages installed"
}

install_python_packages() {
  msg_info "Installing Python packages..."
  pip install --user pyautogui || msg_warning "Failed to install pyautogui"
  msg_success "Python packages installed"
}

install_kind() {
  msg_info "Installing Kind (Kubernetes in Docker)..."
  cd "$DOWNLOADS_DIR" || return 1

  local arch
  arch=$(uname -m)

  if [[ "$arch" == "x86_64" ]]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    msg_success "Kind installed"
  else
    msg_warning "Kind installation skipped: unsupported architecture $arch"
  fi
}

install_kubectl() {
  msg_info "Installing kubectl..."
  cd "$DOWNLOADS_DIR" || return 1

  local stable_version
  stable_version=$(curl -L -s https://dl.k8s.io/release/stable.txt)

  curl -LO "https://dl.k8s.io/release/${stable_version}/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/${stable_version}/bin/linux/amd64/kubectl.sha256"

  # Verify checksum
  if echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check --status; then
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl kubectl.sha256
    msg_success "kubectl installed (version: $stable_version)"
  else
    msg_error "kubectl checksum verification failed"
    rm -f kubectl kubectl.sha256
    return 1
  fi
}

install_nvidia_container_toolkit() {
  msg_info "Installing NVIDIA Container Toolkit..."

  # Install prerequisites
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends curl gnupg2

  # Add NVIDIA GPG key and repository
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |
    sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

  sudo apt update

  local NVIDIA_VERSION="1.18.2-1"
  sudo apt-get install -y \
    "nvidia-container-toolkit=${NVIDIA_VERSION}" \
    "nvidia-container-toolkit-base=${NVIDIA_VERSION}" \
    "libnvidia-container-tools=${NVIDIA_VERSION}" \
    "libnvidia-container1=${NVIDIA_VERSION}" || msg_warning "NVIDIA Container Toolkit installation may have issues"

  msg_success "NVIDIA Container Toolkit installed"
}

install_grub_theme() {
  if ! is_mounted "$EXTERNAL_DRIVE"; then
    msg_info "External drive not mounted, skipping GRUB theme"
    return 0
  fi

  msg_info "Installing GRUB Dracula theme..."
  local grub_src="$EXTERNAL_DRIVE/Linux/Customization/grub"

  if [[ -d "$grub_src" ]]; then
    sudo mkdir -p /boot/grub/themes/
    if [[ -d "$grub_src/dracula" ]]; then
      sudo cp -r "$grub_src/dracula" /boot/grub/themes/
    fi
    if [[ -f "$grub_src/grub" ]]; then
      sudo cp "$grub_src/grub" /etc/default/
      sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    msg_success "GRUB theme installed"
  else
    msg_warning "GRUB source directory not found"
  fi
}

install_virtualization() {
  msg_info "Installing virtualization tools..."
  sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils || msg_warning "Virtualization tools may have issues"
  msg_success "Virtualization tools installed"
}

run_custom_installer() {
  msg_info "Running custom installer script..."
  local installer="$REPO_DIR/scripts/installer/main.py"

  if [[ -f "$installer" ]]; then
    python3 "$installer"
    msg_success "Custom installer completed"
  else
    msg_warning "Custom installer not found: $installer"
  fi
}

configure_xorg() {
  if ! is_mounted "$EXTERNAL_DRIVE"; then
    msg_info "External drive not mounted, skipping Xorg configuration"
    return 0
  fi

  msg_info "Configuring Xorg..."
  local utilities_dir="$EXTERNAL_DRIVE/Linux/Utilities"

  sudo mkdir -p /etc/X11/xorg.conf.d/

  local xorg_files=(
    "10-intel-prime.conf"
    "10-modesetting.conf"
    "20-serverflags.conf"
  )

  for file in "${xorg_files[@]}"; do
    if [[ -f "$utilities_dir/$file" ]]; then
      sudo cp "$utilities_dir/$file" /etc/X11/xorg.conf.d/
      msg_info "Copied: $file"
    fi
  done

  if [[ -f "$utilities_dir/xorg.conf" ]]; then
    sudo cp "$utilities_dir/xorg.conf" /etc/X11/
    msg_info "Copied: xorg.conf"
  fi

  msg_success "Xorg configured"
}

configure_cinnamon() {
  msg_info "Configuring Cinnamon settings..."

  if command_exists gsettings; then
    gsettings set org.cinnamon.muffin unredirect-fullscreen-windows false || true
    msg_success "Cinnamon configured"
  else
    msg_info "gsettings not found, skipping Cinnamon configuration"
  fi
}

run_block_sites() {
  if ! is_mounted "$EXTERNAL_DRIVE"; then
    msg_info "External drive not mounted, skipping site blocking"
    return 0
  fi

  msg_info "Running site blocker..."
  local block_script="$EXTERNAL_DRIVE/Linux/Utilities/block-bad-sites/block.py"

  if [[ -f "$block_script" ]]; then
    sudo python3 "$block_script"
    msg_success "Site blocker executed"
  else
    msg_warning "Site blocker script not found"
  fi
}

install_spotify() {
  msg_info "Installing Spotify..."

  # Add Spotify repository
  curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc |
    sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

  echo "deb https://repository.spotify.com stable non-free" |
    sudo tee /etc/apt/sources.list.d/spotify.list

  sudo apt-get update
  sudo apt-get install -y spotify-client || {
    msg_warning "Failed to install Spotify client"
    return 1
  }

  msg_success "Spotify installed"
}

install_spicetify() {
  msg_info "Installing Spicetify..."

  # Install Spicetify
  if curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh; then
    msg_info "Spicetify installed, configuring..."

    # Wait for installation to complete
    sleep 2

    # Backup and apply
    if command_exists spicetify; then
      spicetify backup apply || msg_warning "Spicetify backup/apply failed"
    fi
  else
    msg_warning "Failed to install Spicetify"
    return 1
  fi

  msg_success "Spicetify installed"
}

configure_spicetify_theme() {
  if ! is_mounted "$EXTERNAL_DRIVE"; then
    msg_info "External drive not mounted, skipping Spicetify theme"
    return 0
  fi

  msg_info "Configuring Spicetify Dracula theme..."
  local theme_src="$EXTERNAL_DRIVE/Linux/Customization/spicetify/Dracula"

  if [[ -d "$theme_src" ]]; then
    ensure_dir "$HOME/.config/spicetify/Themes"
    cp -r "$theme_src" "$HOME/.config/spicetify/Themes/"

    if command_exists spicetify; then
      spicetify config current_theme Dracula
      spicetify apply || msg_warning "Failed to apply Spicetify theme"
    fi
    msg_success "Spicetify theme configured"
  else
    msg_warning "Spicetify theme source not found"
  fi
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
  echo "=============================================="
  echo "  Linux Mint Setup - Part 3 (Final)"
  echo "=============================================="
  log "INFO" "Starting installation part 3"

  update_system
  install_homebrew_packages
  install_python_packages
  install_kind
  install_kubectl
  install_nvidia_container_toolkit
  install_grub_theme
  install_virtualization
  run_custom_installer
  configure_xorg
  configure_cinnamon
  run_block_sites
  install_spotify
  install_spicetify
  configure_spicetify_theme

  msg_success "Installation part 3 completed!"
  echo ""
  echo "=============================================="
  echo "  ALL INSTALLATIONS COMPLETED!"
  echo ""
  echo "  The system will reboot to apply all changes."
  echo "  After reboot, log in using i3 session."
  echo "=============================================="

  read -rp "Press Enter to reboot or Ctrl+C to cancel..."
  sudo reboot now
}

main "$@"
