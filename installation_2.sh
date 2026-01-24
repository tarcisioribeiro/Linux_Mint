#!/bin/bash
set -euo pipefail

sudo apt update
sudo apt upgrade -y

if ! command -v brew >/dev/null 2>&1; then
  echo "Erro: comando 'brew' não encontrado. Reinicie o dispositivo." >&2
  exit 1
fi

# Remover Firefox completamente
echo "Removendo Firefox completamente..."
if command -v firefox >/dev/null 2>&1; then
  # Remover via apt
  sudo apt remove --purge -y firefox firefox-locale-* || true
  sudo apt autoremove -y

  # Remover via snap se existir
  if snap list firefox 2>/dev/null; then
    sudo snap remove --purge firefox
  fi

  # Remover diretórios de configuração
  rm -rf "$HOME/.mozilla/firefox"
  rm -rf "$HOME/.cache/mozilla/firefox"
  rm -rf "$HOME/snap/firefox"

  echo "Firefox removido com sucesso."
else
  echo "Firefox não está instalado."
fi

# Instalar pacotes .deb do diretório externo, se montado
DEB_PACKAGES_DIR="/media/tarcisio/Seagate/Linux/Programs/Packages"
if [ -d "$DEB_PACKAGES_DIR" ] && mountpoint -q "/media/tarcisio/Seagate"; then
  echo "Diretório de pacotes .deb encontrado e montado: $DEB_PACKAGES_DIR"

  # Contar pacotes .deb disponíveis
  DEB_COUNT=$(find "$DEB_PACKAGES_DIR" -maxdepth 1 -name "*.deb" 2>/dev/null | wc -l)

  if [ "$DEB_COUNT" -gt 0 ]; then
    echo "Encontrados $DEB_COUNT pacotes .deb. Instalando..."

    # Instalar todos os pacotes .deb
    for deb_file in "$DEB_PACKAGES_DIR"/*.deb; do
      if [ -f "$deb_file" ]; then
        echo "Instalando: $(basename "$deb_file")"
        sudo apt install -y "$deb_file" || {
          echo "Erro ao instalar $(basename "$deb_file"). Tentando corrigir dependências..."
          sudo apt --fix-broken install -y
        }
      fi
    done

    echo "Instalação de pacotes .deb concluída."
  else
    echo "Nenhum pacote .deb encontrado em $DEB_PACKAGES_DIR"
  fi
else
  echo "Diretório $DEB_PACKAGES_DIR não está montado ou não existe. Pulando instalação de pacotes .deb."
fi

cd "$HOME/Development/Linux_Mint/packages/development-tools" || exit
./docker_install.sh

# Configurar Ranger
# Criar diretórios necessários
mkdir -p "$HOME/.config/ranger/plugins"
mkdir -p "$HOME/.config/ranger/colorschemes"

# Remover ranger_devicons se já existir
if [ -d "$HOME/.config/ranger/plugins/ranger_devicons" ]; then
  echo "Removendo ranger_devicons existente..."
  rm -rf "$HOME/.config/ranger/plugins/ranger_devicons"
fi

cd "$HOME"
git clone --quiet https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

cd "$HOME/Development/Linux_Mint/packages/package-managers" || exit
./asdf_packages.sh

# Instalar tema Dracula para Ranger
cd "$HOME/Downloads"
# Remover diretório ranger se já existir
[ -d "ranger" ] && rm -rf ranger
git clone --quiet https://github.com/dracula/ranger.git
cd ranger
cp dracula.py "$HOME/.config/ranger/colorschemes/dracula.py"
cd "$HOME/Downloads"
rm -rf ranger

cd "$HOME/Development/Linux_Mint/packages/programs" || exit
./kitty_install.sh

flatpak install flathub com.getpostman.Postman
flatpak install flathub org.telegram.desktop
flatpak install flathub org.flameshot.Flameshot

sudo chsh -s /usr/bin/zsh
cd "$HOME/Development/Linux_Mint/customization/bash" || exit
sudo cp .bashrc_root /root && sudo mv /root/.bashrc_root /root/.bashrc
sudo cp .bash_aliases_root /root && sudo mv /root/.bash_aliases_root /root/.bash_aliases

cd "$HOME/Development/Linux_Mint/customization/zsh" || exit
sudo cp .zshrc_root /root && sudo mv /root/.zshrc_root /root/.zshrc
sudo cp .zsh_aliases_root /root && sudo mv /root/.zsh_aliases_root /root/.zsh_aliases
sudo cp -r "$HOME/.oh-my-zsh" /root

cd "$HOME/Development/Linux_Mint"
sudo cp -r scripts /root

# sudo snap install android-studio --classic

cd "$HOME/Development/Linux_Mint/stow/"
sudo cp i3.desktop /usr/share/xsessions/

curl -fsSL https://claude.ai/install.sh | bash

sudo reboot now
