#!/bin/bash
# nvidia-settings --assign CurrentMetaMode="$(nvidia-settings -q CurrentMetaMode -t | tr '\n' ' ' | sed -e 's/.*:: \(.*\)/\1\n/g' -e 's/}/, ForceCompositionPipeline = On, ForceFullCompositionPipeline=On}/g')" >/dev/null
nvidia-settings --assign CurrentMetaMode="$(xrandr | sed -nr '/(\S+) connected (primary )?([0-9]+x[0-9]+)(\+\S+).*/{ s//\1: \3 \4 { ForceFullCompositionPipeline = On }, /; H}; ${ g; s/\n//g; s/, $//; p }')"
