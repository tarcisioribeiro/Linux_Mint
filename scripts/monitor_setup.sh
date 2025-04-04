#!/bin/bash
sleep 1
gnome-shell >/dev/null
sleep 1
xrandr --output DP-1-1-3 --mode 1920x1080 --rate 60 --pos 0x0 --rotate normal \
  --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
  --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal
