{ system ? builtins.currentSystem
, fetchFromGitHub ? (pkgs {}).fetchFromGitHub
, fetchurl ? (pkgs {}).fetchurl
, rustOverlay ? fetchFromGitHub {
    owner  = "mozilla";
    repo   = "nixpkgs-mozilla";
    rev    = "7e54fb37cd177e6d83e4e2b7d3e3b03bd6de0e0f";
    sha256 = "1shz56l19kgk05p2xvhb7jg1whhfjix6njx1q4rvrc5p1lvyvizd";
  }
}:
pkgs {
    overlays = [

      (import (builtins.toPath "${rustOverlay}/rust-overlay.nix"))

      #(self: super: { rustRegistry = super.callPackage ./rust-packages.nix { }; }) # by adding the rustRegistry entry here in the overlay, the specific rustRegistry date / SHA will be used in the later overlays and compiles.

      (self: super:
      let
        # base = super.rustChannels.nightly;
        base = super.rustChannelOfTargets { date = "2019-01-24"; channel = "nightly"; target = "wasm32-unknown-unknown"; };
      in
      {
        rust = {
          rustc = base.rust;
          cargo = base.cargo;
        };
        rustPlatform = super.recurseIntoAttrs (super.makeRustPlatform {
          rustc = base.rust;
          cargo = base.cargo;
        });
      })
    ];

pkgs.rustPlatform.buildRustPackage = rec {
  name = "hello_world";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "samrose";
    repo = "hello_world";
    rev = "082775d0388552e32b644a1e3da8755a5f5e8c6a";
    sha256 = "1jhkhpyh8g0ja6rr8bffphybhz53m7fav6r8pndv94msjdjdc7f6";
  };
  buildInputs = [ pkgs.rustc pkgs.cargo ];
  cargoSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with pkgs.stdenv.lib; {
    description = "a test";
    homepage = https://github.com/samrose/hello_world;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
};
}