{ stdenv, fetchgit, libX11, libXinerama, libXft }:
stdenv.mkDerivation rec {
  name = "dwm";
  version = "0.6";

  src = fetchgit {
    url = "https://github.com/thumphries/dwm";
    rev = "60e19e1a291821a151024d3ff864962a445a7cca";
    sha256 ="0zy1jfwknyxw28x3lzi3459gh5ggfcyyq1wp2x6jgf5sjnr5hw5f";
  };

  buildInputs = [
    libX11
    libXinerama
    libXft
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dwm $out/bin
  '';

  meta = {
    homepage = "https://github.com/thumphries/dwm";
    description = "Dynamic window manager for X11 (patched)";
    license = stdenv.lib.licenses.mit;
  };
}
