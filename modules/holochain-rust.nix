{ config, pkgs, ... }:
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> {
    overlays = [ moz_overlay ];
  };

  date = "2019-01-24";
  wasmTarget = "wasm32-unknown-unknown";

  rust-build = (nixpkgs.rustChannelOfTargets "nightly" date [ wasmTarget ]);



in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "holochain_rust";
    buildInputs = [
      rust-build
      ];
  }