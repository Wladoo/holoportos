{ pkgs, stdenv, fetchurl, fetchTarball, fetchFromGitHub, recurseIntoAttrs, makeRustPlatform, runCommand }:
let
  src = {
    url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
    sha256 = "013hapfp76s87wiwyc02mzq1mbva2akqxyh37p27ngqiz0kq5f2n";
  };


  rustOverlay =  (fetchTarball src );
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
    pkgs.zeromq4
    pkgs.openssl
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp holochain $out/bin
    patchelf --set-interpreter \
        ${stdenv.glibc}/lib/ld-linux-x86-64.so.2  $out/bin/holochain
    patchelf --set-rpath  ${stdenv.glibc}/lib $out/bin/holochain
    patchelf --add-needed ${pkgs.zeromq4}/lib/libzmq.so.5 $out/bin/holochain
  '';
}