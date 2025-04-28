#!/usr/bin/env bash

redshift -x && redshift -P -O 5500
sleep 1

cd "$HOME/Pictures/"
sleep 1

cp versions/dracula-drag-race/dracula-drag-race-afternoon.png dracula-drag-race.png
sleep 1

cp versions/dracula-city-ride/dracula-city-ride-afternoon.png dracula-city-ride.png
sleep 1

cp versions/dracula-highway-road/dracula-highway-road-afternoon.png dracula-highway-road.png
sleep 1

nitrogen --restore
sleep 1

flatpak run org.gabmus.hydrapaper -c "$HOME/Pictures/dracula-drag-race.png" "$HOME/Pictures/dracula-highway-road.png" "$HOME/Pictures/dracula-city-ride.png"
