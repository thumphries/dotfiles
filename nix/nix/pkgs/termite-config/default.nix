{ stdenv, makeWrapper, symlinkJoin, writeTextFile, termite, config }:
let
  config-file = writeTextFile {
    name = "termite-conf";
    executable = false;
    destination = "/etc/termite.conf";
    text = ''
      [options]
      font = ${ config.font-face } ${ toString config.font-size }
      allow_bold = ${ bool config.allow-bold }
      scrollbar = ${ bool config.scrollbar }
      audible_bell = ${ bool config.audible-bell }
      scrollback_lines = ${ toString config.scrollback }
      clickable_url = ${ bool config.clickable-url }
      foreground = ${ config.foreground }
      background = ${ config.background }
    '';
  };
  bool = b : if b then "true" else "false";
in
  symlinkJoin {
    name = "termite-config";

    paths = [ config-file termite ];

    buildInputs = [ termite makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/termite \
        --add-flags "--config=${config-file}/etc/termite.conf"
    '';
  }
