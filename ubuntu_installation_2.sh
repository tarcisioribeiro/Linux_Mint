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
cd "$HOME/Documents/Ubuntu/packages/development-tools" || exit
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

cd "$HOME/Documents/Ubuntu/stow" || exit

declare -a configs=(
  "autostart"
  "btop"
  "cava"
  "dunst"
  "gtk-3.0"
  "i3"
  "kitty"
  "lazygit"
  "nitrogen"
  "nvim"
  "polybar"
  "rofi"
  "ranger"
)

for config in "${configs[@]}"; do
  target_dir="$HOME/.config/$config"
  if [ -e "$target_dir" ]; then
    rm -rf "$target_dir"
  fi
  mkdir -p "$target_dir"
  stow -v -t "$target_dir" "$config"
done

if [ -e "$HOME/.config/picom.conf" ]; then
  rm "$HOME/.config/picom.conf"
fi
ln -s "$HOME/Documents/Ubuntu/stow/picom.conf" "$HOME/.config/picom.conf"

if [ -e "$HOME/Xresources" ]; then
  rm "$HOME/Xresources"
fi
ln -s "$HOME/Documents/Ubuntu/stow/Xresources" "$HOME/Xresources"

cd "$HOME/Documents/Ubuntu/" || exit
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

blue "Instalando o i3lock-color..."
cd "$HOME/Documents/Ubuntu/packages/programs/" || exit
./i3lock-color.sh

cd "$HOME/Downloads" || exit
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
mkdir -p ~/.local/share/gedit/styles/
mv dracula.xml ~/.local/share/gedit/styles/

files=(
  "$HOME/.zshrc:$HOME/Documents/Ubuntu/customization/zsh/.zshrc"
  "$HOME/.zsh_aliases:$HOME/Documents/Ubuntu/customization/zsh/.zsh_aliases"
  "$HOME/.bashrc:$HOME/Documents/Ubuntu/customization/bash/.bashrc"
  "$HOME/.bash_aliases:$HOME/Documents/Ubuntu/customization/bash/.bash_aliases"
  "$HOME/.config/starship.toml:$HOME/Documents/Ubuntu/customization/starship/starship.toml"
  "$HOME/.gitconfig:$HOME/Documents/Ubuntu/customization/git/.gitconfig"
)

for file in "${files[@]}"; do
  target="${file%%:*}"
  source="${file##*:}"
  if [ -e "$target" ]; then
    rm "$target"
  fi
  ln -s "$source" "$target"
done

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf
