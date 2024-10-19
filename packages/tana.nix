{ lib
, fetchurl
, undmg
, stdenv
}:
let
  pkgs = import <nixpkgs> { }; # bring all of Nixpkgs into scope
in

stdenv.mkDerivation (finalAttrs: {
  pname = "Tana";
  version = "1.0.16";
  src = fetchurl {
    url = "https://github.com/tanainc/tana-desktop-releases/releases/download/v1.0.16/Tana-1.0.16-universal.dmg";
    hash = "sha256-gbTkyzTIfsh7XE8qeKEjt8kdhxS00WUgwHjuqm4KnZc=";
  };


  sourceRoot = "Tana.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Tana.app"
    cp -R . "$out/Applications/Tana.app"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The world’s most powerful notes where AI can do real work";
    homepage = "https://tana.inc";
    license = licenses.unfree;
    maintainers = with maintainers; [ smarchetti ];
    platforms = platforms.darwin;
  };
})
