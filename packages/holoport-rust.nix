{ pkgs, stdenv, fetchFromGitHub, recurseIntoAttrs, makeRustPlatform }:
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
  rustPlatform = makeRustPlatform {rustc = rustc; cargo = cargo;};
in
rustPlatform.buildRustPackage rec {
  name = "hello_world";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "hello_world";
    rev = "371234178aba1496498393bbc2ee69e90474b299";
    sha256 = "0f4pi882jldyis70p019l2bvmyq4gr67ds9s0wxk5figivc35nym";
  };
  #buildInputs = [ pkgs.rustc pkgs.cargo ];
  cargoSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with stdenv.lib; {
    description = "a test";
    homepage = https://github.com/samrose/hello_world;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}