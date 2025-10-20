#!/usr/bin/env bash

#==============================================================================
# Script: wallpaper_selector.sh
# Descrição: Seletor de wallpapers com rofi para wallpapers estáticos (PNG) e animados (GIF)
# Autor: Sistema de configuração i3
# Uso: Pressione Ctrl+Alt+Space para invocar
#==============================================================================

set -euo pipefail

#==============================================================================
# CONFIGURAÇÕES - Personalize aqui
#==============================================================================

# Diretórios de wallpapers
STATIC_WALLPAPERS_DIR="$HOME/Development/Linux_Mint/wallpapers/fix/"
ANIMATED_WALLPAPERS_DIR="$HOME/Development/Linux_Mint/wallpapers/animated/"

# Arquivo de controle para o processo de GIF animado
GIF_PID_FILE="$HOME/.wallpaper_gif.pid"

# Tema rofi
ROFI_TYPE="$HOME/.config/rofi/applets/type-2"
ROFI_STYLE='wallpaper.rasi'
ROFI_THEME="$ROFI_TYPE/$ROFI_STYLE"

# Ícones Nerd Fonts
ICON_STATIC=$'\uf03e'   # nf-fa-file_image_o
ICON_ANIMATED=$'\uf008' # nf-fa-film

# Detectar layout do tema rofi
if [[ ("$ROFI_THEME" == *'type-1'*) || ("$ROFI_THEME" == *'type-3'*) || ("$ROFI_THEME" == *'type-5'*) ]]; then
  LIST_COL='1'
  LIST_ROW='6'
elif [[ ("$ROFI_THEME" == *'type-2'*) || ("$ROFI_THEME" == *'type-4'*) ]]; then
  LIST_COL='6'
  LIST_ROW='1'
fi

#==============================================================================
# FUNÇÕES AUXILIARES
#==============================================================================

# Verifica se comando existe
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Valida dependências
check_dependencies() {
  local missing_deps=()

  if ! command_exists rofi; then
    missing_deps+=("rofi")
  fi
  if ! command_exists feh; then
    missing_deps+=("feh")
  fi
  if ! command_exists notify-send; then
    missing_deps+=("libnotify-bin")
  fi

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "Erro: Dependências faltando: ${missing_deps[*]}"
    echo "Instale com: sudo apt install ${missing_deps[*]}"
    exit 1
  fi
}

# Cria diretórios se não existirem
ensure_directories() {
  if [[ ! -d "$STATIC_WALLPAPERS_DIR" ]]; then
    mkdir -p "$STATIC_WALLPAPERS_DIR"
    echo "Criado diretório: $STATIC_WALLPAPERS_DIR"
  fi

  if [[ ! -d "$ANIMATED_WALLPAPERS_DIR" ]]; then
    mkdir -p "$ANIMATED_WALLPAPERS_DIR"
    echo "Criado diretório: $ANIMATED_WALLPAPERS_DIR"
  fi
}

# Mata processos de GIF animado anteriores
kill_animated_wallpaper() {
  if [[ -f "$GIF_PID_FILE" ]]; then
    local old_pid
    old_pid=$(cat "$GIF_PID_FILE")
    if kill -0 "$old_pid" 2>/dev/null; then
      kill "$old_pid" 2>/dev/null || true
      echo "Processo de GIF animado anterior ($old_pid) finalizado"
    fi
    rm -f "$GIF_PID_FILE"
  fi

  # Mata qualquer xwinwrap ou mpv que esteja rodando wallpaper animado
  pkill -f "xwinwrap.*mpv" 2>/dev/null || true
  pkill -f "wallpaper_gif_player" 2>/dev/null || true
}

# Aplica wallpaper estático com feh
set_static_wallpaper() {
  local wallpaper_path="$1"
  local wallpaper_name
  wallpaper_name=$(basename "$wallpaper_path")
  wallpaper_name="${wallpaper_name%.*}"

  # Mata qualquer GIF animado rodando
  kill_animated_wallpaper

  # Aplica wallpaper com feh em todos os monitores
  feh --bg-scale "$wallpaper_path" 2>/dev/null

  # Notificação
  notify-send "Wallpaper Estático" "$ICON_STATIC $wallpaper_name" \
    --icon=preferences-desktop-wallpaper \
    --urgency=low

  echo "Wallpaper estático aplicado: $wallpaper_name"
}

# Aplica wallpaper animado (GIF)
set_animated_wallpaper() {
  local gif_path="$1"
  local gif_name
  gif_name=$(basename "$gif_path" .gif)

  # Mata qualquer GIF animado rodando
  kill_animated_wallpaper

  # Chama script auxiliar para reproduzir GIF
  "$HOME/.config/rofi/applets/bin/wallpaper_gif_player.sh" "$gif_path" &
  echo $! >"$GIF_PID_FILE"

  # Notificação
  notify-send "Wallpaper Animado" "$ICON_ANIMATED $gif_name" \
    --icon=preferences-desktop-wallpaper \
    --urgency=low

  echo "Wallpaper animado aplicado: $gif_name"
}

