#!/bin/bash

DOTFILES="$HOME/configs/linux"

echo "=== Creating Symlinks ==="
mkdir -p "$HOME/.config"

# Handle linux/.config
for item in "$DOTFILES"/.config/*; do
    name=$(basename "$item")
    target="$HOME/.config/$name"
    rm -rf "$target"

    echo "Linking: $item → $target"
    ln -s "$item" "$target"
done

# Handle root dotfiles.
for item in "$DOTFILES"/.*; do
    [[ "$item" == *"/." || "$item" == *"/.." ]] && continue
    [[ "$item" == *"/.config" ]] && continue

    name=$(basename "$item")
    target="$HOME/$name"
    rm -rf "$target"

    echo "Linking: $item → $target"
    ln -s "$item" "$target"
done

echo "=== Symlinking Complete ==="
