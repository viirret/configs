#!/usr/bin/env python3

import os
import shutil
import magic
from colorama import Fore, Style

# Current user home dir.
HOME_DIR = os.path.expanduser("~")

DIRECTORIES_TO_SCAN = [HOME_DIR, os.path.join(HOME_DIR, "Downloads")]

# Directories where to move files.
images = "Images"
documents = "Documents"
music = "Music"
videos = "Videos"
snippets = "Snippets"

EXTENSION_DIR_MAP = {
    ".jpg": images,
    ".png": images,
    ".gif": images,
    ".webp": images,
    ".pdf": documents,
    ".mp3": music,
    ".mp4": videos,
    ".sh": snippets,
    ".py": snippets,
    ".cc": snippets,
    ".ts": snippets,
    ".js": snippets,
    ".lua": snippets,
    ".fish": snippets,
}

PREVIEW_SIZE_LIMIT = 500

ITEMS_TO_IGNORE = [
    "code",  # Own git repos
    "Backup",
    "Games",
    "Notes",
    "Snippets",
    "go",
    "README.md",  # .dotfiles
    "sway.log",  # sway
]

magic_instance = magic.Magic(mime=True)


def is_text_file(file_path):
    mime_type = magic_instance.from_file(file_path)
    return mime_type is not None and mime_type.startswith("text")


def should_ignore(item):
    return item.startswith(".") or item in ITEMS_TO_IGNORE


def get_user_action(file_path):
    print(f"File: {Fore.YELLOW}{file_path}{Style.RESET_ALL}")
    action = (
        input("What would you like to do? (m: move, d: delete, s: skip): ")
        .strip()
        .lower()
    )
    return action


def print_file_preview(file_path):
    try:
        file_size = os.path.getsize(file_path)
        if file_size == 0:
            print("No preview, empty file")
            return

        if not is_text_file(file_path):
            print(f"No preview available for non-text file: {file_path}")
            return

        if file_size > PREVIEW_SIZE_LIMIT:
            with open(file_path, "r", errors="ignore") as file:
                content = file.read(PREVIEW_SIZE_LIMIT)
                print(f"Preview (first {PREVIEW_SIZE_LIMIT} characters):\n{content}\n")
        else:
            with open(file_path, "r", errors="ignore") as file:
                content = file.read()
                print(f"Preview:\n{content}\n")
    except Exception as e:
        print(f"An error occurred: {e}")


def organize_file(file_path, dest_dir):
    destination_path = os.path.join(HOME_DIR, dest_dir)
    os.makedirs(destination_path, exist_ok=True)
    shutil.move(file_path, destination_path)
    print(f"Moved {file_path} to {destination_path}")


def main():
    for directory in DIRECTORIES_TO_SCAN:
        for root, dirs, files in os.walk(directory):
            dirs[:] = [d for d in dirs if not should_ignore(d)]
            for file in files:
                if should_ignore(file):
                    print(f"Automatically skipping file: {file}")
                    continue
                file_path = os.path.join(root, file)
                _, extension = os.path.splitext(file_path)
                dest_dir = EXTENSION_DIR_MAP.get(extension)
                print_file_preview(file_path)
                action = get_user_action(file_path)
                if action == "m":
                    organize_file(file_path, dest_dir)
                elif action == "d":
                    os.remove(file_path)
                    print(f"Deleted {file_path}")
                elif action == "s":
                    print(f"Skipped {file_path}")
                else:
                    print("Invalid action. Skipping file")
                print("")


if __name__ == "__main__":
    main()
