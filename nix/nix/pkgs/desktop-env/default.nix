{ pkgs }:
let
  termite = pkgs.termite-config {
    font-face = "Monospace";
    font-size = 12;
    allow-bold = true;
    scrollbar = false;
    scrollback = -1;
    audible-bell = false;
    clickable-url = true;
    foreground = "#c0c0c0";
    background = "rgba(23, 23, 23, 0.95)";
  };
in
  pkgs.buildEnv {
    name = "desktop-env";

    # make this a low-priority package so ad hoc installs can override it
    meta.priority = 10;

    paths = [
      # shell
      pkgs.shell-env

      # window manager
      pkgs.xinitrc
      pkgs.xalternative
      pkgs.dmenu

      pkgs.xmobar
      pkgs.compton-git

      # x11
      pkgs.scrot
      pkgs.screenshot

      # terminal
      pkgs.rxvt_unicode-with-plugins
      termite

      # media
      pkgs.feh
    ];
  }
