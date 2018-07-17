{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
}:

{
  iso = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
      inherit system;
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        { isoImage.isoBaseName = "holoportos"; }
        ./modules/base.nix
      ];
    }).config.system.build.isoImage;
}
