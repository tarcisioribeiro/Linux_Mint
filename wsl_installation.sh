#!/usr/bin/bash
set -euo pipefail

msg_color() {
  clear
  echo -e "\n\033[$1m$2\033[0m\n"
  sleep 2
}

# WSL-specific packages (CLI tools only, no GUI/X11/desktop components)
PACKAGES=(
  # Build essentials
  toilet curl wget build-essential gcc g++ clang make cmake automake autoconf git stow pkg-config meson ninja-build scdoc

  # CLI utilities
  neofetch tmux fzf bat gdebi flatpak openssh-server gh p7zip pv jq zsh toilet unzip locate

  # Development libraries
  default-libmysqlclient-dev dkms perl ruby-full libsdl2-dev libusb-1.0-0-dev adb cpu-checker
  libvirt-daemon-system libvirt-clients bridge-utils ffmpeg libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev
  libswresample-dev libcurl4-openssl-dev libgd-dev libonig-dev libpq-dev libzip-dev

  # Python
  python3 python3-venv python3-tk python3-pip python3-openssl python3-full python3-dev
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev liblzma-dev tk-dev

  # System monitoring
  btop

  # File manager
  ranger

  # Go language
  golang
)

msg_color "34" "Instalando nala e atualizando sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt install nala -y

msg_color "34" "Atualizando pacotes..."
sudo nala update && sudo nala upgrade -y

msg_color "34" "Instalando dependências WSL em grupos..."

# Install packages in smaller groups to avoid dependency resolution issues
ESSENTIAL_BUILD=(
  toilet curl wget build-essential gcc g++ clang make cmake automake autoconf git stow pkg-config meson ninja-build scdoc
)

CLI_TOOLS=(
  neofetch tmux fzf bat gdebi flatpak openssh-server gh p7zip pv jq zsh unzip locate
)

DEV_LIBRARIES=(
  default-libmysqlclient-dev dkms perl ruby-full libsdl2-dev libusb-1.0-0-dev adb cpu-checker
  libvirt-daemon-system libvirt-clients bridge-utils ffmpeg libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev
  libswresample-dev libcurl4-openssl-dev libgd-dev libonig-dev libpq-dev libzip-dev
)

PYTHON_PACKAGES=(
  python3 python3-venv python3-tk python3-pip python3-openssl python3-full python3-dev
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev liblzma-dev tk-dev
)

MISC_PACKAGES=(
  btop ranger golang
)

# Function to install packages with error handling
install_group() {
  local group_name="$1"
  shift
  local packages=("$@")

  msg_color "36" "Instalando $group_name..."

  if sudo nala install -y "${packages[@]}" 2>&1 | tee -a "$HOME/.wsl_install.log"; then
    msg_color "32" "$group_name instalado com sucesso!"
  else
    msg_color "31" "Erro ao instalar $group_name. Tentando instalar pacotes individualmente..."

    for pkg in "${packages[@]}"; do
      if sudo nala install -y "$pkg" 2>&1 | tee -a "$HOME/.wsl_install.log"; then
        echo "  ✓ $pkg instalado"
      else
        echo "  ✗ $pkg falhou (será ignorado)"
      fi
    done
  fi
}

# Install each group
install_group "Build Essentials" "${ESSENTIAL_BUILD[@]}"
install_group "CLI Tools" "${CLI_TOOLS[@]}"
install_group "Development Libraries" "${DEV_LIBRARIES[@]}"
install_group "Python Packages" "${PYTHON_PACKAGES[@]}"
install_group "Miscellaneous Packages" "${MISC_PACKAGES[@]}"

msg_color "34" "Removendo instalações anteriores de Oh My ZSH, Oh My Bash e Oh My Posh..."
REPO_DIR="$HOME/Development/Linux_Mint"
TERMINALS_DIR="$REPO_DIR/packages/terminals"
CUSTOMIZATION_DIR="$REPO_DIR/customization"

