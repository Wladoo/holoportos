self: super:

# This overlay adds this repository as a package to the nixpkgs available
# in all of the modules. This is used to create our custom configuration.nix
# that imports our modules into the NixOS modules
let
  callPackage = super.lib.callPackageWith super;
    rustOverlayRepo = self.fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "90d41cd5dd6c31c7bfaaab68dd6f00bae596d742";
    sha256 = "0cpv969mgv2v8fk6l9s24xq1qphwsvzbhf8fq4v6bkkwssm0kzn6";
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
  holoportModules = builtins.path {
    name = "holoport-modules";
    path = ./.;
    filter = (path: type: type != "symlink" || baseNameOf path != ".git");
  };

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
  holoport-cloudflared = callPackage ./modules/holoport-cloudflared/cloudflared.nix {};
  #holoport-rust = callPackage ./packages/holoport-rust.nix {};
}
