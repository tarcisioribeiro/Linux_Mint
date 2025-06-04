#!/usr/bin/env bash
redshift -x && redshift -P -O 3500
cd "$HOME/Pictures/"
cp versions/dracula-drag-race/dracula-drag-race-dawn.png dracula-drag-race.png
cp versions/dracula-city-ride/dracula-city-ride-dawn.png dracula-city-ride.png
cp versions/dracula-highway-road/dracula-highway-road-dawn.png dracula-highway-road.png
nitrogen --restore
flatpak run org.gabmus.hydrapaper -c "$HOME/Pictures/dracula-drag-race.png" "$HOME/Pictures/dracula-highway-road.png" "$HOME/Pictures/dracula-city-ride.png"
