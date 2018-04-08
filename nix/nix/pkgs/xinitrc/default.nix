{ stdenv, symlinkJoin, writeShellScriptBin
, compton, setxkbmap, xalternative, xsetroot, xsettingsd }:
let
  script = writeShellScriptBin "xinitrc" ''
    set -euo pipefail
    # QT_AUTO_SCREEN_SCALE_FACTOR=1
    # export QT_AUTO_SCREEN_SCALE_FACTOR
    # GDK_SCALE=2
    # export GDK_SCALE
    ${xsetroot}/bin/xsetroot -cursor_name left_ptr
    ${setxkbmap}/bin/setxkbmap -option ctrl:nocaps
    ${xsettingsd}/bin/xsettingsd &
    ${compton}/bin/compton -b &
    ${xalternative}/bin/xalt
  '';
in
  symlinkJoin rec {
    name = "xinitrc";

    paths = [ script ];

    buildInputs = [ compton setxkbmap xalternative xsettingsd ];

    meta = {
      description = "X init script";
      license = stdenv.lib.licenses.bsd3;
    };
  }
