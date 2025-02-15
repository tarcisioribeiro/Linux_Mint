#!/bin/sh
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
cd ~/Downloads
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
cd ~/Downloads
sudo rm -r i3lock-color