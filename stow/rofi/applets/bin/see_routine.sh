#!/bin/bash

ROUTINE_DIR="$HOME/repos/Ubuntu/Personal"
echo $ROUTINE_DIR
DAY=$(date +%u)

case "$DAY" in
6) ARCHIVE="$ROUTINE_DIR/saturday_routine.md" ;;
7) ARCHIVE="$ROUTINE_DIR/sunday_routine.md" ;;
*) ARCHIVE="$ROUTINE_DIR/week_day_routine.md" ;;
esac

echo "Ver rotina de hoje" | rofi -dmenu -p "Rotina" >/dev/null || exit

gnome-terminal -- bash -c "glow -p \"$ARCHIVE\";"
