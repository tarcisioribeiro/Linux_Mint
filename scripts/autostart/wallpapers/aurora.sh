#!/usr/bin/env bash

redshift -x && redshift -P -O 4000
sleep 1

cd "$HOME/Pictures/"
sleep 1

cp versions/dracula-drag-race/dracula-drag-race-aurora.png dracula-drag-race.png
sleep 1

cp versions/dracula-city-ride/dracula-city-ride-aurora.png dracula-city-ride.png
sleep 1

cp versions/dracula-highway-road/dracula-highway-road-aurora.png dracula-highway-road.png
sleep 1

nitrogen --restore
