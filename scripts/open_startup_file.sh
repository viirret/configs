#!/usr/bin/env bash

# Change this path to open a different file when Hyprland starts.
STARTUP_FILE="$HOME/agenda.org"

# At boot the network may not be up yet when Hyprland starts, so the fetch can
# fail. Retry within a time budget instead of silently keeping yesterday's menu.
fetch_rentukka_output() {
    timeout 25 python3 "$HOME/configs/scripts/rentukka_today.py" --fi --veg 2>/dev/null | awk '
        /^PAISTOPISTE/ { skip=1; next }
        skip && /^  - /  { next }
        { skip=0; print }
    '
}

RENTUKKA_OUTPUT=""
deadline=$((SECONDS + 120))
while [ "$SECONDS" -lt "$deadline" ]; do
    RENTUKKA_OUTPUT=$(fetch_rentukka_output)
    [ -n "$RENTUKKA_OUTPUT" ] && break
    sleep 5
done

if [ -n "$RENTUKKA_OUTPUT" ]; then
    TMPFILE=$(mktemp)
    # Remove any previously inserted lunch block (section headers + meal lines)
    # that sits directly after the "Gym + Rentuqa" line.
    awk '
        /\* TODO Gym \+ Rentuqa/ { print; in_block=1; next }
        in_block && /^(LOUNAS|PAISTOPISTE).*\(veg\):$/ { next }
        in_block && /^  - /   { next }
        { in_block=0; print }
    ' "$STARTUP_FILE" > "$TMPFILE"

    # Insert the fresh block right after the "Gym + Rentuqa" line.
    awk -v insert="$RENTUKKA_OUTPUT" '
        /\* TODO Gym \+ Rentuqa/ { print; print insert; next }
        { print }
    ' "$TMPFILE" > "$STARTUP_FILE"
fi

exec nvim -c 'lua vim.api.nvim_feedkeys(vim.g.mapleader .. "re" .. vim.g.mapleader .. "rt", "mx", false)' -- "$STARTUP_FILE"