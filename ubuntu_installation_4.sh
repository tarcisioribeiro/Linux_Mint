#!/usr/bin/bash
set -e

flatpak install flathub com.getpostman.Postman
flatpak install flathub org.gabmus.hydrapaper
# flatpak install flathub net.pcsx2.PCSX2

DISK_PATH="/media/tarcisio/Seagate"
PACKAGE_PATH="$DISK_PATH/Packages"
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

# chrome.deb

for pkg in code.deb discord.deb obsidian.deb steam.deb upscayl.deb; do
  if [ -f "$pkg" ]; then
    sudo gdebi -n "$pkg"
  else
    echo "Aviso: $pkg não encontrado. Pulando..."
  fi
done

rm -f *.deb

echo "Instalação concluída!"

sudo chsh -s /usr/bin/zsh
cd "$HOME/Documents/Ubuntu/customization/bash" || exit
sudo cp .bashrc_root /root && sudo mv /root/.bashrc_root /root/.bashrc
sudo cp .bash_aliases_root /root && sudo mv /root/.bash_aliases_root /root/.bash_aliases

cd "$HOME/Documents/Ubuntu/customization/zsh" || exit
sudo cp .zshrc_root /root && sudo mv /root/.zshrc_root /root/.zshrc
sudo cp .zsh_aliases_root /root && sudo mv /root/.zsh_aliases_root /root/.zsh_aliases
sudo cp -r "$HOME/.oh-my-zsh" /root

cd "$HOME/Documents/Ubuntu"
sudo cp -r scripts /root
sudo snap install glow
