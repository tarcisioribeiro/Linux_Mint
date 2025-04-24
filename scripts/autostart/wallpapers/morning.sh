#!/usr/bin/env bash

redshift -x && redshift -P -O 4500
sleep 1

cd "$HOME/Pictures/"
sleep 1

cp versions/dracula-drag-race/dracula-drag-race-morning.png dracula-drag-race.png
sleep 1

cp versions/dracula-city-ride/dracula-city-ride-morning.png dracula-city-ride.png
sleep 1

cp versions/dracula-highway-road/dracula-highway-road-morning.png dracula-highway-road.png
sleep 1

nitrogen --restore
