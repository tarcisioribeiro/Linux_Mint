#!/bin/bash
set -e

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


cd "$HOME/Documents/Ubuntu/packages/development-tools" || exit
./docker_install.sh
cd "$HOME/Documents/Ubuntu/packages/programs" || exit
./android-studio.sh

cd "$HOME"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

cd "$HOME/Documents/Ubuntu/packages/package-managers" || exit
./asdf_packages.sh

cd "$HOME/Downloads"
git clone https://github.com/dracula/ranger.git
cd ranger
cp dracula.py "$HOME/.config/ranger/colorschemes/dracula.py"
cd "$HOME/Downloads"
sudo rm -r ranger

cd "$HOME/Documents/Ubuntu/packages/programs" || exit
./kitty_install.sh
