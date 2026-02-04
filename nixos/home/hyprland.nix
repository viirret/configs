{ config, pkgs, ... }:

let
  modifier = "SUPER";
  terminal = "foot";
  browser = "firefox";
  menu = "wofi --show drun";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      env = [
        "XCURSOR_SIZE,24"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
      ];

      monitor = [ ",preferred,auto,1" ];

      exec-once = [
        "waybar"
      ];

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          ignore_opacity = false;
        };
      };

      windowrulev = [
        "opacity 0.9 0.8,class:^(${terminal})$"
      ];

      input = {
        kb_layout = "fi";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
      };

      bind = [
        "${modifier},RETURN,exec,${terminal}"
        "${modifier},B,exec,${browser}"
        "${modifier},D,exec,${menu}"

        "${modifier},Q,killactive"
        "${modifier},F,fullscreen,1"

        # Workspace bindings
        "${modifier},1,workspace,1"
        "${modifier},2,workspace,2"
        "${modifier},3,workspace,3"
        "${modifier},4,workspace,4"
        "${modifier},5,workspace,5"
        "${modifier},6,workspace,6"
        "${modifier},7,workspace,7"
        "${modifier},8,workspace,8"
        "${modifier},9,workspace,9"
        "${modifier},0,workspace,10"

        # Move window to workspace
        "${modifier} SHIFT,1,movetoworkspace,1"
        "${modifier} SHIFT,2,movetoworkspace,2"
        "${modifier} SHIFT,3,movetoworkspace,3"
        "${modifier} SHIFT,4,movetoworkspace,4"
        "${modifier} SHIFT,5,movetoworkspace,5"
        "${modifier} SHIFT,6,movetoworkspace,6"
        "${modifier} SHIFT,7,movetoworkspace,7"
        "${modifier} SHIFT,8,movetoworkspace,8"
        "${modifier} SHIFT,9,movetoworkspace,9"
        "${modifier} SHIFT,0,movetoworkspace,10"

        # Vim keys
        "${modifier},H,movefocus,l"
        "${modifier},L,movefocus,r"
        "${modifier},K,movefocus,u"
        "${modifier},J,movefocus,d"
        "${modifier} SHIFT,H,movewindow,l"
        "${modifier} SHIFT,L,movewindow,r"
        "${modifier} SHIFT,K,movewindow,u"
        "${modifier} SHIFT,J,movewindow,d"
      ];
    };
  };

  home.packages = with pkgs; [
    foot
    firefox
    wofi
    wl-clipboard
    swaylock
    swayidle
    mako
    grim
    slurp
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = browser;
  };
}
