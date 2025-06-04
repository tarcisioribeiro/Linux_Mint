#!/usr/bin/bash
type="$HOME/.config/rofi/applets/type-3"
style='style-2.rasi'
theme="$type/$style"

prompt='Captura de Tela'
mesg="Diretório: $(xdg-user-dir PICTURES)Screenshots"

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
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='5'
  list_row='1'
  win_width='670px'
fi

layout=$(grep 'USE_ICON' "$theme" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Capture Desktop"
  option_2=" Capture Area"
  option_3=" Capture Window"
  option_4=" Capture in 5s"
  option_5=" Capture in 10s"
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
  option_5=""
fi

rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme "$theme"
}

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/Screenshot_${time}.png"

notify_view() {
  notify_cmd_shot='dunstify -u low -t 1000'
  if [[ -e "$file" ]]; then
    ${notify_cmd_shot} "Captura de tela salva."
    xviewer "$file" &
  else
    ${notify_cmd_shot} "Falha ao capturar tela."
  fi
}

copy_shot() {
  if [[ -e "$file" ]]; then
    xclip -selection clipboard -t image/png <"$file"
  else
    echo "Erro: Arquivo de captura não encontrado." >&2
  fi
}

countdown() {
  for sec in $(seq $1 -1 1); do
    dunstify -t 1000 "Tirando captura em: $sec"
    sleep 1
  done
}

shotnow() {
  scrot "$file"
  copy_shot
  notify_view
}

shot5() {
  countdown 5
  sleep 1 && scrot "$file"
  copy_shot
  notify_view
}

shot10() {
  countdown 10
  sleep 1 && scrot "$file"
  copy_shot
  notify_view
}

shotwin() {
  win_id=$(xdotool getactivewindow)
  maim -i "$win_id" "$file"
  copy_shot
  notify_view
}

shotarea() {
  maim -s "$file"
  copy_shot
  notify_view
}

run_cmd() {
  case "$1" in
  '--opt1') shotnow ;;
  '--opt2') shotarea ;;
  '--opt3') shotwin ;;
  '--opt4') shot5 ;;
  '--opt5') shot10 ;;
  esac
}

chosen="$(run_rofi)"
case "$chosen" in
$option_1) run_cmd --opt1 ;;
$option_2) run_cmd --opt2 ;;
$option_3) run_cmd --opt3 ;;
$option_4) run_cmd --opt4 ;;
$option_5) run_cmd --opt5 ;;
esac
