{ nixpkgs, system, holoport, nixpkgsVersionSuffix }:

(import "${nixpkgs}/nixos/lib/eval-config.nix" {
  inherit system;
  modules = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

    # These modules are needed to inject the correct nixos version from Hydra
    ../modules/base.nix
    ../modules/version.nix

    # The custom config for our install iso
    ({ pkgs, ... }: {
      isoImage.isoBaseName = "holoportos";
      holoport.versionSuffix = ".${toString holoport.revCount}.${holoport.shortRev}";
      holoport.revision = holoport.rev or holoport.shortRev;

      system.nixos.versionSuffix = nixpkgsVersionSuffix;
      system.nixos.revision = nixpkgs.rev or nixpkgs.shortRev;

      # The NIXOS_CONFIG variable will be used by nixos-install on the so
      # as the configuration of the system to install. This configuration
      # will first import the actual configuration.nix that was generated
      # with nixos-generated-config on the target fs mount on /mnt.
      # Additionally, all our custom modules will be imported so our
      # configuration is applied.
      environment.variables.NIXOS_CONFIG =
        toString (pkgs.writeText "holoport-configuration.nix" ''
          {
            imports = [ "/mnt/etc/nixos/configuration.nix" ]
              ++ (import "${pkgs.holoportModules}/modules/module-list.nix");
          }
        '');
    })
  ];
}).config.system.build.isoImage
