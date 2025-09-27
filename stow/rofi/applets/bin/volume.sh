#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-2"
style='style-2.rasi'
theme="$type/$style"

speaker="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')"
mic="$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | sed 's/%//')"

active=""
urgent=""

if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "false"; then
  active="-a 1"
  stext='Desmutar'
  sicon=''
else
  urgent="-u 1"
  stext='Mutar'
  sicon=''
fi

if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "false"; then
  [ -n "$active" ] && active+="3" || active="-a 3"
  mtext='Desmutar'
  micon=''
else
  [ -n "$urgent" ] && urgent+="3" || urgent="-u 3"
  mtext='Mutar'
  micon=''
fi

prompt="S:$stext, M:$mtext"
mesg="Alto-Falante: $speaker%, Microfone: $mic%"

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

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

run_cmd() {
  case "$1" in
  '--opt1')
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    ;;
  '--opt2')
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
  '--opt3')
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    ;;
  '--opt4')
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    ;;
  '--opt5')
    pavucontrol
    ;;
  esac
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
esac
