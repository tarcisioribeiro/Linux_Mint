#!/usr/bin/env bash

# Script para rotação de wallpapers
WALLPAPER_DIR="$HOME/Development/Linux_Mint/wallpapers"
CURRENT_FILE="$HOME/.current_wallpaper"

# Lista dos wallpapers disponíveis
WALLPAPERS=(
  "alucard-skyscrapers.png"
  "alucard-sunrise.png"
  "dracula-base.png"
  "dracula-cat.png"
  "dracula-f1.png"
  "dracula-fighter.png"
  "dracula-galaxy.png"
  "dracula-leaves.png"
  "dracula-mint.png"
  "dracula-mnt.png"
  "dracula-soft-waves.png"
  "dracula-space.png"
  "dracula-spooky.png"
)

# Função para definir wallpaper
set_wallpaper() {
  local wallpaper="$1"
  local wallpaper_path="$WALLPAPER_DIR/$wallpaper"

  # Obter lista de monitores conectados
  local monitors=($(xrandr --query | grep " connected" | cut -d" " -f1))

  # Usar nitrogen para definir wallpaper em cada monitor específico
  for i in "${!monitors[@]}"; do
    nitrogen --head=$i --set-zoom-fill "$wallpaper_path" --save 2>/dev/null
  done
}

# Função para rotação manual
rotate_wallpaper() {
  local current_index=0

  # Ler o índice atual se existir
  if [[ -f "$CURRENT_FILE" ]]; then
    current_index=$(cat "$CURRENT_FILE")
  fi

  # Próximo wallpaper
  current_index=$(((current_index + 1) % ${#WALLPAPERS[@]}))

  # Salvar índice atual
  echo "$current_index" >"$CURRENT_FILE"

  # Definir wallpaper
  set_wallpaper "${WALLPAPERS[$current_index]}"

  # Notificação
  local wallpaper_name="${WALLPAPERS[$current_index]%.*}" # Remove extensão
  notify-send "Wallpaper Alterado" "📸 $wallpaper_name" --icon=preferences-desktop-wallpaper

  echo "Wallpaper alterado para: ${WALLPAPERS[$current_index]}"
}

# Função para definir wallpaper baseado na hora
set_time_based_wallpaper() {
  local hour=$(date +%H)
  local wallpaper_index

  # Mapear hora para wallpaper
  if ((hour >= 5 && hour < 8)); then
    wallpaper_index=0 # dracula-base.png (aurora/dawn)
  elif ((hour >= 8 && hour < 12)); then
    wallpaper_index=1 # dracula-cat.png (morning)
  elif ((hour >= 12 && hour < 17)); then
    wallpaper_index=2 # dracula-leaves.png (afternoon)
  elif ((hour >= 17 && hour < 19)); then
    wallpaper_index=3 # dracula-mint.png (dusk)
  elif ((hour >= 19 && hour < 22)); then
    wallpaper_index=4 # dracula-mnt.png (night)
  else
    wallpaper_index=5 # dracula-soft-waves.png (dawn/late night)
  fi

  # Salvar índice atual
  echo "$wallpaper_index" >"$CURRENT_FILE"

  # Definir wallpaper
  set_wallpaper "${WALLPAPERS[$wallpaper_index]}"

  # Notificação silenciosa para modo automático (apenas para debug, comentar se desejar)
  # local wallpaper_name="${WALLPAPERS[$wallpaper_index]%.*}"
  # notify-send "Wallpaper Automático" "🕐 $wallpaper_name" --icon=preferences-desktop-wallpaper
}

# Verificar argumento
case "${1:-auto}" in
"rotate")
  rotate_wallpaper
  ;;
"auto" | "time")
  set_time_based_wallpaper
  ;;
*)
  echo "Uso: $0 [rotate|auto|time]"
  echo "  rotate: próximo wallpaper na sequência"
  echo "  auto/time: wallpaper baseado na hora atual"
  exit 1
  ;;
esac
