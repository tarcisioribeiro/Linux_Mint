#!/bin/bash

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf

cd "$HOME/Development/Linux_Mint/packages/development-tools" || exit
./docker_install.sh

cd "$HOME"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

cd "$HOME/Development/Linux_Mint/packages/package-managers" || exit
./asdf_packages.sh

cd "$HOME/Downloads"
git clone https://github.com/dracula/ranger.git
cd ranger
cp dracula.py "$HOME/.config/ranger/colorschemes/dracula.py"
cd "$HOME/Downloads"
sudo rm -r ranger

cd "$HOME/Development/Linux_Mint/packages/programs" || exit
./kitty_install.sh

flatpak install flathub com.getpostman.Postman
flatpak install flathub org.gabmus.hydrapaper

DISK_PATH="/media/tarcisio/Seagate"
PACKAGE_PATH="$DISK_PATH/Programas/Pacotes"
DOWNLOAD_PATH="$HOME/Downloads"

if mount | grep -q "$DISK_PATH"; then
  echo "Disco montado: $DISK_PATH"
else
  echo "Erro: O disco não está montado!"
  exit 1
fi

if [ ! -d "$PACKAGE_PATH" ]; then
  echo "Erro: O diretório $PACKAGE_PATH não existe!"
  exit 1
fi

if ls "$PACKAGE_PATH"/*.deb 1>/dev/null 2>&1; then
  echo "Pacotes encontrados, iniciando instalação..."
else
  echo "Erro: Nenhum pacote .deb encontrado em $PACKAGE_PATH!"
  exit 1
fi

cp "$PACKAGE_PATH"/*.deb "$DOWNLOAD_PATH"

cd "$DOWNLOAD_PATH" || exit 1

for pkg in code.deb discord.deb obsidian.deb mysql-workbench.deb chrome.deb; do
  if [ -f "$pkg" ]; then
    sudo gdebi -n "$pkg"
  else
    echo "Aviso: $pkg não encontrado. Pulando..."
  fi
done

rm -f *.deb

echo "Instalação concluída!"

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
