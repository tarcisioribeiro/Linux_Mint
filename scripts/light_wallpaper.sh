#!/usr/bin/bash
cd "$HOME/repos/Ubuntu/wallpapers" || exit
cp versions/dracula-skyline-day.png dracula-skyline.png
cp versions/dracula-drag-race-day.png dracula-drag-race.png
cp versions/dracula-race-circuit-day.png dracula-race-circuit.png
nitrogen --restore
