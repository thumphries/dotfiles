{ stdenv, fetchgit, rustPlatform }:
rustPlatform.buildRustPackage rec {
  name = "spotifyd";

  src = fetchgit {
    url = "https://github.com/spotifyd/spotifyd";
    rev = "1bd2967e343d0a309f3bc41981d37076e0eb01c6";
    sha256 = "071id57s2vzhrkx4ry411awyk4g38vvxyq51qazg5hrglzbk6flj";
  };

  cargoSha256 = "071id57s2vzhrkx4ry411awyk4g38vvxyq51qazg5hrglzbk6flj";

  patches = [ ./noreplace.patch ];

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon.";
    homepage = https://github.com/spotifyd/spotifyd;
    license = licenses.gpl3;
  };
}
