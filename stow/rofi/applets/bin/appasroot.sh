#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-3"
style='style-2.rasi'
theme="$type/$style"

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
fi

layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Kitty"
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
    ${polkit_cmd} "$HOME/development/kitty/kitty/launcher/kitty"
    ;;
  '--opt2')
    ${polkit_cmd} nautilus
    ;;
  '--opt3')
    ${polkit_cmd} gedit
    ;;
  '--opt4')
    ${polkit_cmd} "$HOME/development/kitty/kitty/launcher/kitty -e ranger"
    ;;
  '--opt5')
    ${polkit_cmd} "$HOME/development/kitty/kitty/launcher/kitty -e vim"
    ;;
  *)
    echo "Opção inválida."
    return 1
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
