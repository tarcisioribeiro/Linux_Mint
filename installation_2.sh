#!/usr/bin/bash
set -euo pipefail

# =============================================================================
# Installation Script - Part 2
# Installs Docker, Ranger, Kitty, Flatpak apps, and shell configurations
# =============================================================================

# Configuration
readonly REPO_DIR="${REPO_DIR:-$HOME/Development/Linux_Mint}"
readonly LOG_FILE="${LOG_FILE:-$HOME/.linux_mint_setup.log}"
readonly DOWNLOADS_DIR="$HOME/Downloads"
readonly EXTERNAL_DRIVE="${EXTERNAL_DRIVE:-/media/$USER/Seagate}"
readonly DEB_PACKAGES_DIR="${DEB_PACKAGES_DIR:-$EXTERNAL_DRIVE/Linux/Programs/Packages}"

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

remove_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    rm -rf "$path"
    msg_info "Removed existing: $path"
  fi
}

clone_repo() {
  local url="$1"
  local dest="$2"

  remove_if_exists "$dest"
  git clone --quiet "$url" "$dest"
  msg_info "Cloned: $url"
}

run_script() {
  local script="$1"
  if [[ -x "$script" ]]; then
    "$script"
  elif [[ -f "$script" ]]; then
    bash "$script"
  else
    msg_error "Script not found or not executable: $script"
    return 1
  fi
}

is_mounted() {
  local path="$1"
  mountpoint -q "$path" 2>/dev/null
}

# =============================================================================
# Installation Functions
# =============================================================================

check_prerequisites() {
  msg_info "Checking prerequisites..."

  if ! command_exists brew; then
    msg_error "brew command not found. Please reboot and try again."
    exit 1
  fi

  msg_success "Prerequisites check passed"
}

update_system() {
  msg_info "Updating system..."
  sudo apt update
  sudo apt upgrade -y
  msg_success "System updated"
}

remove_firefox() {
  msg_info "Removing Firefox..."

  if command_exists firefox; then
    # Remove via apt
    sudo apt remove --purge -y firefox firefox-locale-* 2>/dev/null || true
    sudo apt autoremove -y

    # Remove via snap if exists
    if snap list firefox 2>/dev/null; then
      sudo snap remove --purge firefox
    fi

    # Remove configuration directories
    remove_if_exists "$HOME/.mozilla/firefox"
    remove_if_exists "$HOME/.cache/mozilla/firefox"
    remove_if_exists "$HOME/snap/firefox"

    msg_success "Firefox removed"
  else
    msg_info "Firefox not installed, skipping removal"
  fi
}

