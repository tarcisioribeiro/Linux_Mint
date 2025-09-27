#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-2"
style='style-2.rasi'
theme="$type/$style"

# Theme Elements
prompt='Apps'
mesg="Pacotes instalados : $(dpkg --list | grep '^ii' | wc -l) (APT)"

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
  list_col='1'
  list_row='4'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='4'
  list_row='1'
fi

steam_app='steam'
ps2='flatpak run net.pcsx2.PCSX2'
ps1='flatpak run org.duckstation.DuckStation'
snes='flatpak run dev.bsnes.bsnes'

layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Steam <span weight='light' size='small'><i>($steam_app)</i></span>"
  option_2=" PCSX2 <span weight='light' size='small'><i>($ps2)</i></span>"
  option_3=" DuckStation <span weight='light' size='small'><i>($ps1)</i></span>"
  option_4="󰮂 Snes9x <span weight='light' size='small'><i>($snes)</i></span>"
else
  option_1="󰓓"
  option_2="󰖺"
  option_3="󰊴"
  option_4="󰮂"
fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    $steam_app
  elif [[ "$1" == '--opt2' ]]; then
    $ps2
  elif [[ "$1" == '--opt3' ]]; then
    $ps1
  elif [[ "$1" == '--opt4' ]]; then
    $snes
  fi
}

chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  run_cmd --opt1
  ;;
$option_2)
  run_cmd --opt2
  ;;
$option_3)
  run_cmd --opt3
  ;;
$option_4)
  run_cmd --opt4
  ;;
$option_5)
  run_cmd --opt5
  ;;
$option_6)
  run_cmd --opt6
  ;;
esac
