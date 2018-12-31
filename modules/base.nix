{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.holoport;
in
{
  options = {
    holoport.modules = mkOption {
      internal = true;
      type = types.path;
      default = pkgs.holoportModules;
      description = ''
        Path to the current holoport checkout in the Nix store
      '';
    };

    holoport.channels.nixpkgs = mkOption {
      type = types.str;
      # FIXME: final url
      default = "http://ec2-18-188-14-36.us-east-2.compute.amazonaws.com/job/holoportOS/master/channels.nixpkgs/latest/download/1";
      description = ''
        URL understood by Nix to a nixpkgs/NixOS channel
      '';
    };

    holoport.channels.holoport = mkOption {
      type = types.str;
      # FIXME: final url
      default = "http://ec2-18-188-14-36.us-east-2.compute.amazonaws.com/job/holoportOS/master/channels.holoport/latest/download/1";
      description = ''
        URL understood by Nix to the Holoport channel
      '';
    };

    holoport.isInstallMedium = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    { nixpkgs.overlays = [ (import ../overlay.nix) ]; }

    (mkIf (!cfg.isInstallMedium) {
      boot.loader.grub.splashImage = (pkgs.fetchurl {
        url = "https://holo.host/wp-content/uploads/2017/11/HOL215_HoloPort_6.png";
        sha256 = "1cp4p4xd1wq4ad9b3bnpa4rznjhxnfsi6xd3j2bwy137q46c3k21";
      });

      nix.nixPath = lib.mkForce [
        # The nixpkgs used for nixos-rebuild and all other nix commands
        "nixpkgs=${cfg.channels.nixpkgs}"

        # The custom configuration.nix that injects our modules
        "nixos-config=/etc/nixos/holoport-configuration.nix"
      ];

      # Caches tarballs obtained via fetchurl for 60 seconds, mainly
      # used for the channels
      nix.extraOptions = ''
        tarball-ttl = 60
      '';

      environment.etc."nixos/holoport-configuration.nix" = {
        text = replaceStrings ["%%HOLOPORT_MODULES_PATH%%"] [pkgs.holoportModules]
          (readFile ../configuration.nix);
      };
    })
  ];
}
