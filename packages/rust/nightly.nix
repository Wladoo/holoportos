{ stdenv, callPackage, rustPlatform, llvm, fetchurl
, targets ? [ "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" ]
, targetToolchains ? []
, targetPatches ? []
}:

rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform;

    version = "nightly-2019-01-24";

    configureFlags = [ "--release-channel=nightly" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/2019-01-24/rustc-nightly-src.tar.gz";
      sha256 = "bf9715a05565040ab962a5d92d154d6842f60a68a6f463cd40b6660af0526c73";
    };

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    doCheck = false;
    broken = true;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "1.33.0-nightly";
    srcRev = "907c0febe7045fa02dff2a35c5e36d3bd59ea50d";
    srcSha = "0i0afgbv09k6h167sc5l4grlwbyphbyfzq8i4pcr86x7c54z8z8a";
    cargoSha256 = "1mrgd8ib48vxxbhkvsqqq4p19sc6b74x3cd8p6lhhlm6plrajrvm";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
