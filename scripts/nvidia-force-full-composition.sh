#!/bin/bash
nvidia-settings --assign CurrentMetaMode="$(nvidia-settings -q CurrentMetaMode -t | tr '\n' ' ' | sed -e 's/.*:: \(.*\)/\1\n/g' -e 's/}/, ForceCompositionPipeline = On, ForceFullCompositionPipeline=On}/g')" >/dev/null
