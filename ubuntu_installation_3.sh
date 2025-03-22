#!/bin/bash
green() {
  clear
  echo ""
  echo -e "\033[32m$1\033[0m"
  echo ""
  sleep 2
}

blue() {
  clear
  echo ""
  echo -e "\033[34m$1\033[0m"
  echo ""
  sleep 2
}

cd "$HOME/repos/Ubuntu/packages/programs" || exit
./alacritty_install.sh
cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./docker_install.sh
cd "$HOME/repos/Ubuntu/packages/package-managers" || exit
./asdf_packages.sh
cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./android-studio.sh

sudo apt update && sudo apt upgrade
cd /tmp && wget -qO- https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg && cd $HOME
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client
cd "$HOME"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
cd "$HOME/Downloads"
git clone https://github.com/dracula/ranger.git
cd ranger
cp dracula.py "$HOME/.config/ranger/colorschemes/dracula.py"
cd "$HOME/Downloads"
sudo rm -r ranger

sudo nala remove gnome-mines gnome-mahjongg transmission-common transmission-gtk \
  gnome-sudoku aisleriot mpv imagemagick-6-common imagemagick-6.q16 imagemagick \
  libmagickcore-6.q16-6-extra libmagickcore-6.q16-6 libmagickwand-6.q16-6 remmina \
  remmina-common remmina-plugin-rdp remmina-plugin-secret remmina-plugin-vnc
