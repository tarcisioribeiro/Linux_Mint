#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-3"
style='style-2.rasi'
theme="$type/$style"

# Theme Elements
prompt='Aplicações'
mesg='Executar aplicações como Root'

if [[ "$theme" == *'type-1'* ]]; then
  list_col='1'
  list_row='5'
  win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
  list_col='1'
  list_row='5'
  win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
  list_col='1'
  list_row='5'
  win_width='520px'
# elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
#   list_col='5'
#   list_row='1'
#   win_width='670px'
fi

# Options
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Alacritty"
  option_2=" Nautilus"
  option_3=" Gedit"
  option_4=" Ranger"
  option_5=" Vim"
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
  option_5=""
fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
  export PATH=$PATH
  export DISPLAY=$DISPLAY
  export XAUTHORITY=$XAUTHORITY
  export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}

  polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"

  case "$1" in
    '--opt1')
      ${polkit_cmd} kitty
      ;;
    '--opt2')
      ${polkit_cmd} nautilus
      ;;
    '--opt3')
      ${polkit_cmd} gedit
      ;;
    '--opt4')
      ${polkit_cmd} kitty -e ranger
      ;;
    '--opt5')
      ${polkit_cmd} kitty -e vim
      ;;
    *)
      echo "Opção inválida."
      return 1
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
