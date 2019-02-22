super: self:

let
  rustOverlayRepo = self.fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e37160aaf4de5c4968378e7ce6fe5212f4be239f";
    sha256 = "013hapfp76s87wiwyc02mzq1mbva2akqxyh37p27ngqiz0kq5f2n";
  };
  rustOverlay = import "${rustOverlayRepo}/rust-overlay.nix" self super;
  rust_1_15_1 = rustOverlay.lib.rustLib.fromManifestFile (
    self.fetchurl {
      url = "https://static.rust-lang.org/dist/channel-rust-1.15.1.toml";
      sha256 = "4cf9a1a74dd0d5fdf0b0fabf473e8940f759093b3a1f11c8cef7a9f554d99c5b";
    }
  ) { inherit (self) stdenv fetchurl patchelf; };
  rust = { cargo = rust_1_15_1.rust; rustc = rust_1_15_1.rust; };
in
{
  inherit rust;
  rustPlatform = rec {
    inherit rust;
    rustRegistry = self.callPackage <nixpkgs-base/pkgs/top-level/rust-packages.nix> {};
    buildRustPackage =
      let orig = self.callPackage <nixpkgs-base/pkgs/build-support/rust> { inherit rust rustRegistry; };
      in args: orig ({
        # For some reason, it tries to use arm-linux-gnueabihf-gcc by default and fails
        # https://github.com/rust-lang/cargo/blob/46bba437205f69c40b2376036aee60ede4fe52bd/src/ci/docker/cross/Dockerfile#L4-L18
        CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER="gcc";
      } // args);
  };
}