#!/usr/bin/env bash

#==============================================================================
# Script: wallpaper_gif_player.sh
# Descrição: Reprodutor de GIFs animados como wallpaper usando xwinwrap + mpv
# Autor: Sistema de configuração i3
# Uso: Chamado automaticamente pelo wallpaper_selector.sh
#==============================================================================

set -euo pipefail

#==============================================================================
# CONFIGURAÇÕES - Personalize aqui
#==============================================================================

# Opções do xwinwrap
XWINWRAP_OPTIONS=(
  -ov          # Override redirect
  -g           # Geometry (definido dinamicamente)
  -ni          # No input
  -s           # Shaped window
  -st          # Skip taskbar
  -sp          # Skip pager
  -b           # Below other windows
  -nf          # No focus
)

# Opções do mpv (configurado para funcionar com xwinwrap)
MPV_OPTIONS=(
  --no-config
  --loop
  --no-osc
  --no-osd-bar
  --no-input-default-bindings
  --no-audio
  --vo=x11
  --quiet
)

#==============================================================================
# FUNÇÕES
#==============================================================================

# Cleanup ao sair
cleanup() {
  # Mata processos xwinwrap e mpv
  pkill -f "xwinwrap.*mpv" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

# Verifica dependências
check_dependencies() {
  local missing_deps=()

  if ! command -v xwinwrap >/dev/null 2>&1; then
    missing_deps+=("xwinwrap")
  fi
  if ! command -v mpv >/dev/null 2>&1; then
    missing_deps+=("mpv")
  fi
  if ! command -v xdpyinfo >/dev/null 2>&1; then
    missing_deps+=("x11-utils")
  fi

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "Erro: Dependências faltando: ${missing_deps[*]}"
    echo ""
    echo "Para instalar xwinwrap:"
    echo "  git clone https://github.com/ujjwal96/xwinwrap.git"
    echo "  cd xwinwrap"
    echo "  make"
    echo "  sudo make install"
    echo ""
    echo "Para instalar mpv:"
    echo "  sudo apt install mpv"
    echo ""
    echo "Para instalar x11-utils:"
    echo "  sudo apt install x11-utils"
    exit 1
  fi
}

# Obtém geometria de todos os monitores
get_screen_geometry() {
  # Detecta se há múltiplos monitores
  local monitors
  monitors=$(xrandr --query | grep " connected" | wc -l)

  if [[ $monitors -gt 1 ]]; then
    # Múltiplos monitores: usa bounding box total (apenas WIDTHxHEIGHT)
    xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'
  else
    # Monitor único: extrai geometria completa (WIDTHxHEIGHT+X+Y)
    xrandr --query | grep " connected" | awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) print $i}' | head -n1
  fi
}

# Inicia reprodução de GIF animado como wallpaper
play_animated_wallpaper() {
  local gif_path="$1"

  echo "Reproduzindo GIF animado: $(basename "$gif_path")"

  # Obtém geometria da tela
  local geometry
  geometry=$(get_screen_geometry)

  if [[ -z "$geometry" ]]; then
    echo "Erro: Não foi possível detectar a geometria da tela"
    exit 1
  fi

  echo "Geometria detectada: $geometry"

  # Mata processos anteriores
  pkill -f "xwinwrap.*mpv" 2>/dev/null || true
  sleep 0.2

  # Inicia xwinwrap com mpv em background
  # O mpv reproduz o GIF em loop sem bloquear o sistema
  xwinwrap "${XWINWRAP_OPTIONS[@]}" -g "$geometry" -- \
    mpv "${MPV_OPTIONS[@]}" "$gif_path" \
    >/dev/null 2>&1 &

  local xwinwrap_pid=$!
  echo "Processo xwinwrap iniciado (PID: $xwinwrap_pid)"

  # Aguarda um pouco para verificar se o processo iniciou corretamente
  sleep 1

  if ! kill -0 "$xwinwrap_pid" 2>/dev/null; then
    echo "Erro: xwinwrap falhou ao iniciar"
    exit 1
  fi

  echo "Wallpaper animado reproduzindo em segundo plano"

  # Mantém o script rodando (mas não bloqueia o sistema)
  wait "$xwinwrap_pid"
}

#==============================================================================
# MAIN
#==============================================================================

main() {
  local gif_path="$1"

  # Valida argumentos
  if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <caminho_para_gif>"
    exit 1
  fi

  if [[ ! -f "$gif_path" ]]; then
    echo "Erro: Arquivo não encontrado: $gif_path"
    exit 1
  fi

  # Verifica dependências
  check_dependencies

  # Reproduz GIF animado como wallpaper
  play_animated_wallpaper "$gif_path"
}

# Executar
main "$@"
