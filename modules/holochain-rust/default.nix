{  pkgs, ... }:
let

  moz_overlay = import ((import <nixpkgs> {}).fetchFromGitHub
    { owner = "mozilla";
      repo = "nixpkgs-mozilla";
      inherit
       ({ url = "https://github.com/mozilla/nixpkgs-mozilla";
          rev = "507efc7f62427ded829b770a06dd0e30db0a24fe";
          sha256 = "17p1krbs6x6rnz59g46rja56b38gcigri3h3x9ikd34cxw77wgs9";
          fetchSubmodules = false;
	}) rev sha256;
  });

  nixpkgs = import <nixpkgs> {
    overlays = [ moz_overlay ];
  };

  date = "2019-01-24";
  wasmTarget = "wasm32-unknown-unknown";
    rust-build = (nixpkgs.rustChannelOfTargets "nightly" date [ wasmTarget ]);

  nodejs-8_13 = nixpkgs.nodejs-8_x.overrideAttrs(oldAttrs: rec {
    name = "nodejs-${version}";
    version = "8.13.0";
    src = pkgs.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1qidcj4smxsz3pmamg3czgk6hlbw71yw537h2jfk7iinlds99a9a";
    };
  });
in
with nixpkgs;
stdenv.mkDerivation rec {

 name = "holochain-rust-environment";

  buildInputs = [

    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
    binutils gcc gnumake openssl pkgconfig coreutils

    cmake
    python
    pkgconfig
    rust-build

    nodejs-8_13
    yarn
    zeromq4
   ];
}
