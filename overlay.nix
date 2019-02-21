self: super:

# This overlay adds this repository as a package to the nixpkgs available
# in all of the modules. This is used to create our custom configuration.nix
# that imports our modules into the NixOS modules
let
  callPackage = super.lib.callPackageWith super;
  #newScope = super.lib.newScope super;
  rustNightly = (super.recurseIntoAttrs (callPackage ./packages/rust/nightly.nix {}));
  rust = rustNightly;
  cargo = rust.cargo;
  rustc = rust.rustc;
  makeRustPlatform = rust: super.lib.fix (self:
    let
      callPackage = super.newScope self;
    in {
      inherit rust;

      buildRustPackage = callPackage ./packages/rust/build-support/rust {
        inherit rust;
      };

      rustcSrc = super.stdenv.mkDerivation {
        name = "rust-src";
        src = rust.rustc.src;
        phases = ["unpackPhase" "installPhase"];
        installPhase = "mv src $out";
      };

  });
  holorustPlatform = super.recurseIntoAttrs (makeRustPlatform rust);

in

{
  holoportModules = builtins.path {
    name = "holoport-modules";
    path = ./.;
    filter = (path: type: type != "symlink" || baseNameOf path != ".git");
  };


  holoport-cloudflared = callPackage ./modules/holoport-cloudflared/cloudflared.nix {};
  hello-rust = callPackage ./packages/holoport-rust.nix { rustPlatform = holorustPlatform; };

}
