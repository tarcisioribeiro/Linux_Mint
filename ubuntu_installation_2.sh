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

blue "Instalando o i3wm..."
cd "$HOME/Downloads" || exit
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
cd "$HOME/Downloads" || exit
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo rm keyring.deb
sudo apt install i3

echo "Instalando gaps do i3..."
cd "$HOME/Downloads" || exit
git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps
cd i3-gaps || exit
mkdir -p build
cd build || exit
meson ..
ninja
sudo ninja install
cd "$HOME/Downloads" || exit
sudo rm -r i3-gaps

blue "Baixando o Flutter..."
cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./flutter.sh

blue "Instalando o picom..."
cd "$HOME/Downloads" || exit
git clone https://github.com/yshui/picom.git
cd picom || exit
meson setup --buildtype=release build
sudo ninja -C build
sudo ninja -C build install
cd "$HOME/Downloads" || exit
sudo rm -r picom/

blue "Instalando o scrcpy..."
cd "$HOME/Downloads" || exit
git clone https://github.com/Genymobile/scrcpy
cd scrcpy || exit
./install_release.sh
cd "$HOME/Downloads" || exit
sudo rm -r scrcpy

cd "$HOME/Downloads" || exit
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi || exit
chmod +x setup.sh
./setup.sh
rm -r ~/.config/rofi
cd "$HOME/Downloads" || exit
sudo rm -r rofi

cd "$HOME/repos/Ubuntu/stow" || exit
mkdir -p "$HOME/.config/autostart" && stow -v -t "$HOME/.config/autostart" autostart
mkdir -p "$HOME/.config/btop" && stow -v -t "$HOME/.config/btop" btop
mkdir -p "$HOME/.config/cava" && stow -v -t "$HOME/.config/cava" cava
mkdir -p "$HOME/.config/dunst" && stow -v -t "$HOME/.config/dunst" dunst
mkdir -p "$HOME/.config/gtk-3.0" && stow -v -t "$HOME/.config/gtk-3.0" gtk-3.0
mkdir -p "$HOME/.config/i3" && stow -v -t "$HOME/.config/i3" i3
mkdir -p "$HOME/.config/alacritty" && stow -v -t "$HOME/.config/alacritty" alacritty
mkdir -p "$HOME/.config/lazygit" && stow -v -t "$HOME/.config/lazygit" lazygit
mkdir -p "$HOME/.config/nitrogen" && stow -v -t "$HOME/.config/nitrogen" nitrogen
mkdir -p "$HOME/.config/nvim" && stow -v -t "$HOME/.config/nvim" nvim
mkdir -p "$HOME/.config/polybar" && stow -v -t "$HOME/.config/polybar" polybar
mkdir -p "$HOME/.config/rofi" && stow -v -t "$HOME/.config/rofi" rofi
mkdir -p "$HOME/.config/ranger" && stow -v -t "$HOME/.config/ranger" ranger
mkdir -p "$HOME/.config/spotify-tui" && stow -v -t "$HOME/.config/spotify-tui" spotify-tui
mkdir -p "$HOME/.config/spicetify" && stow -v -t "$HOME/.config/spicetify" spicetify
ln picom.conf "$HOME/.config/picom.conf"
ln Xresources "$HOME/Xresources"

cd "$HOME/repos/Ubuntu/" || exit
mkdir -p "$HOME/Pictures" && stow -v -t "$HOME/Pictures" wallpapers
mkdir -p "$HOME/scripts" && stow -v -t "$HOME/scripts" scripts

cd "$HOME/Downloads/" || exit
wget -q https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master Dracula
mv Dracula "$HOME/.themes"
rm master.zip
cd "$HOME/Downloads" || exit
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme || exit
./install.sh -n dracula
cd ..
sudo rm -r Tela-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "dracula-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono NFM 11"
gsettings set org.gnome.cursor.interface cursor-theme "breeze_cursors"

blue "Instalando o i3lock-color..."
cd "$HOME/repos/Ubuntu/packages/terminals" || exit
./i3lock-color.sh

cd "$HOME/Downloads" || exit
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
mkdir -p ~/.local/share/gedit/styles/
mv dracula.xml ~/.local/share/gedit/styles/

rm "$HOME/.zshrc" && rm "$HOME/.zsh_aliases" && rm "$HOME/.bashrc" && rm "$HOME/.bash_aliases"
cd "$HOME/repos/Ubuntu/customization" || exit
ln zsh/.zshrc "$HOME/.zshrc" && ln zsh/.zsh_aliases "$HOME/.zsh_aliases"
ln bash/.bashrc "$HOME/.bashrc" && ln bash/.bash_aliases "$HOME/.bash_aliases"
ln starship/starship.toml "$HOME/.config/starship.toml"
ln git/.gitconfig "$HOME/.gitconfig"
