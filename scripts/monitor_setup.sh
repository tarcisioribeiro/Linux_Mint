#!/bin/bash

xrandr \
  --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
  --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal \
  --output DP-1-1-3 --mode 1920x1080 --rate 60 --pos 0x0 --rotate normal

i3-msg "workspace 1; move workspace to output HDMI-0"
i3-msg "workspace 2; move workspace to output eDP-1-1"
i3-msg "workspace 3; move workspace to output DP-1-1-3"
sleep 5
i3-msg "workspace 1; exec code"
sleep 5
i3-msg "workspace 1; exec alacritty"
sleep 5
i3-msg "workspace 2; exec google-chrome"
sleep 5
i3-msg "workspace 1"
