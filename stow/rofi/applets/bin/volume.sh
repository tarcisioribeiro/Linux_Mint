#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-2"
style='style-2.rasi'
theme="$type/$style"

# Volume Info
speaker="$(pactl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')%"
mic="$(pactl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}')%"

active=""
urgent=""

# Speaker Info
if pactl get-mute @DEFAULT_AUDIO_SINK@ | grep -q "false"; then
  active="-a 1"
  stext='Desmutar'
  sicon=''
else
  urgent="-u 1"
  stext='Mutar'
  sicon=''
fi

# Microphone Info
if pactl get-mute @DEFAULT_AUDIO_SOURCE@ | grep -q "false"; then
  [ -n "$active" ] && active+="3" || active="-a 3"
  mtext='Desmutar'
  micon=''
else
  [ -n "$urgent" ] && urgent+="3" || urgent="-u 3"
  mtext='Mutar'
  micon=''
fi

# Theme Elements
prompt="S:$stext, M:$mtext"
mesg="Alto-Falante: $speaker, Microfone: $mic"

# Options
layout=$(grep 'USE_ICON' "${theme}" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Aumentar"
  option_2="$sicon $stext"
  option_3=" Diminuir"
  option_4="$micon $mtext"
  option_5=" Configurações"
else
  option_1=""
  option_2="$sicon"
  option_3=""
  option_4="$micon"
  option_5=""
fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "window {width: 800px;}" \
    -theme-str "listview {columns: 5; lines: 1;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    ${active} ${urgent} \
    -markup-rows \
    -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
  case "$1" in
  '--opt1')
    pactl set-volume @DEFAULT_AUDIO_SINK@ 0.05+
    ;;
  '--opt2')
    pactl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
  '--opt3')
    pactl set-volume @DEFAULT_AUDIO_SINK@ 0.05-
    ;;
  '--opt4')
    pactl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    ;;
  '--opt5')
    pavucontrol
    ;;
  esac
}

# Actions
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
esac
