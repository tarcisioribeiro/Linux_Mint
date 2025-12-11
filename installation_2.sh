#!/bin/bash

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf

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
flatpak install flathub org.gabmus.hydrapaper

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

sudo snap install android-studio --classic

cd "$HOME/Development/Linux_Mint/stow/"
sudo cp i3.desktop /usr/share/xsessions/

mkdir -p "$HOME/.config/tilix/schemes"
sleep 2
wget -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT
brew install fastfetch
