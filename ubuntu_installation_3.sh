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
brew install fd git-delta vim lazygit eza onefetch spotifyd tldr zoxide

cd "$HOME/repos/Ubuntu/packages/programs" || exit
./alacritty_install.sh

cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./docker_install.sh

cd "$HOME/repos/Ubuntu/packages/package-managers" || exit
./asdf_packages.sh

sudo apt update && sudo apt upgrade
cd /tmp && wget -qO- https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg && cd $HOME
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client
