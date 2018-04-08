{ stdenv, makeWrapper, symlinkJoin, writeTextFile, termite, config ? {} }:
let
  defaultConfig = {
    font-face = "Monospace";
    font-size = 11;
    allow-bold = true;
    scrollbar = true;
    scrollback = 10000;
    audible-bell = true;
    clickable-url = true;
    foreground = "#C0C0C0";
    background = "#171717";
  };

  cfg = config // defaultConfig;

  config-file = writeTextFile {
    name = "termite-conf";
    executable = false;
    destination = "/etc/termite.conf";
    text = ''
      [options]
      font = ${ cfg.font-face } ${ toString cfg.font-size }
      allow_bold = ${ bool cfg.allow-bold }
      scrollbar = ${ bool cfg.scrollbar }
      audible_bell = ${ bool cfg.audible-bell }
      scrollback_lines = ${ toString cfg.scrollback }
      clickable_url = ${ bool cfg.clickable-url }
      foreground = ${ cfg.foreground }
      background = ${ cfg.background }
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
