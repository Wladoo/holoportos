{ stdenv,
  fetchFromGitHub,
  pkgs ? (
  let
    pkgs = import <nixpkgs>;
    pkgs_ = (pkgs {});
    rustOverlay = (pkgs_.fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      rev = "1608d31f7e5b2415fb80b5d76f97c009507bc45f";
      sha256 = "0mznf82k7bxpjyvigxvvwpmi6gvg3b30l58z36x192q2xxv47v1k";
    });
  in (pkgs {
    overlays = [

      (import (builtins.toPath "${rustOverlay}/rust-overlay.nix"))

      (self: super: { rustRegistry = super.callPackage ./rust-packages.nix { }; }) # by adding the rustRegistry entry here in the overlay, the specific rustRegistry date / SHA will be used in the later overlays and compiles.

      (self: super:
      let
        # base = super.rustChannels.nightly;
        base = super.rustChannelOf { date = "2019-01-24"; channel = "nightly"; };
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
  }))
}:

pkgs.rustPlatform.buildRustPackage rec {
  name = "holochain-rust-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "e761215a3e8a384f98b43f3d09e42dc5c1f628a4";
    sha256 = "19n5njdyxif58vp84w1xl0b212xxlag6mv4q5plpqbg5a4xpbscd";
  };

  cargoSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

  meta = with stdenv.lib; {
    description = "Holochain Rust";
    homepage = https://github.com/holochain/holochain-rust;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
