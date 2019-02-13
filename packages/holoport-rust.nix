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
        base = super.rustChannelOf { date = "2017-07-12"; channel = "nightly"; };
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
  name = "ripgrep-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "0y5d1n6hkw85jb3rblcxqas2fp82h3nghssa4xqrhqnz25l799pj";
  };

  cargoSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

  meta = with stdenv.lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
