self: super:

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
