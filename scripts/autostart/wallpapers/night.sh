#!/usr/bin/env bash
redshift -x && redshift -P -O 3500
cd "$HOME/Pictures/"
cp versions/dracula-drag-race/dracula-drag-race-night.png dracula-drag-race.png
cp versions/dracula-city-ride/dracula-city-ride-night.png dracula-city-ride.png
cp versions/dracula-highway-road/dracula-highway-road-night.png dracula-highway-road.png
nitrogen --restore
