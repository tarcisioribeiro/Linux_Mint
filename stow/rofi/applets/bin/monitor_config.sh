#!/usr/bin/env bash

type="$HOME/.config/rofi/applets/type-2"
style='style-2.rasi'
theme="$type/$style"
monitor_script="$HOME/Development/Linux_Mint/scripts/monitor_setup.sh"

prompt="Monitor Setup"
mesg="Configurações de Monitores Disponíveis"

if [[ "$theme" == *'type-1'* ]]; then
  list_col='1'
  list_row='3'
  win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
  list_col='1'
  list_row='3'
  win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
  list_col='1'
  list_row='3'
  win_width='425px'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='3'
  list_row='1'
  win_width='600px'
fi

layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1="󰍹 Dual (HDMI + Notebook)"
  option_2="󰍺 Triple (DP + HDMI + Notebook)"
  option_3="󰍹 Único (HDMI)"
else
  option_1="󰍺"
  option_2=""
  option_3="󰍹"
fi

rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

run_cmd() {
  case "$1" in
  '--dual')
    # Configuração Dual: HDMI + Notebook
    xrandr --output DP-1-1-3 --off \
      --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 0x0 --rotate normal \
      --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 2560x0 --rotate normal
    i3-msg "workspace 1; move workspace to output HDMI-0"
    i3-msg "workspace 2; move workspace to output eDP-1-1"
    notify-send "Monitor Setup" "Configuração Dual ativada: HDMI + Notebook" -i display
    ;;
  '--triple')
    # Configuração Triple: DP + HDMI + Notebook (atual no script)
    xrandr --output DP-1-1-3 --mode 3840x2160 --rate 30 --pos 0x0 --rotate normal \
      --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 3840x0 --rotate normal \
      --output eDP-1-1 --mode 1920x1080 --rate 60 --pos 6400x0 --rotate normal
    i3-msg "workspace 1; move workspace to output HDMI-0"
    i3-msg "workspace 2; move workspace to output eDP-1-1"
    i3-msg "workspace 3; move workspace to output DP-1-1-3"
    notify-send "Monitor Setup" "Configuração Triple ativada: DP + HDMI + Notebook" -i display
    ;;
  '--single')
    # Configuração Única: HDMI apenas
    xrandr --output DP-1-1-3 --off \
      --output HDMI-0 --primary --mode 2560x1080 --rate 75 --pos 0x0 --rotate normal \
      --output eDP-1-1 --off
    i3-msg "workspace 1; move workspace to output HDMI-0"
    notify-send "Monitor Setup" "Configuração Única ativada: HDMI apenas" -i display
    ;;
  esac
}

chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  run_cmd --dual
  ;;
$option_2)
  run_cmd --triple
  ;;
$option_3)
  run_cmd --single
  ;;
esac
