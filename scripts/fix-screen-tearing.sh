#!/usr/bin/bash
set -e
sleep 5
DISPLAY=:0 nvidia-settings --assign CurrentMetaMode="HDMI-0: 2560x1080_75 +0 { ForceCompositionPipeline = On }, eDP-1-1: 1920x1080_60 +2560 { ForceCompositionPipeline = On }"
