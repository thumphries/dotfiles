# Entirely derived from Chris Martin
# https://github.com/chris-martin/home/blob/master/nix/config.nix
let

  # all of the configuration except the package overrides
  config-without-overrides = {
    allowUnfree = true;
  };

  # packages defined locally that aren't in nixpkgs
  new-packages = pkgs: {
    # fullwidth = pkgs.callPackage ./pkgs/fullwidth { };
  };

  # slightly more convenient aliases for packages defined in nixpkgs
  aliases = pkgs: {
    inherit (pkgs.xorg) xkill;
  };

  # executables from haskellPackages
  haskell-apps = pkgs:
    let
      package-names = [
        "pretty-show"
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
      cabal-install
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
