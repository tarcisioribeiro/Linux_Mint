#!/usr/bin/env bash
type="$HOME/.config/rofi/applets/type-3"
style='style-2.rasi'
theme="$type/$style"

BROWSER='Google Chrome'
prompt='Links rápidos'
mesg="Utilizando o $BROWSER como navegador"

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
  list_col='1'
  list_row='6'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='6'
  list_row='1'
fi

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-5'*) ]]; then
  efonts="UbuntuMono Nerd Font 10"
else
  efonts="UbuntuMono Nerd Font 28"
fi

layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Google"
  option_2=" Gmail"
  option_3=" Youtube"
  option_4=" Github"
  option_5=" Whatsapp"
  option_6=" Instagram"
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
  option_5=""
  option_6=""
fi

rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -theme-str "element-text {font: \"$efonts\";}" \
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
  if [[ "$1" == '--opt1' ]]; then
    xdg-open 'https://www.google.com/'
  elif [[ "$1" == '--opt2' ]]; then
    xdg-open 'https://mail.google.com/'
  elif [[ "$1" == '--opt3' ]]; then
    xdg-open 'https://www.youtube.com/'
  elif [[ "$1" == '--opt4' ]]; then
    xdg-open 'https://www.github.com/'
  elif [[ "$1" == '--opt5' ]]; then
    xdg-open 'https://web.whatsapp.com/'
  elif [[ "$1" == '--opt6' ]]; then
    xdg-open 'https://www.instagram.com'
  fi
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
$option_6)
  run_cmd --opt6
  ;;
$option_7)
  run_cmd --opt7
  ;;
$option_8)
  run_cmd --opt8
  ;;
esac
