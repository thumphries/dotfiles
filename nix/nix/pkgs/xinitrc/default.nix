{ stdenv, symlinkJoin, writeShellScriptBin
, compton-git, setxkbmap, xalternative, xsettingsd }:
let
  script = writeShellScriptBin "xinitrc" ''
    set -euo pipefail
    # QT_AUTO_SCREEN_SCALE_FACTOR=1
    # export QT_AUTO_SCREEN_SCALE_FACTOR
    # GDK_SCALE=2
    # export GDK_SCALE
    ${setxkbmap}/bin/setxkbmap -option ctrl:nocaps
    ${xsettingsd}/bin/xsettingsd &
    ${compton-git}/bin/compton &
    ${xalternative}/bin/xalt
  '';
in
  symlinkJoin rec {
    name = "xinitrc";
    paths = [ script ];
    meta = {
      description = "X init script";
      license = stdenv.lib.licenses.bsd3;
    };
  }