# Remove Oh My ZSH se existir
if [ -d "$HOME/.oh-my-zsh" ]; then
  msg_color "33" "Removendo Oh My ZSH existente..."
  rm -rf "$HOME/.oh-my-zsh"
fi

# Remove Oh My Bash se existir
if [ -d "$HOME/.oh-my-bash" ]; then
  msg_color "33" "Removendo Oh My Bash existente..."
  rm -rf "$HOME/.oh-my-bash"
fi

# Remove Oh My Posh se existir
if [ -f "/usr/local/bin/oh-my-posh" ]; then
  msg_color "33" "Removendo Oh My Posh existente..."
  sudo rm -f /usr/local/bin/oh-my-posh
fi

if [ -d "$HOME/.poshthemes" ]; then
  rm -rf "$HOME/.poshthemes"
fi

msg_color "34" "Instalando o Oh My ZSH..."
cd "$TERMINALS_DIR" && ./oh_my_zsh_install.sh || exit

msg_color "34" "Instalando o Oh My Posh..."
sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir -p "$HOME/.poshthemes"
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O "$HOME/.poshthemes/themes.zip"
unzip -q "$HOME/.poshthemes/themes.zip" -d "$HOME/.poshthemes"
rm "$HOME/.poshthemes/themes.zip"
ln -sf "$CUSTOMIZATION_DIR/zsh/tj-dracula.omp.json" "$HOME/.poshthemes/tj-dracula.omp.json"

msg_color "34" "Criando diretórios..."
mkdir -p "$HOME/Development" "$HOME/scripts"

msg_color "34" "Instalando fontes..."
LOCAL_FONT_DIR="$HOME/.local/share/fonts/"
mkdir -p "$LOCAL_FONT_DIR"
cd "$REPO_DIR/fonts" || exit
cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf "$LOCAL_FONT_DIR"
cp JetBrainsMonoNerdFontMono-*.ttf "$LOCAL_FONT_DIR"
fc-cache -fv

msg_color "34" "Instalando logo-ls..."
cp "$CUSTOMIZATION_DIR/bash/logo-ls_Linux_x86_64.tar.gz" "$HOME/Downloads"
cd "$HOME/Downloads" || exit
tar -zxf logo-ls_Linux_x86_64.tar.gz
sudo cp logo-ls_Linux_x86_64/logo-ls /usr/local/bin
rm -r logo-ls_Linux_x86_64 logo-ls_Linux_x86_64.tar.gz

msg_color "34" "Instalando o HomeBrew..."
cd "$REPO_DIR/packages/package-managers" && ./brew_install.sh || exit

msg_color "34" "Instalando o Oh My Bash..."
cd "$TERMINALS_DIR" && ./oh_my_bash_install.sh || exit

msg_color "34" "Instalando o Starship..."
cd "$TERMINALS_DIR" && ./starship_install.sh || exit

msg_color "34" "Configurando Tmux..."
# Remove TPM se já existir
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  msg_color "33" "Removendo TPM existente..."
  rm -rf "$HOME/.tmux/plugins/tpm"
