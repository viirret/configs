#!/bin/bash

FILE="$HOME/.local/state/i3status/spotify_info"

# Spotify logo unicode
icon=""

update_spotify_info() {
    while true; do
        if ! command -v playerctl &>/dev/null; then
            echo "playerctl command not found" >"$FILE"
            sleep 5
            continue
        fi

        # Get the playback status from playerctl.
        class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')

        # Handle cases where playerctl fails.
        if [[ $? -ne 0 ]]; then
            echo "Spotify not running" >"$FILE"
            sleep 5
            continue
        fi

        case $class in
        "playing")
            # Get the artist and title
            info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
            # Truncate info if it's longer than 40 characters
            if [[ ${#info} -gt 40 ]]; then
                info=$(echo $info | cut -c1-40)"..."
            fi
            # Set the text with the Spotify icon
            text="$info $icon"
            ;;
        "paused")
            # Show only the Spotify icon when paused
            text="$icon"
            ;;
        "stopped" | "")
            # Clear the text when stopped or if there's an error
            text=""
            ;;
        *)
            # Handle any other unexpected statuses
            text="Status unknown"
            ;;
        esac

        # Write the text to the file
        echo "$text" >"$FILE"
        sleep 1
    done
}

update_spotify_info &
