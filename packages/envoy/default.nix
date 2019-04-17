{ pkgs, stdenv, fetchzip, ... }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "envoy";
  src = fetchzip {
    url = https://github.com/samrose/samenvoy/archive/master.zip;
    sha256 = "0ws1yzrwnxldlwr0dgwvab3sv1afpxm2an1w01y1qln3r06l3lxf";
  };
  unpackPhase = ":";
  
  installPhase = ''
    mkdir -p $out/envoy
    cp -r $src/*  $out/envoy
  '';
}
