#!/bin/bash
sleep 1
xrandr --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
  --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal

for i in {1..2}; do
  i3-msg "workspace $i; move workspace to output $(xrandr --listmonitors | awk -v n=$i 'NR==n+1 {print $4}')"
  sleep 2
done

sleep 5
i3-msg restart
sleep 5

i3-msg "workspace 1; exec google-chrome-stable"
sleep 5
i3-msg "workspace 1; exec alacritty"
sleep 5
i3-msg "workspace 2; exec discord"
sleep 5
i3-msg "workspace 1;"
