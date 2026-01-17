#!/usr/bin/bash

set -e

sudo apt update
sudo apt upgrade -y

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf fastfetch glow

pip install pyautogui

sleep 2

cd $HOME/Development/Linux_Mint/scripts/installer
python3 main.py

sudo reboot now
