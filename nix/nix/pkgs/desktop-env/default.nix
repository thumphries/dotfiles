{ pkgs }:
let
  termite = pkgs.termite-config {
    font-face = "Monospace";
    font-size = 11;
    allow-bold = true;
    scrollbar = false;
    scrollback = -1;
    audible-bell = false;
    clickable-url = true;
    foreground = "#C0C0C0";
    background = "rgba(23, 23, 23, 0.9)";
    #background = "#171717";
  };

  compton = pkgs.compton-config {
    fade-delta = 10;
  };

  xsettingsd = pkgs.xsettingsd-config {
  };

  xinitrc = pkgs.xinitrc compton xsettingsd;
in
  pkgs.buildEnv rec {
    name = "desktop-env";

    # make this a low-priority package so ad hoc installs can override it
    meta.priority = 10;

    paths = [
      # shell
      pkgs.shell-env

      # window manager
      xinitrc
      pkgs.xalternative
      pkgs.dmenu
      pkgs.xmobar
      compton

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
