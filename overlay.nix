self: super:

# This overlay adds this repository as a package to the nixpkgs available
# in all of the modules. This is used to make our custom configuration.nix
# and modules this system was built with are available under /etc/nixos/holoport

{
  holoportModules = self.stdenv.mkDerivation {
    name = "holoport-modules";
    src = builtins.filterSource (path: type: type != "symlink" || baseNameOf path != ".git") ./.;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };
}
