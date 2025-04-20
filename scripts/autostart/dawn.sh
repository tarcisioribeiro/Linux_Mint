#!/usr/bin/env bash

redshift -x && redshift -P -O 3500
cd "$HOME/Pictures/"
sleep 1
cp versions/dracula-drag-race/dracula-drag-race-dawn.png dracula-drag-race.png
sleep 1
cp versions/dracula-city-ride/dracula-city-ride-dawn.png dracula-city-ride.png
sleep 1
cp versions/dracula-highway-road/dracula-highway-road-dawn.png dracula-highway-road.png
sleep 1
nitrogen --restore
