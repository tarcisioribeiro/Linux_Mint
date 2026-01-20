#!/usr/bin/bash

set -e

sudo apt update
sudo apt upgrade -y

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf fastfetch glow

pip install pyautogui

sleep 2

cd $HOME/Downloads/
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sleep 2

cd $HOME/Development/Linux_Mint/scripts/installer
python3 main.py

sudo reboot now
