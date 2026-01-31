#!/usr/bin/bash
set -euo pipefail

# =============================================================================
# Installation Script - Part 1
# Installs base packages, Oh My ZSH, Oh My Posh, fonts, and core applications
# =============================================================================

# Configuration
readonly REPO_DIR="${REPO_DIR:-$HOME/Development/Linux_Mint}"
readonly LOG_FILE="${LOG_FILE:-$HOME/.linux_mint_setup.log}"
readonly DOWNLOADS_DIR="$HOME/Downloads"

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

safe_symlink() {
  local source="$1"
  local target="$2"
  remove_if_exists "$target"
  ln -sf "$source" "$target"
  msg_info "Created symlink: $target -> $source"
}

clone_repo() {
  local url="$1"
  local dest="$2"
  local branch="${3:-}"

  remove_if_exists "$dest"

  if [[ -n "$branch" ]]; then
    git clone --quiet --branch "$branch" "$url" "$dest"
  else
    git clone --quiet "$url" "$dest"
  fi
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

# Package list (deduplicated)
PACKAGES=(
  # Build tools
  build-essential gcc g++ clang make cmake automake autoconf meson ninja-build scdoc cargo gradle

  # Development
  git stow pkg-config dkms perl ruby-full golang

  # Python
  python3 python3-venv python3-tk python3-pip python3-openssl python3-full python3-dev

  # Libraries - SSL/Compression
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev liblzma-dev tk-dev

  # Libraries - X11/XCB
  libx11-dev libxrandr-dev libxinerama-dev libxss-dev libx11-xcb-dev
  libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-util-dev
  libxcb-icccm4-dev libxcb-randr0-dev libxcb-xinerama0-dev
  libxcb-cursor-dev libxcb-xkb-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0-dev
  libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev
  libxcb-present-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-xfixes0-dev

  # Libraries - GTK/GUI
  libgtk-3-dev libgtk-4-dev libadwaita-1-dev libpango1.0-dev libglib2.0-dev
  libcairo2-dev libfontconfig1-dev libconfig-dev libdbus-1-dev
  libegl-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev
  libev-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev
  uthash-dev libstartup-notification0-dev libyajl-dev libpam0g-dev

  # Libraries - Multimedia
  libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libswresample-dev
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev

  # Libraries - Database
  default-libmysqlclient-dev libpq-dev

  # Libraries - Other
  libsdl2-dev libusb-1.0-0-dev libcurl4-openssl-dev libgd-dev libonig-dev libzip-dev

  # GStreamer plugins
  gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad
  gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools
  gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3
  gstreamer1.0-qt5 gstreamer1.0-pulseaudio

  # Desktop environment
  rofi polybar dunst nitrogen feh picom i3lock xdotool xss-lock

  # Terminal tools
  tmux fzf bat btop ranger cava neofetch toilet

  # Utilities
  curl wget unzip jq zsh xclip xsel scrot maim playerctl acpi light locate ncdu pv p7zip

  # Applications
  gdebi mpv vlc shotcut obs-studio gimp evince redshift

  # System
  flatpak pavucontrol timeshift openssh-server adb cpu-checker gh
  deluge deluged deluge-web deluge-console blueman

  # Virtualization
  libvirt-daemon-system libvirt-clients bridge-utils ffmpeg

  # Themes
  breeze-cursor-theme
)

# =============================================================================
# Main Installation Functions
# =============================================================================

install_packages() {
  msg_info "Updating system and installing nala..."
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y nala

  msg_info "Installing packages with nala..."
  sudo nala update && sudo nala upgrade -y

  # Filter only available packages
  local available_packages=()
  for package in "${PACKAGES[@]}"; do
    if apt-cache show "$package" &>/dev/null; then
      available_packages+=("$package")
    else
      msg_warning "Package not available: $package"
    fi
  done

  if [[ ${#available_packages[@]} -gt 0 ]]; then
    sudo nala install -y "${available_packages[@]}"
    msg_success "Installed ${#available_packages[@]} packages"
  fi
}

install_oh_my_zsh() {
  msg_info "Installing Oh My ZSH..."
  local terminals_dir="$REPO_DIR/packages/terminals"

  if [[ -f "$terminals_dir/oh_my_zsh_install.sh" ]]; then
    run_script "$terminals_dir/oh_my_zsh_install.sh"
    msg_success "Oh My ZSH installed"
  else
    msg_error "oh_my_zsh_install.sh not found"
    return 1
  fi
}

install_oh_my_posh() {
  msg_info "Installing Oh My Posh..."
  local posh_themes_dir="$HOME/.poshthemes"
  local customization_dir="$REPO_DIR/customization"

  sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
  sudo chmod +x /usr/local/bin/oh-my-posh

  ensure_dir "$posh_themes_dir"
  wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O "$posh_themes_dir/themes.zip"
  unzip -qo "$posh_themes_dir/themes.zip" -d "$posh_themes_dir"
  rm -f "$posh_themes_dir/themes.zip"

  safe_symlink "$customization_dir/zsh/tj-dracula.omp.json" "$posh_themes_dir/tj-dracula.omp.json"
  msg_success "Oh My Posh installed"
}

install_fonts() {
  msg_info "Installing fonts..."
  local font_dir="/usr/share/fonts"
  local local_font_dir="$HOME/.local/share/fonts"

  ensure_dir "$local_font_dir"
  sudo mkdir -p "$font_dir"

  if [[ -d "$REPO_DIR/fonts" ]]; then
    local font_files=("$REPO_DIR/fonts"/*.ttf)
    if [[ -e "${font_files[0]}" ]]; then
      sudo cp "$REPO_DIR/fonts"/*.ttf "$font_dir/"
      cp "$REPO_DIR/fonts"/*.ttf "$local_font_dir/"
      fc-cache -fv >/dev/null 2>&1
      msg_success "Fonts installed"
    else
      msg_warning "No .ttf files found in $REPO_DIR/fonts"
    fi
  fi
}

install_logo_ls() {
  msg_info "Installing logo-ls..."
  local customization_dir="$REPO_DIR/customization"
  local tarball="$customization_dir/bash/logo-ls_Linux_x86_64.tar.gz"

  if [[ -f "$tarball" ]]; then
    cp "$tarball" "$DOWNLOADS_DIR/"
    cd "$DOWNLOADS_DIR" || return 1
    tar -zxf logo-ls_Linux_x86_64.tar.gz
    sudo cp logo-ls_Linux_x86_64/logo-ls /usr/local/bin/
    rm -rf logo-ls_Linux_x86_64 logo-ls_Linux_x86_64.tar.gz
    msg_success "logo-ls installed"
  else
    msg_warning "logo-ls tarball not found: $tarball"
  fi
}

setup_flatpak() {
  msg_info "Setting up Flatpak..."
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  msg_success "Flatpak configured"
}

install_homebrew() {
  msg_info "Installing HomeBrew..."
  local script="$REPO_DIR/packages/package-managers/brew_install.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "HomeBrew installed"
  else
    msg_error "brew_install.sh not found"
    return 1
  fi
}

install_shell_tools() {
  msg_info "Installing Oh My Bash..."
  local terminals_dir="$REPO_DIR/packages/terminals"

  if [[ -f "$terminals_dir/oh_my_bash_install.sh" ]]; then
    run_script "$terminals_dir/oh_my_bash_install.sh"
  fi

  msg_info "Installing Starship..."
  if [[ -f "$terminals_dir/starship_install.sh" ]]; then
    run_script "$terminals_dir/starship_install.sh"
  fi

  msg_success "Shell tools installed"
}

setup_tmux() {
  msg_info "Configuring Tmux..."
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  local customization_dir="$REPO_DIR/customization"

  remove_if_exists "$tpm_dir"
  ensure_dir "$HOME/.tmux/plugins"

  clone_repo "https://github.com/tmux-plugins/tpm" "$tpm_dir"
  safe_symlink "$customization_dir/tmux/.tmux.conf" "$HOME/.tmux.conf"

  # Source tmux config if tmux is available
  if command_exists tmux; then
    tmux new-session -d -s "setup_temp" 2>/dev/null || true
    tmux source "$HOME/.tmux.conf" 2>/dev/null || true
    tmux kill-session -t "setup_temp" 2>/dev/null || true
  fi
  msg_success "Tmux configured"
}

setup_asdf() {
  msg_info "Installing ASDF..."

  remove_if_exists "$HOME/.asdf"
  clone_repo "https://github.com/asdf-vm/asdf.git" "$HOME/.asdf" "v0.10.2"

  # Add to shell configs only if not already present
  local asdf_source='. "$HOME/.asdf/asdf.sh"'
  grep -qxF "$asdf_source" "$HOME/.bashrc" 2>/dev/null || echo "$asdf_source" >>"$HOME/.bashrc"
  grep -qxF "$asdf_source" "$HOME/.zshrc" 2>/dev/null || echo "$asdf_source" >>"$HOME/.zshrc"

  msg_success "ASDF installed"
}

configure_homebrew_shell() {
  msg_info "Configuring HomeBrew in shell..."
  local brew_env='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

  grep -qxF "$brew_env" "$HOME/.bashrc" 2>/dev/null || echo "$brew_env" >>"$HOME/.bashrc"
  grep -qxF "$brew_env" "$HOME/.zshrc" 2>/dev/null || echo "$brew_env" >>"$HOME/.zshrc"

  msg_success "HomeBrew shell configured"
}

install_i3_gaps() {
  msg_info "Installing i3-gaps-rounded..."
  cd "$DOWNLOADS_DIR" || return 1

  remove_if_exists "i3-gaps"
  clone_repo "https://www.github.com/jbenden/i3-gaps-rounded" "i3-gaps"

  cd i3-gaps || return 1
  mkdir -p build && cd build || return 1
  meson ..
  ninja
  sudo ninja install

  cd "$DOWNLOADS_DIR" || return 1
  rm -rf i3-gaps

  msg_success "i3-gaps-rounded installed"
}

install_picom() {
  msg_info "Installing Picom..."
  cd "$DOWNLOADS_DIR" || return 1

  remove_if_exists "picom"
  clone_repo "https://github.com/yshui/picom.git" "picom"

  cd picom || return 1
  meson setup --buildtype=release build
  ninja -C build
  sudo ninja -C build install

  cd "$DOWNLOADS_DIR" || return 1
  rm -rf picom

  msg_success "Picom installed"
}

install_scrcpy() {
  msg_info "Installing Scrcpy..."
  cd "$DOWNLOADS_DIR" || return 1

  remove_if_exists "scrcpy"
  clone_repo "https://github.com/Genymobile/scrcpy" "scrcpy"

  cd scrcpy || return 1
  if [[ -x "./install_release.sh" ]]; then
    ./install_release.sh
  fi

  cd "$DOWNLOADS_DIR" || return 1
  rm -rf scrcpy

  msg_success "Scrcpy installed"
}

install_rofi_themes() {
  msg_info "Installing Rofi themes..."
  cd "$DOWNLOADS_DIR" || return 1

  remove_if_exists "rofi"
  git clone --quiet --depth=1 https://github.com/adi1090x/rofi.git

  cd rofi || return 1
  chmod +x setup.sh
  ./setup.sh

  # Remove default rofi config to use our own
  remove_if_exists "$HOME/.config/rofi"

  cd "$DOWNLOADS_DIR" || return 1
  rm -rf rofi

  msg_success "Rofi themes installed"
}

apply_stow_configs() {
  msg_info "Applying stow configurations..."
  cd "$REPO_DIR/stow" || return 1

  local configs=(
    "autostart" "btop" "cava" "dunst" "i3" "kitty" "lazygit"
    "nvim" "nitrogen" "polybar" "rofi" "vim" "ranger"
    "gtk-3.0" "gtk-2.0" "gtk-4.0"
  )

  for config in "${configs[@]}"; do
    local target_dir="$HOME/.config/$config"
    remove_if_exists "$target_dir"
    ensure_dir "$target_dir"
    stow -v -t "$target_dir" "$config"
    msg_info "Applied stow config: $config"
  done

  # X11 configuration files
  safe_symlink "$REPO_DIR/stow/picom.conf" "$HOME/.config/picom.conf"
  safe_symlink "$REPO_DIR/stow/Xresources" "$HOME/.Xresources"
  safe_symlink "$REPO_DIR/stow/.xprofile" "$HOME/.xprofile"
  safe_symlink "$REPO_DIR/stow/.xsession" "$HOME/.xsession"
  safe_symlink "$REPO_DIR/stow/.Xinitrc" "$HOME/.Xinitrc"
  safe_symlink "$REPO_DIR/stow/Xauthority" "$HOME/.Xauthority"

  # Wallpapers and scripts
  cd "$REPO_DIR" || return 1
  ensure_dir "$HOME/Pictures"
  stow -v -t "$HOME/Pictures" wallpapers
  ensure_dir "$HOME/scripts"
  stow -v -t "$HOME/scripts" scripts

  msg_success "Stow configurations applied"
}

install_gtk_themes() {
  msg_info "Installing GTK themes and icons..."
  cd "$DOWNLOADS_DIR" || return 1

  # Dracula GTK theme
  remove_if_exists "master.zip"
  remove_if_exists "gtk-master"
  remove_if_exists "Dracula"

  wget -q https://github.com/dracula/gtk/archive/master.zip
  unzip -q master.zip
  mv gtk-master Dracula
  ensure_dir "$HOME/.themes"
  mv Dracula "$HOME/.themes/"
  rm -f master.zip

  # Tela icon theme
  remove_if_exists "Tela-icon-theme"
  clone_repo "https://github.com/vinceliuice/Tela-icon-theme.git" "Tela-icon-theme"

  cd Tela-icon-theme || return 1
  ./install.sh -n dracula
  cd "$DOWNLOADS_DIR" || return 1
  rm -rf Tela-icon-theme

  msg_success "GTK themes installed"
}

install_i3lock_color() {
  msg_info "Installing i3lock-color..."
  local script="$REPO_DIR/packages/programs/i3lock-color.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "i3lock-color installed"
  else
    msg_warning "i3lock-color.sh not found"
  fi
}

install_gedit_dracula() {
  msg_info "Installing Dracula theme for gedit..."
  cd "$DOWNLOADS_DIR" || return 1

  remove_if_exists "dracula.xml"
  wget -q https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
  ensure_dir "$HOME/.local/share/gedit/styles"
  mv dracula.xml "$HOME/.local/share/gedit/styles/"

  msg_success "Gedit Dracula theme installed"
}

create_shell_symlinks() {
  msg_info "Creating shell configuration symlinks..."
  local customization_dir="$REPO_DIR/customization"

  local -A files=(
    ["$HOME/.zshrc"]="$customization_dir/zsh/.zshrc"
    ["$HOME/.zsh_aliases"]="$customization_dir/zsh/.zsh_aliases"
    ["$HOME/.bashrc"]="$customization_dir/bash/.bashrc"
    ["$HOME/.bash_aliases"]="$customization_dir/bash/.bash_aliases"
    ["$HOME/.config/starship.toml"]="$customization_dir/starship/starship.toml"
    ["$HOME/.gitconfig"]="$customization_dir/git/.gitconfig"
  )

  for target in "${!files[@]}"; do
    local source="${files[$target]}"
    if [[ -f "$source" ]]; then
      ensure_dir "$(dirname "$target")"
      safe_symlink "$source" "$target"
    else
      msg_warning "Source file not found: $source"
    fi
  done

  msg_success "Shell symlinks created"
}

setup_snap() {
  msg_info "Setting up Snap..."
  local nosnap_pref="/etc/apt/preferences.d/nosnap.pref"

  if [[ -f "$nosnap_pref" ]]; then
    sudo rm -f "$nosnap_pref"
  fi

  sudo apt update
  sudo apt install -y snapd || msg_warning "Failed to install snapd"

  msg_success "Snap configured"
}

install_flutter() {
  msg_info "Installing Flutter..."
  local script="$REPO_DIR/packages/development-tools/flutter.sh"

  if [[ -f "$script" ]]; then
    run_script "$script"
    msg_success "Flutter installed"
  else
    msg_warning "flutter.sh not found"
  fi
}

create_directories() {
  msg_info "Creating directories..."
  ensure_dir "$HOME/Development"
  ensure_dir "$HOME/.icons"
  ensure_dir "$HOME/.themes"
  ensure_dir "$HOME/scripts"
  ensure_dir "$DOWNLOADS_DIR"
  msg_success "Directories created"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
  echo "=============================================="
  echo "  Linux Mint Setup - Part 1"
  echo "=============================================="
  log "INFO" "Starting installation part 1"

  # Pre-flight checks
  if [[ ! -d "$REPO_DIR" ]]; then
    msg_error "Repository directory not found: $REPO_DIR"
    exit 1
  fi

  create_directories
  install_packages
  install_oh_my_zsh
  install_oh_my_posh
  install_fonts
  install_logo_ls
  setup_flatpak
  install_homebrew
  install_shell_tools
  setup_tmux
  configure_homebrew_shell
  setup_asdf
  install_i3_gaps
  install_flutter
  install_picom
  install_scrcpy
  install_rofi_themes
  apply_stow_configs
  install_gtk_themes
  install_i3lock_color
  install_gedit_dracula
  create_shell_symlinks
  setup_snap

  msg_success "Installation part 1 completed!"
  echo ""
  echo "=============================================="
  echo "  System will reboot now."
  echo "  After reboot, run installation_2.sh"
  echo "=============================================="

  read -rp "Press Enter to reboot or Ctrl+C to cancel..."
  sudo reboot now
}

main "$@"
