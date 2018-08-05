# Entirely derived from Chris Martin
# https://github.com/chris-martin/home/blob/master/nix/config.nix
let

  # all of the configuration except the package overrides
  config-without-overrides = {
    allowUnfree = true;
  };

  # packages defined locally that aren't in nixpkgs
  new-packages = pkgs: {
    compton-config = cfg : pkgs.callPackage ./pkgs/compton-config { config = cfg; };
    desktop-env = pkgs.callPackage ./pkgs/desktop-env { };
    dwm = pkgs.callPackage ./pkgs/dwm { };
    screenshot = pkgs.callPackage ./pkgs/screenshot { };
    shell-env = pkgs.callPackage ./pkgs/shell-env { };
    spotifyd = pkgs.callPackage ./pkgs/spotifyd { };
    termite-config = cfg : pkgs.callPackage ./pkgs/termite-config { config = cfg; };
    xalternative = pkgs.callPackage ./pkgs/xalternative { };
    xinitrc = compton : xsettings :
      pkgs.callPackage ./pkgs/xinitrc { compton = compton; xsettingsd = xsettings; };
    xrectsel = pkgs.callPackage ./pkgs/xrectsel { };
    xsettingsd-config = cfg : pkgs.callPackage ./pkgs/xsettingsd-config { config = cfg; };
  };

  # slightly more convenient aliases for packages defined in nixpkgs
  aliases = pkgs: {
    inherit (pkgs.xorg) xkill;
  };

  # executables from haskellPackages
  haskell-apps = pkgs:
    let
      package-names = [
        "dhall"
        "dhall-nix"
        "xmobar"
      ];
      f = x: {
        name = x;
        value =
          pkgs.haskell.lib.justStaticExecutables
            pkgs.haskellPackages.${x};
      };
    in
      builtins.listToAttrs (builtins.map f package-names);

  # the packages that we cherry-pick from the 'unstable' channel
  from-unstable = pkgs: {
    inherit (unstable)
      ghc
      ghcid
    ;
  };

  # all of the package overrides
  package-overrides = pkgs:
       unstable-package-overrides pkgs
    // from-unstable pkgs
    // { nixpkgs-unstable = unstable; };

  # the full nixpkgs configuration
  config =
       config-without-overrides
    // { packageOverrides = package-overrides; };

  # the package overrides for the 'unstable' channel
  unstable-package-overrides = pkgs:
       new-packages pkgs
    // aliases pkgs
    // haskell-apps pkgs;

  # the nixpkgs configuration we use to instantiate the package set
  # from the 'unstable' channel
  config-for-unstable =
       config-without-overrides
    // { packageOverrides = unstable-package-overrides; };

  # the package set from the 'unstable' channel
  unstable = import <unstable> { config = config-for-unstable; };

in config
