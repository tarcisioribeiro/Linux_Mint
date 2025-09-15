#!/usr/bin/bash
set -e
sleep 5
DISPLAY=:0 nvidia-settings --assign CurrentMetaMode="DP-1-1-3: 1920x1080_60 +0 { ForceCompositionPipeline = On }, HDMI-0: 2560x1080_75 +1920 { ForceCompositionPipeline = On }, eDP-1-1: 1920x1080_60 +4480 { ForceCompositionPipeline = On }"
# DISPLAY=:1 nvidia-settings --assign CurrentMetaMode="DP-1-1-3: 1920x1080_60 +0 { ForceCompositionPipeline = On }, HDMI-0: 2560x1080_75 +1920 { ForceCompositionPipeline = On }, eDP-1-1: 1920x1080_60 +4480 { ForceCompositionPipeline = On }"
