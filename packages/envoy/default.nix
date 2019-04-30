{ pkgs, stdenv, fetchzip, ... }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "envoy";
  src = fetchzip {
    url = https://github.com/samrose/envoy/archive/tmp-demo.zip;
    sha256 = "1c4pa30rmpfaq2xfhzpg6sgv2aibhyw2z5drlxm4l67ssy95kzwn";
  };
  unpackPhase = ":";
  
  installPhase = ''
    mkdir -p $out/envoy
    cp -r $src/*  $out/envoy
  '';
}