#==============================================================================
# FUNÇÕES ROFI
#==============================================================================

# Comando rofi base
rofi_cmd() {
  local prompt="$1"
  local mesg="$2"

  rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme "$ROFI_THEME"
}

# Menu principal
show_main_menu() {
  local static_count animated_count
  static_count=$(find "$STATIC_WALLPAPERS_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" \) 2>/dev/null | wc -l)
  animated_count=$(find "$ANIMATED_WALLPAPERS_DIR" -maxdepth 1 -type f -name "*.gif" 2>/dev/null | wc -l)

  local prompt="Wallpapers"
  local mesg="Estáticos: $static_count | Animados: $animated_count"

  # Opções do menu principal (apenas ícones)
  local option_1="$ICON_STATIC"
  local option_2="$ICON_ANIMATED"

  echo -e "$option_1\n$option_2" | rofi_cmd "$prompt" "$mesg"
}

# Submenu de wallpapers estáticos
show_static_wallpapers() {
  local prompt="$ICON_STATIC Wallpapers Fixos"
  local mesg="Selecione um wallpaper PNG/JPG"

  # Listar wallpapers PNG e JPG
  local wallpapers
  wallpapers=$(find "$STATIC_WALLPAPERS_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" \) 2>/dev/null | sort)

  if [[ -z "$wallpapers" ]]; then
    notify-send "Aviso" "Nenhum wallpaper estático encontrado em:\n$STATIC_WALLPAPERS_DIR" \
      --icon=dialog-warning \
      --urgency=normal
    return 1
  fi

  # Formatar opções para rofi
  local options=""
  while IFS= read -r wallpaper; do
    local name
    name=$(basename "$wallpaper")
    name="${name%.*}" # Remove extensão
    options+="$name\n"
  done <<<"$wallpapers"

  # Mostrar menu e retornar seleção
  local chosen
  chosen=$(echo -e "$options" | rofi_cmd "$prompt" "$mesg")

  if [[ -n "$chosen" ]]; then
    # Encontrar caminho completo do wallpaper escolhido
    local selected_wallpaper
    selected_wallpaper=$(find "$STATIC_WALLPAPERS_DIR" -maxdepth 1 -type f \( -name "$chosen.png" -o -name "$chosen.jpg" \) 2>/dev/null | head -n1)

    if [[ -n "$selected_wallpaper" ]]; then
      set_static_wallpaper "$selected_wallpaper"
    fi
  fi
}

# Submenu de wallpapers animados
show_animated_wallpapers() {
  local prompt="$ICON_ANIMATED Wallpapers Animados"
  local mesg="Selecione um wallpaper GIF"

  # Listar wallpapers GIF
  local gifs
  gifs=$(find "$ANIMATED_WALLPAPERS_DIR" -maxdepth 1 -type f -name "*.gif" 2>/dev/null | sort)

  if [[ -z "$gifs" ]]; then
    notify-send "Aviso" "Nenhum wallpaper animado encontrado em:\n$ANIMATED_WALLPAPERS_DIR" \
      --icon=dialog-warning \
      --urgency=normal
    return 1
  fi

  # Formatar opções para rofi
  local options=""
  while IFS= read -r gif; do
    local name
    name=$(basename "$gif" .gif)
    options+="$name\n"
  done <<<"$gifs"

  # Mostrar menu e retornar seleção
  local chosen
  chosen=$(echo -e "$options" | rofi_cmd "$prompt" "$mesg")

  if [[ -n "$chosen" ]]; then
    # Encontrar caminho completo do GIF escolhido
    local selected_gif="$ANIMATED_WALLPAPERS_DIR/$chosen.gif"

    if [[ -f "$selected_gif" ]]; then
      set_animated_wallpaper "$selected_gif"
    fi
  fi
}

#==============================================================================
# MAIN
#==============================================================================

main() {
  # Verifica dependências
  check_dependencies

  # Garante que diretórios existem
  ensure_directories

  # Mostra menu principal
  local choice
  choice=$(show_main_menu)

  # Processa escolha (compara exatamente com os ícones)
  case "$choice" in
  "$ICON_STATIC")
    show_static_wallpapers
    ;;
  "$ICON_ANIMATED")
    show_animated_wallpapers
    ;;
  *)
    # Usuário cancelou ou escolha inválida
    exit 0
    ;;
  esac
}

# Executar
main "$@"
