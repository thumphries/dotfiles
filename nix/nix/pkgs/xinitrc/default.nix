{ stdenv, symlinkJoin, writeShellScriptBin
, compton-git, setxkbmap, xalternative }:
let
  script = writeShellScriptBin "xinitrc" ''
    set -euo pipefail
    ${setxkbmap}/bin/setxkbmap -option ctrl:nocaps
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
