{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Common
    tree
    evince
    zip
    unzip
    file

    # Programming
    go
    python3
    openjdk
    sqlite
    docker

    # Cpp stuff
    cmake
    gnumake
    gcc
    valgrind

    # Font
    fira-code

    # Browser
    firefox

    # Shell
    fish

    # Volume control
    pavucontrol

    # Torrent client
    qbittorrent

    # LaTex
    texliveMedium

    # Other
    spotify
  ];
}
