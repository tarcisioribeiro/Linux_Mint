#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-1"
style='style-3.rasi'
theme="$type/$style"

# Obter status do player
status="$(playerctl status 2>/dev/null)"
if [[ -z "$status" ]]; then
  prompt='Offline'
  mesg="Nenhum player detectado"
else
  if [[ "$status" == "Playing" ]]; then
    formatted_status="Tocando"
  elif [[ "$status" == "Paused" ]]; then
    formatted_status="Pausado"
  fi
  prompt="$(playerctl metadata artist 2>/dev/null)"
  mesg="$(playerctl metadata title 2>/dev/null) :: $formatted_status"
fi

# Definir layout do Rofi
if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
  list_col='1'
  list_row='6'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='6'
  list_row='1'
fi

# Definir opções
toggle_icon=""
if [[ "$formatted_status" == "Tocando" ]]; then
  toggle_icon=""
fi
option_1="$toggle_icon Tocar/Pausar"
option_2=" Parar"
option_3="󰒮 Anterior"
option_4="󰒭 Próxima"
option_5=" Repetir"
option_6=" Aleatório"

# Comando do Rofi
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

# Rodar Rofi
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Executar comando com playerctl
run_cmd() {
  case "$1" in
    '--opt1') playerctl play-pause ;; 
    '--opt2') playerctl stop ;;
    '--opt3') playerctl previous ;; 
    '--opt4') playerctl next ;; 
    '--opt5') playerctl loop-toggle ;; 
    '--opt6') playerctl shuffle-toggle ;; 
  esac
}

# Capturar escolha e executar ação
chosen="$(run_rofi)"
case ${chosen} in
  "$option_1") run_cmd --opt1 ;;
  "$option_2") run_cmd --opt2 ;;
  "$option_3") run_cmd --opt3 ;;
  "$option_4") run_cmd --opt4 ;;
  "$option_5") run_cmd --opt5 ;;
  "$option_6") run_cmd --opt6 ;;
esac
