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

