{ pkgs }:
pkgs.buildEnv {
  name = "desktop-env";

  # make this a low-priority package so ad hoc installs can override it
  meta.priority = 10;

  paths = [
    # nix
    pkgs.nix-prefetch-scripts

    # git
    pkgs.gitAndTools.gitFull
    pkgs.gitAndTools.git-bz
    pkgs.gitAndTools.git-extras
    pkgs.gitAndTools.hub
    pkgs.tig

    # search
    pkgs.ripgrep
    pkgs.silver-searcher

    # aws
    pkgs.awscli

    # emacs
    pkgs.emacs

    # mosh
    pkgs.mosh
  ];
}
