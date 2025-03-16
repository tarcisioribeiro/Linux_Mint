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

cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./docker_install.sh

cd "$HOME/repos/Ubuntu/packages/package-managers" || exit
./asdf_packages.sh

curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install spotify-client

sudo chmod -R 777 /usr/share/spotify

curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

read -r -p "Reiniciar agora? (s/n): " choice
if [[ "$choice" == "s" ]]; then
  sudo reboot
fi