fi
# Criar diretório pai antes de clonar
mkdir -p "$HOME/.tmux/plugins"
git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
# Remover symlink antigo se existir
[ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf"
ln -sf "$CUSTOMIZATION_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
tmux new-session -d -s "dev" 2>/dev/null || true
tmux source "$HOME/.tmux.conf" 2>/dev/null || true
tmux kill-session -t "dev" 2>/dev/null || true

msg_color "34" "Configurando HomeBrew e ASDF no shell..."
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' | tee -a "$HOME/.bashrc" "$HOME/.zshrc" >/dev/null

# Remove ASDF se já existir
if [ -d "$HOME/.asdf" ]; then
  msg_color "33" "Removendo ASDF existente..."
  rm -rf "$HOME/.asdf"
fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
echo ". $HOME/.asdf/asdf.sh" >>~/.bashrc
echo ". $HOME/.asdf/asdf.sh" >>~/.zshrc

msg_color "34" "Aplicando configurações stow (CLI tools only)..."
cd "$HOME/Development/Linux_Mint/stow" || exit

declare -a configs=(
  "btop"
  "lazygit"
  "vim"
  "ranger"
)

for config in "${configs[@]}"; do
  target_dir="$HOME/.config/$config"
  if [ -e "$target_dir" ]; then
    rm -rf "$target_dir"
  fi
  mkdir -p "$target_dir"
  stow -v -t "$target_dir" "$config"
done

msg_color "34" "Linkando arquivos de configuração shell..."
files=(
  "$HOME/.zshrc:$HOME/Development/Linux_Mint/customization/zsh/.zshrc"
  "$HOME/.zsh_aliases:$HOME/Development/Linux_Mint/customization/zsh/.zsh_aliases"
  "$HOME/.bashrc:$HOME/Development/Linux_Mint/customization/bash/.bashrc"
  "$HOME/.bash_aliases:$HOME/Development/Linux_Mint/customization/bash/.bash_aliases"
  "$HOME/.config/starship.toml:$HOME/Development/Linux_Mint/customization/starship/starship.toml"
  "$HOME/.gitconfig:$HOME/Development/Linux_Mint/customization/git/.gitconfig"
)

for file in "${files[@]}"; do
  target="${file%%:*}"
  source="${file##*:}"
  if [ -e "$target" ]; then
    rm "$target"
  fi
  ln -s "$source" "$target"
done

msg_color "34" "Instalando ferramentas via Homebrew..."
# Carregar Homebrew no shell atual antes de instalar pacotes
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf

msg_color "34" "Instalando Docker..."
cd "$HOME/Development/Linux_Mint/packages/development-tools" || exit
./docker_install.sh

msg_color "34" "Configurando Ranger..."
# Criar diretórios necessários
mkdir -p "$HOME/.config/ranger/plugins"
mkdir -p "$HOME/.config/ranger/colorschemes"

# Remover ranger_devicons se já existir
if [ -d "$HOME/.config/ranger/plugins/ranger_devicons" ]; then
  msg_color "33" "Removendo ranger_devicons existente..."
  rm -rf "$HOME/.config/ranger/plugins/ranger_devicons"
fi

# Clonar ranger_devicons
cd "$HOME"
git clone --quiet https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Instalar tema Dracula
cd "$HOME/Downloads"
# Remover diretório ranger se já existir
[ -d "ranger" ] && rm -rf ranger
git clone --quiet https://github.com/dracula/ranger.git
cd ranger
cp dracula.py "$HOME/.config/ranger/colorschemes/dracula.py"
cd "$HOME/Downloads"
rm -rf ranger

msg_color "34" "Instalando pacotes ASDF..."
cd "$HOME/Development/Linux_Mint/packages/package-managers" || exit
./asdf_packages.sh

msg_color "34" "Mudando shell padrão para ZSH..."
sudo chsh -s /usr/bin/zsh

msg_color "34" "Configurando shell do root..."
cd "$HOME/Development/Linux_Mint/customization/bash" || exit
sudo cp .bashrc_root /root && sudo mv /root/.bashrc_root /root/.bashrc
sudo cp .bash_aliases_root /root && sudo mv /root/.bash_aliases_root /root/.bash_aliases

cd "$HOME/Development/Linux_Mint/customization/zsh" || exit
sudo cp .zshrc_root /root && sudo mv /root/.zshrc_root /root/.zshrc
sudo cp .zsh_aliases_root /root && sudo mv /root/.zsh_aliases_root /root/.zsh_aliases
sudo cp -r "$HOME/.oh-my-zsh" /root

cd "$HOME/Development/Linux_Mint"
sudo cp -r scripts /root

msg_color "32" "Instalação WSL concluída com sucesso!"
msg_color "33" "Execute 'zsh' para iniciar o ZSH ou reinicie o terminal."
