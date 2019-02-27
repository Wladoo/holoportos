self: super:

# This overlay adds this repository as a package to the nixpkgs available
# in all of the modules. This is used to create our custom configuration.nix
# that imports our modules into the NixOS modules
let
  callPackage = super.lib.callPackageWith super;

in

{
  holoportModules = builtins.path {
    name = "holoport-modules";
    path = ./.;
    filter = (path: type: type != "symlink" || baseNameOf path != ".git");
  };


  holoport-cloudflared = callPackage ./modules/holoport-cloudflared/cloudflared.nix {};
  holochain-conductor = callPackage ./packages/holoport-rust.nix {};

}
