#!/usr/bin/bash

# Pacotes Brew
brew install fd git-delta vim lazygit eza onefetch tldr zoxide

# Pacotes Flatpak
flatpak install flathub com.getpostman.Postman
flatpak install flathub io.github.shiftey.Desktop
flatpak install flathub org.telegram.desktop

# Pacotes Deb
cp /media/tarcisio/Seagate/Packages/*.deb "$HOME/Downloads"
cd "$HOME/Downloads"
sudo gdebi chrome.deb
sudo gdebi code.deb
sudo gdebi discord.deb
sudo gdebi obsidian.deb
sudo gdebi upscayl.deb
sudo gdebi virtualbox.deb
rm *.deb

