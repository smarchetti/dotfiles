{ lib
, fetchurl
, _7zz
, stdenv
}:
let
  pkgs = import <nixpkgs> { }; # bring all of Nixpkgs into scope
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tableplus";
  version = "574";
  src = fetchurl {
    url = "https://download.tableplus.com/macos/${finalAttrs.version}/TablePlus.dmg";
    hash = "sha256-woNJDKprE9iUCd23VXvDLMw7z5NhUdozyrsPVYETcKs=";
  };


  sourceRoot = "TablePlus.app";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/TablePlus.app"
    cp -R . "$out/Applications/TablePlus.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/TablePlus.app/Contents/MacOS/TablePlus" "$out/bin/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Database management made easy";
    homepage = "https://tableplus.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ smarchetti ];
    platforms = platforms.darwin;
  };
})
