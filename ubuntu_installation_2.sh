#!/usr/bin/bash
red() {
    echo -e "\033[31m$1\033[0m"
}
green() {
    echo -e "\033[32m$1\033[0m"
}

blue() {
    echo -e "\033[34m$1\033[0m"
}

brew install eza glow tldr fd git-delta
nvm install 20.17.0

git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
mv ~/.config/nvim ~/.config/nvim_old
cp -r ~/repos/Terminal/customization/nvim ~/.config

mkdir -p ~/.config/tilix/schemes/
wget  -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT

sleep 3

cd ~/Downloads


blue "\nInstalando o i3wm...\n"

sleep 3

sudo apt install -y build-essential libxcb1-dev libxcb-keysyms1-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
libxcb-randr0-dev libxcb-xinerama0-dev \
libpango1.0-dev libx11-dev libxrandr-dev libxinerama-dev \
libxss-dev libglib2.0-dev libev-dev

sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev

/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update

sudo apt install i3

blue "\nInstalando o i3lock-color...\n"
sleep 3
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
cd ~/Downloads
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh

cp ~/repos/Ubuntu/scripts/lock ~/scripts/

blue "\nInstalando gaps do i3...\n"

cd ~/Downloads
git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson ..
ninja
sudo ninja install

sudo mv /usr/share/mysql-workbench/data/code_editor.xml /usr/share/mysql-workbench/data/code_editor_old.xml
sudo cp ~/repos/Ubuntu/mysql/code_editor.xml /usr/share/mysql-workbench/

sudo nala install cmatrix pavucontrol

cp ~/repos/Ubuntu/packages/ookla-speedtest-1.2.0-linux-x86_64.tgz ~/Downloads
cd ~/Downloads
sudo tar -xvzf ookla-speedtest-1.2.0-linux-x86_64.tgz -C /usr/bin
rm ookla-speedtest-1.2.0-linux-x86_64.tgz