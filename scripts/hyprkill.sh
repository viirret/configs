#!/bin/bash

WIN_SELECTION=$(hyprctl clients -j | jq -r '.[] | "\(.pid) \(.title)"' | rofi -dmenu -p "Kill window")
PID=$(echo "$WIN_SELECTION" | awk '{print $1}')
if [ -n "$PID" ]; then
    kill -9 "$PID"
    notify-send "hyprkill" "Killed PID $PID"
fi
