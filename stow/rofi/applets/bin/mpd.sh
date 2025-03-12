#!/usr/bin/env bash

type="$HOME/.config/rofi/applets/type-1"
style='style-3.rasi'
theme="$type/$style"

status=""

if playerctl status &>/dev/null; then
  status="Playing"
else
  status="Offline"
fi

if [[ "$status" == "Offline" ]]; then
  prompt='Offline'
  mesg="Nenhum player detectado"
else
  formatted_status="Tocando"
  prompt="Player Online"
  mesg="Player Online :: $formatted_status"
fi

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
  list_col='1'
  list_row='6'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='6'
  list_row='1'
fi

toggle_icon=""
if [[ "$status" == "Playing" ]]; then
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

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

run_cmd() {
  case "$1" in
    '--opt1') playerctl play-pause ;;
    '--opt2') playerctl stop ;;
    '--opt3') playerctl previous ;;
    '--opt4') playerctl next ;;
    '--opt5') playerctl loop ;;
    '--opt6') playerctl shuffle ;;
  esac
}

chosen="$(run_rofi)"
case ${chosen} in
  "$option_1") run_cmd --opt1 ;;
  "$option_2") run_cmd --opt2 ;;
  "$option_3") run_cmd --opt3 ;;
  "$option_4") run_cmd --opt4 ;;
  "$option_5") run_cmd --opt5 ;;
  "$option_6") run_cmd --opt6 ;;
esac
