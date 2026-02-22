#!/bin/bash

FILE="$HOME/.local/state/i3status/keyboard_layout"

update_keyboard_layout() {
    while true; do
        hyprctl devices -j | jq -r '(.keyboards[] | select(.main == true) | .active_keymap) // ""' > "$FILE"
        sleep 0.5
    done
}

update_keyboard_layout &
