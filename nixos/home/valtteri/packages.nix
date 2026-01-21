{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Common
    tree
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
  ];
}
