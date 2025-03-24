#!/bin/sh
cd "$HOME/Downloads"
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
cd "$HOME/Downloads"
rm -rf i3lock-color

