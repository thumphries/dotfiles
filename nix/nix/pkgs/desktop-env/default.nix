{ pkgs }:
pkgs.buildEnv {
  name = "desktop-env";

  # make this a low-priority package so ad hoc installs can override it
  meta.priority = 10;

  paths = [
    # shell
    pkgs.shell-env

    # window manager
    pkgs.xalternative
    pkgs.xmobar
    pkgs.compton-git

    # x11
    pkgs.scrot
    pkgs.screenshot

    # terminal
    pkgs.termite

    # media
    pkgs.feh
  ];
}
