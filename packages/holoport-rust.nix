{ pkgs, stdenv, fetchurl, fetchFromGitHub, recurseIntoAttrs, makeRustPlatform, runCommand }:
let
   rustOverlayRepo = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e37160aaf4de5c4968378e7ce6fe5212f4be239f";
    sha256 = "013hapfp76s87wiwyc02mzq1mbva2akqxyh37p27ngqiz0kq5f2n";
  };
  rustOverlay = import "${rustOverlayRepo}/rust-overlay.nix";
  nixpkgs = import <nixpkgs> { overlays = [ rustOverlay ]; };
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

  release = "v0.0.4-alpha";
  archiveName = "conductor-v0.0.4-alpha-x86_64-ubuntu.tar.gz";
  fileDir = "conductor-v0.0.4-alpha-x86_64-unknown-linux-gnu";
in
stdenv.mkDerivation {
  name = "holochain-conductor";

  src = fetchurl {
    url = https://github.com/holochain/holochain-rust/releases/download/v0.0.4-alpha/conductor-v0.0.4-alpha-x86_64-ubuntu.tar.gz;
    sha256 = "0kxp52726dwhjxjhx7h14rav9vwbm6zkp4i49caq1p3gggja287q";
  };
  buildInputs = [
    rustc
    zeromq4
    openssl
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp holochain $out/bin
    patchelf --set-interpreter \
        ${stdenv.glibc}/lib/ld-linux-x86-64.so.2  $out/bin/holochain
    patchelf --set-rpath  ${stdenv.glibc}/lib $out/bin/holochain
    patchelf --add-needed ${zeromq4}/lib/libzmq.so.5 $out/bin/holochain
  '';
}