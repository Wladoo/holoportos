{ pkgs, stdenv, fetchFromGitHub, recurseIntoAttrs, makeRustPlatform, runCommand }:
let
  rustOverlayRepo = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e37160aaf4de5c4968378e7ce6fe5212f4be239f";
    sha256 = "013hapfp76s87wiwyc02mzq1mbva2akqxyh37p27ngqiz0kq5f2n";
  };
  rustOverlay = import "${rustOverlayRepo}/rust-overlay.nix";
  nixpkgs = import <nixpkgs> { overlays = [ rustOverlay ]; };
  rust = rec {

    channels = (nixpkgs.rustChannelOfTargets
      "nightly"
      "2019-01-24"
      [ "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" ]
     );
  };
  rustc = rust.channels;
  cargo = rust.channels;
  #rustPlatform = makeRustPlatform {rustc = rustc; cargo = cargo;};
  fetchcargo = pkgs.callPackage (import ./fetchcargo.nix) { inherit rust; };
  buildRustPackage = pkgs.callPackage (import ./build-rust-package.nix) { inherit rust; };
in
pkgs.callPackage ./derivation.nix {
  inherit buildRustPackage rust;
}