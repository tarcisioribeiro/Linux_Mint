#!/usr/bin/bash
cd "$HOME/repos/Ubuntu/wallpapers" || exit
cp versions/dracula-skyline-night.png dracula-skyline.png
cp versions/dracula-drag-race-night.png dracula-drag-race.png
cp versions/dracula-race-circuit-night.png dracula-race-circuit.png
nitrogen --restore
