#!/usr/bin/bash
cd ~/repos/Ubuntu/wallpapers
cp versions/dracula-skyline-night.png dracula-skyline.png
cp versions/dracula-programming-room-night.png dracula-programming-room.png
cp versions/dracula-jet-fighters-night.png dracula-jet-fighters.png
nitrogen --restore
echo "Alterado com sucesso."
