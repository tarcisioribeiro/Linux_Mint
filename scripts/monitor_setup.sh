#!/bin/bash
# nvidia-settings --assign CurrentMetaMode="HDMI-0: 2560x1080_75 +0+0 { ForceCompositionPipeline = On }, eDP-1-1: 1920x1080_60 +2560+0 { ForceCompositionPipeline = On }"

xrandr --output DP-1-1-3 --mode 1920x1080 --rate 60 --pos 0x0 --rotate normal \
 --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal \
 --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 4480x0 --rotate normal

i3-msg "workspace 1; move workspace to output HDMI-0"
i3-msg "workspace 2; move workspace to output eDP-1-1"
i3-msg "workspace 3; move workspace to output DP-1-1-3"
