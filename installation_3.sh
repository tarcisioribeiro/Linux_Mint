#!/usr/bin/bash

set -e

sudo apt update
sudo apt upgrade -y

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf fastfetch glow

sleep 2

sudo reboot now
