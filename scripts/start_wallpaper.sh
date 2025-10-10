#!/bin/bash
# Espera o i3 carregar
sleep 2

# Executa o wallpaper em background
# xwinwrap -fs -fdt -ni -b -un -nf -- mpv -wid WID --loop --no-audio --panscan=1.0 --no-osc --no-osd-bar ~/Downloads/waves_animation.mp4
# xwinwrap -fs -fdt -ni -b -un -nf -ov -- mpv --loop --no-audio --panscan=1.0 --no-osc --no-osd-bar ~/Downloads/waves_animation.mp4
# #!/bin/bash
# Espera o i3 carregar
sleep 2

# Roda o vídeo como wallpaper (fullscreen, loop, sem áudio)
mpv --loop --no-audio --really-quiet --fullscreen ~/Downloads/waves_animation.mp4 &
