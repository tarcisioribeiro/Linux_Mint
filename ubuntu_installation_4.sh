#!/usr/bin/bash
flatpak install flathub com.getpostman.Postman
flatpak install flathub io.github.shiftey.Desktop
flatpak install flathub org.telegram.desktop

cp /media/tarcisio/Seagate/Packages/*.deb "$HOME/Downloads"
cd "$HOME/Downloads"
sudo gdebi chrome.deb
sudo gdebi code.deb
sudo gdebi discord.deb
sudo gdebi obsidian.deb
sudo gdebi upscayl.deb
sudo gdebi virtualbox.deb
rm *.deb

cd "$HOME/repos/Ubuntu/packages/programs"
./android-studio.sh

sudo chsh -s /usr/bin/zsh
cd "$HOME/repos/Ubuntu/customization/bash" || exit
sudo cp .bashrc_root /root && sudo mv /root/.bashrc_root /root/.bashrc
sudo cp .bash_aliases_root /root && sudo mv /root/.bash_aliases_root /root/.bash_aliases

cd "$HOME/repos/Ubuntu/customization/zsh" || exit
sudo cp .zshrc_root /root && sudo mv /root/.zshrc_root /root/.zshrc
sudo cp .zsh_aliases_root /root && sudo mv /root/.zsh_aliases_root /root/.zsh_aliases
sudo cp -r "$HOME/.oh-my-zsh" /root

cd "$HOME/repos/Ubuntu"
sudo cp -r scripts /root
