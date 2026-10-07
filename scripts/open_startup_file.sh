#!/usr/bin/env bash

# Change this path to open a different file when Hyprland starts.
STARTUP_FILE="$HOME/agenda.org"

exec nvim -c 'lua vim.api.nvim_feedkeys(vim.g.mapleader .. "re" .. vim.g.mapleader .. "rt", "mx", false)' -- "$STARTUP_FILE"
