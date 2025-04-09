#!/bin/bash
xrandr --output DP-1-1-3 --mode 1920x1080 --rate 60 --pos 0x0 --rotate normal \
  --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
  --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal

i3-msg "workspace 1; exec google-chrome-stable"
sleep 2
i3-msg "workspace 1; exec alacritty"
sleep 2
i3-msg "workspace 2; exec discord"
sleep 2
i3-msg "workspace 1;"