install_external_deb_packages() {
  if [[ ! -d "$DEB_PACKAGES_DIR" ]] || ! is_mounted "$(dirname "$EXTERNAL_DRIVE")"; then
    msg_info "External drive not mounted, skipping .deb package installation"
    return 0
  fi

  msg_info "Installing .deb packages from external drive..."

  local deb_count
  deb_count=$(find "$DEB_PACKAGES_DIR" -maxdepth 1 -name "*.deb" 2>/dev/null | wc -l)

  if [[ "$deb_count" -eq 0 ]]; then
    msg_info "No .deb packages found in $DEB_PACKAGES_DIR"
    return 0
  fi

  msg_info "Found $deb_count .deb packages"

  for deb_file in "$DEB_PACKAGES_DIR"/*.deb; do
    if [[ -f "$deb_file" ]]; then
      local basename
      basename=$(basename "$deb_file")
      msg_info "Installing: $basename"
      sudo apt install -y "$deb_file" || {
        msg_warning "Failed to install $basename, attempting to fix dependencies..."
        sudo apt --fix-broken install -y
      }
    fi
  done

  msg_success "External .deb packages installation completed"
}

install_docker() {
  msg_info "Installing Docker..."
  local script="$REPO_DIR/packages/development-tools/docker_install.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "Docker installed"
  else
    msg_warning "docker_install.sh not found"
  fi
}

setup_ranger() {
  msg_info "Configuring Ranger..."

  ensure_dir "$HOME/.config/ranger/plugins"
  ensure_dir "$HOME/.config/ranger/colorschemes"

  # Install ranger_devicons
  local devicons_dir="$HOME/.config/ranger/plugins/ranger_devicons"
  remove_if_exists "$devicons_dir"
  clone_repo "https://github.com/alexanderjeurissen/ranger_devicons" "$devicons_dir"

  # Install Dracula theme
  cd "$DOWNLOADS_DIR" || return 1
  remove_if_exists "ranger"
  clone_repo "https://github.com/dracula/ranger.git" "ranger"
  cp ranger/dracula.py "$HOME/.config/ranger/colorschemes/"
  rm -rf ranger

  msg_success "Ranger configured"
}

install_asdf_packages() {
  msg_info "Installing ASDF packages..."
  local script="$REPO_DIR/packages/package-managers/asdf_packages.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "ASDF packages installed"
  else
    msg_warning "asdf_packages.sh not found"
  fi
}

install_kitty() {
  msg_info "Installing Kitty..."
  local script="$REPO_DIR/packages/programs/kitty_install.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "Kitty installed"
  else
    msg_warning "kitty_install.sh not found"
  fi
}

install_flatpak_apps() {
  msg_info "Installing Flatpak applications..."

  local apps=(
    "com.getpostman.Postman"
    "org.telegram.desktop"
    "org.flameshot.Flameshot"
  )

  for app in "${apps[@]}"; do
    msg_info "Installing Flatpak: $app"
    flatpak install -y flathub "$app" || msg_warning "Failed to install $app"
  done

  msg_success "Flatpak applications installed"
}

configure_shell_for_root() {
  msg_info "Configuring shell for root user..."
  local customization_dir="$REPO_DIR/customization"

  # Change default shell to zsh
  sudo chsh -s /usr/bin/zsh

  # Copy bash configs
  if [[ -f "$customization_dir/bash/.bashrc_root" ]]; then
    sudo cp "$customization_dir/bash/.bashrc_root" /root/.bashrc
  fi
  if [[ -f "$customization_dir/bash/.bash_aliases_root" ]]; then
    sudo cp "$customization_dir/bash/.bash_aliases_root" /root/.bash_aliases
  fi

  # Copy zsh configs
  if [[ -f "$customization_dir/zsh/.zshrc_root" ]]; then
    sudo cp "$customization_dir/zsh/.zshrc_root" /root/.zshrc
  fi
  if [[ -f "$customization_dir/zsh/.zsh_aliases_root" ]]; then
    sudo cp "$customization_dir/zsh/.zsh_aliases_root" /root/.zsh_aliases
  fi

  # Copy oh-my-zsh
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    sudo cp -r "$HOME/.oh-my-zsh" /root/
  fi

  # Copy scripts
  if [[ -d "$REPO_DIR/scripts" ]]; then
    sudo cp -r "$REPO_DIR/scripts" /root/
  fi

  msg_success "Root shell configured"
}

install_i3_session() {
  msg_info "Installing i3 session file..."
  local session_file="$REPO_DIR/stow/i3.desktop"

  if [[ -f "$session_file" ]]; then
    sudo cp "$session_file" /usr/share/xsessions/
    msg_success "i3 session installed"
  else
    msg_warning "i3.desktop not found"
  fi
}

install_claude_cli() {
  msg_info "Installing Claude CLI..."

  if curl -fsSL https://claude.ai/install.sh | bash; then
    msg_success "Claude CLI installed"
  else
    msg_warning "Failed to install Claude CLI"
  fi
}

copy_system_themes() {
  msg_info "Copying themes to system directories..."

  # Icons
  if [[ -d "$HOME/.local/share/icons/dracula-dark" ]]; then
    sudo cp -r "$HOME/.local/share/icons/dracula-dark/" /usr/share/icons/
    msg_info "Copied dracula icons to system"
  fi

  # Themes
  if [[ -d "$HOME/.themes/Dracula" ]]; then
    sudo cp -r "$HOME/.themes/Dracula/" /usr/share/themes/
    msg_info "Copied Dracula theme to system"
  fi

  # Wallpapers
  sudo mkdir -p /usr/share/backgrounds/Dracula
  if [[ -d "$REPO_DIR/wallpapers" ]]; then
    local wallpapers=("$REPO_DIR/wallpapers"/*.png)
    if [[ -e "${wallpapers[0]}" ]]; then
      sudo cp "$REPO_DIR/wallpapers"/*.png /usr/share/backgrounds/Dracula/
      msg_info "Copied wallpapers to system"
    fi
  fi

  msg_success "System themes configured"
}

install_external_fonts() {
  if ! is_mounted "$EXTERNAL_DRIVE"; then
    msg_info "External drive not mounted, skipping external fonts"
    return 0
  fi

  msg_info "Installing fonts from external drive..."
  local fonts_dir="$EXTERNAL_DRIVE/Linux/Fonts"
  local system_font_dir="/usr/share/fonts"
  local local_font_dir="$HOME/.local/share/fonts"

  ensure_dir "$local_font_dir"

  local fonts=(
    "MonofurNerdFontMono-Regular.ttf"
    "OpenSans-VariableFont_wdth,wght.ttf"
    "Roboto-VariableFont_wdth,wght.ttf"
    "RobotoMono-VariableFont_wght.ttf"
    "RobotoMonoNerdFontMono-Regular.ttf"
  )

  for font in "${fonts[@]}"; do
    if [[ -f "$fonts_dir/$font" ]]; then
      sudo cp "$fonts_dir/$font" "$system_font_dir/"
      cp "$fonts_dir/$font" "$local_font_dir/"
      msg_info "Installed font: $font"
    else
      msg_warning "Font not found: $font"
    fi
  done

  fc-cache -fv >/dev/null 2>&1
  msg_success "External fonts installed"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
  echo "=============================================="
  echo "  Linux Mint Setup - Part 2"
  echo "=============================================="
  log "INFO" "Starting installation part 2"

  check_prerequisites
  update_system
  remove_firefox
  install_external_deb_packages
  install_docker
  setup_ranger
  install_asdf_packages
  install_kitty
  install_flatpak_apps
  configure_shell_for_root
  install_i3_session
  install_claude_cli
  copy_system_themes
  install_external_fonts

  msg_success "Installation part 2 completed!"
  echo ""
  echo "=============================================="
  echo "  System will reboot now."
  echo "  After reboot, run installation_3.sh"
  echo "=============================================="

  read -rp "Press Enter to reboot or Ctrl+C to cancel..."
  sudo reboot now
}

main "$@"
