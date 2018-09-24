self: super:

# This overlay adds this repository as a package to the nixpkgs available
# in all of the modules. This is used to create our custom configuration.nix
# that imports our modules into the NixOS modules

{
  holoportModules = builtins.path {
    name = "holoport-modules";
    path = ./.;
    filter = (path: type: type != "symlink" || baseNameOf path != ".git");
  };
}
