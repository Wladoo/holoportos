{ stdenv, pkgs }:

let

    version = "0.0.1";

in stdenv.mkDerivation
rec
{

    name = "hptest-${version}";

    src = ../scripts/hptest;

    installPhase =
        ''
            mkdir -p $out
            cp -R ./bin $out/bin
        '';

}