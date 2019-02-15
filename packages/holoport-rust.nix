{ system ? builtins.currentSystem
, fetchFromGitHub ? (pkgs {}).fetchFromGitHub
, fetchurl ? (pkgs {}).fetchurl
, rustOverlay ? fetchFromGitHub {
    owner  = "mozilla";
    repo   = "nixpkgs-mozilla";
    rev    = "37f7f33ae3ddd70506cd179d9718621b5686c48d";
    sha256 = "0cmvc9fnr38j3n0m4yf0k6s2x589w1rdby1qry1vh435v79gp95j";
  }
  , makeRustPlatform
  , stdenv
}:
let
rust_overlay = import (builtins.toPath "${rustOverlay}/rust-overlay.nix");
nixpkgs = import <nixpkgs> {
  overlays = [ rust_overlay ];
};
date = "2019-01-24";
wasmTarget = "wasm32-unknown-unknown";

rust = (nixpkgs.rustChannelOfTargets "nightly" date [ wasmTarget ]);

rustPlatform = makeRustPlatform {
  rustc = rust.rust;
  inherit (rust) cargo;
};
in
rustPlatform.buildRustPackage = rec {
  name = "hello_world";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "hello_world";
    rev = "082775d0388552e32b644a1e3da8755a5f5e8c6a";
    sha256 = "1jhkhpyh8g0ja6rr8bffphybhz53m7fav6r8pndv94msjdjdc7f6";
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
};
}