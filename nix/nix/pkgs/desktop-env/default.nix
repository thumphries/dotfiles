{ pkgs }:
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
    pkgs.termite

    # media
    pkgs.feh
  ];
}
