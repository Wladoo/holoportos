{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
}:

{
  iso = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
      inherit system;
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./modules/base.nix

        ({ pkgs, lib, ... }: {
          isoImage.isoBaseName = "holoportos";
          environment.variables.NIXOS_CONFIG =
            toString (pkgs.writeText "holoport-configuration.nix" ''
              {
                imports = [ "/mnt/etc/nixos/configuration.nix" ]
                  ++ (import "${pkgs.holoportModules}/modules/module-list.nix");
              }
            '');
        })
      ];
    }).config.system.build.isoImage;
}
