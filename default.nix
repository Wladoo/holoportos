{ holoport ? { outPath = ./.; revCount = 0; shortRev = "master"; }
, nixpkgs ? { outPath = fetchTarball "https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz";
              revCount = 0; shortRev = "latest"; }
, system ? builtins.currentSystem
}:

let

  pkgs = import nixpkgs { inherit system; };
  lib = pkgs.lib;

  nixpkgsVersionSuffix = ".${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

in

{
  iso = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
    inherit system;
    modules = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

      # These modules are needed to inject the correct nixos version from Hydra
      ./modules/base.nix
      ./modules/version.nix

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
    }).config.system.build.isoImage;

  channels.nixpkgs = import "${nixpkgs}/nixos/lib/make-channel.nix" {
    inherit pkgs nixpkgs;
    version = lib.fileContents "${nixpkgs}/.version";
    versionSuffix = nixpkgsVersionSuffix;
  };

  channels.holoport = pkgs.releaseTools.makeSourceTarball {
    name = "holoport-channel";
    src = holoport;
    version = lib.fileContents ./.version;
    versionSuffix = ".${toString holoport.revCount}.${holoport.shortRev}";

    distPhase = ''
      rm -rf .git*
      echo -n "$VERSION_SUFFIX" > .version-suffix
      echo -n ${holoport.rev or holoport.shortRev} > .git-revision
      releaseName=holoport-$VERSION$VERSION_SUFFIX
      mkdir -p $out/tarballs
      cp -prd . ../$releaseName
      cd ..
      chmod -R u+w $releaseName
      tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
    '';
  };
}
