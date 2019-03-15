{ stdenv, pkgs }:

let

    version = "0.0.1";

in stdenv.mkDerivation
rec
{

    name = "hpplustest-${version}";

    src = ../scripts/hpplustest;

    installPhase =
        ''
            mkdir -p $out
            cp -R ./bin $out/bin
        '';

}