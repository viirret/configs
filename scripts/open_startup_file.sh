#!/usr/bin/env bash

# Change this path to open a different file when Hyprland starts.
STARTUP_FILE="$HOME/agenda.org"
RENTUKKA_SCRIPT="$HOME/configs/scripts/rentukka_today.py"

# At boot the network may not be up yet when Hyprland starts, so the fetch can
# fail. Retry within a time budget instead of silently keeping yesterday's menu.
fetch_rentukka_output() {
    timeout 25 python3 "$RENTUKKA_SCRIPT" --fi --veg 2>/dev/null | awk '
        # Keep only the LUNCH section(s); drop dessert and grill sections.
        /^[^[:space:]].*:$/ {
            keep = (toupper($0) ~ /^LOUNAS/)
            if (keep) print
            next
        }
        keep && /^  - / { print }
    '
}

# Replace the lunch block that sits directly after the "Gym + Rentuqa" line.
# Every old menu is removed first, even when today's fetch failed, so stale
# lunches never linger in the startup file.
update_lunch_block() {
    local output="$1" tmp
    tmp=$(mktemp) || return 1

    awk -v insert="$output" '
        /\* TODO Gym \+ Rentuqa/ {
            print
            if (insert != "") {
                print insert
            }
            in_gym = 1
            skipping = 1
            next
        }
        in_gym && skipping {
            # Old menu: section headers, meal bullets, and their blank lines.
            if ($0 ~ /\(veg\):$/ || $0 ~ /\(meat\):$/ ||
                $0 ~ /^  - / || $0 ~ /^[[:space:]]*$/) {
                next
            }
            # Keep one blank line before the rest of the Gym section.
            print ""
            skipping = 0
            print
            next
        }
        { print }
    ' "$STARTUP_FILE" > "$tmp" || { rm -f "$tmp"; return 1; }

    cat "$tmp" > "$STARTUP_FILE" || { rm -f "$tmp"; return 1; }
    rm -f "$tmp"
}

# Wait for the network and today's menu before opening the editor. If the
# fetch keeps failing, still open the file with any stale menu removed.
RENTUKKA_OUTPUT=""
deadline=$((SECONDS + 120))
while [ "$SECONDS" -lt "$deadline" ]; do
    RENTUKKA_OUTPUT=$(fetch_rentukka_output)
    [ -n "$RENTUKKA_OUTPUT" ] && break
    sleep 5
done

update_lunch_block "$RENTUKKA_OUTPUT"

exec nvim -c 'lua vim.api.nvim_feedkeys(vim.g.mapleader .. "re" .. vim.g.mapleader .. "rt", "mx", false)' -- "$STARTUP_FILE"
