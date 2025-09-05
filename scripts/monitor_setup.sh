#!/bin/bash

# xrandr --output DP-1-1-3 --mode 1920x1080 --rate 60 --pos 0x0 --rotate normal \
# --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
# --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal

# i3-msg "workspace 1; move workspace to output HDMI-0"
# i3-msg "workspace 2; move workspace to output eDP-1-1"
# i3-msg "workspace 3; move workspace to output DP-1-1-3"

xrandr --output DP-1-1-3 --off \
  --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 0x0 --rotate normal \
  --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 2560x0 --rotate normal

i3-msg "workspace 1; move workspace to output HDMI-0"
i3-msg "workspace 2; move workspace to output eDP-1-1"

# xrandr --output DP-1-1-3 --off \
#  --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 0x0 --rotate normal \
#  --output eDP-1-1 --off

# i3-msg "workspace 1; move workspace to output HDMI-0"
