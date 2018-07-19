{ holoport ? { outPath = ./.; revCount = 0; shortRev = "master"; }
, nixpkgs ? { outPath = fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.03.tar.gz";
              revCount = 0; shortRev = "latest"; }
, system ? builtins.currentSystem
}:

let

  pkgs = import nixpkgs { inherit system; };
  lib = pkgs.lib;


in

{
  iso = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
      inherit system;
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        # The custom config for our install iso
        ({ pkgs, ... }: {
          isoImage.isoBaseName = "holoportos";
          nixpkgs.overlays = [ (import ./overlay.nix) ];

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

  channels.nixos = import "${nixpkgs}/nixos/lib/make-channel.nix" {
    inherit pkgs nixpkgs;
    version = lib.fileContents "${nixpkgs}/.version";
    versionSuffix = ".${toString nixpkgs.revCount}.${nixpkgs.shortRev}";
   };

  channels.holoport = pkgs.releaseTools.makeSourceTarball {
    name = "holoport-channel";
    src = holoport;
    version = "0.1";
    versionSuffix = ".${toString holoport.revCount}.${nixpkgs.shortRev}";

    distPhase = ''
      rm -rf .git*
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
