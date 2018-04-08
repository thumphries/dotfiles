{ stdenv, makeWrapper, symlinkJoin, writeTextFile, termite }:
let
  config = writeTextFile {
    name = "termite-conf";
    executable = false;
    destination = "/etc/termite.conf";
    text = ''
      [options]
      font = Monospace 12
      allow_bold = true
      scrollbar = off
      audible_bell = false
      scrollback_lines = -1
      foreground = #C0C0C0
      background = rgba(23, 23, 23, 0.95)
    '';
  };
in
  symlinkJoin {
    name = "termite-config";

    paths = [ config termite ];

    buildInputs = [ termite makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/termite \
        --add-flags "--config=${config}/etc/termite.conf"
    '';
  }
