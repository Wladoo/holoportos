{ pkgs, stdenv, fetchurl, fetchFromGitHub, recurseIntoAttrs, makeRustPlatform, runCommand, openssl }:
let
  rustOverlay = fetchurl {
    url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
    sha256 = "013hapfp76s87wiwyc02mzq1mbva2akqxyh37p27ngqiz0kq5f2n";
  };


  nixpkgs = import pkgs.path { overlays = [ rustOverlay ]; };
  holoRust = rec {

    channels = (nixpkgs.rustChannelOfTargets
      "nightly"
      "2019-01-24"
      [ "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" ]
     );
  };
  rustc = holoRust.channels;
  cargo = holoRust.channels;
  rust = makeRustPlatform {rustc = rustc; cargo = cargo;};
  openssl-1_02p = openssl.overrideAttrs(oldAttrs: rec {
    version = "1.0.2p";
    sha256 = "003xh9f898i56344vpvpxxxzmikivxig4xwlm7vbi7m8n43qxaah";
    patches = [];
  });


in
stdenv.mkDerivation {
  name = "holochain-conductor";

  src = fetchurl {
    url = https://github.com/holochain/holochain-rust/releases/download/v0.0.7-alpha/conductor-v0.0.7-alpha-x86_64-ubuntu-linux-gnu.tar.gz;
    sha256 = "1f15yp4aw866hxqr3mswic2scz41mklc5s2vhn5nv7kxxbqjdqgc";
  };
  buildInputs = [
    openssl-1_02p
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp holochain $out/bin
    patchelf --set-interpreter \
        ${stdenv.glibc}/lib/ld-linux-x86-64.so.2  $out/bin/holochain
    patchelf --set-rpath  ${stdenv.glibc}/lib $out/bin/holochain
    patchelf --set-rpath ${openssl-1_02p.out}/lib $out/bin/holochain
  '';
}