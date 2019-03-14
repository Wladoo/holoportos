{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.holoport;
  nodejs-8_13 = pkgs.nodejs-8_x.overrideAttrs(oldAttrs: rec {
    name = "nodejs-${version}";
    version = "8.13.0";
    src = pkgs.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1qidcj4smxsz3pmamg3czgk6hlbw71yw537h2jfk7iinlds99a9a";
    };
  });

  pre-net-led = pkgs.callPackage ../packages/pre-net-led/pre-net-led.nix {};
  holo-led = pkgs.callPackage ../packages/holo-led/holo-led.nix {};
  shutdown-led = pkgs.callPackage ../packages/shutdown-led/shutdown-led.nix {};
  holo-health = pkgs.callPackage ../package/holo-health/holo-health.nix {};
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
      default = "http://holoportbuild.holo.host/job/holoportOs-testnet/testnet/channels.nixpkgs/latest/download/1";
      description = ''
        URL understood by Nix to a nixpkgs/NixOS channel
      '';
    };

    holoport.channels.holoport = mkOption {
      type = types.str;
      # FIXME: final url
      default = "http://holoportbuild.holo.host/job/holoportOs-testnet/testnet/channels.holoport-testnet/latest/download/1";
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
        url = "https://i.imgur.com/S8tZLqs.jpg";
        sha256 = "aa281dc590987818188ca27b3f6c0f56f975505c909a1fd2156be54a38a0e57e";
      });
      boot.loader.grub.memtest86.enable = true;
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
      nixpkgs.config.allowUnfree = true;
      environment.etc."nixos/holoport-configuration.nix" = {
        text = replaceStrings ["%%HOLOPORT_MODULES_PATH%%"] [pkgs.holoportModules]
          (readFile ../configuration.nix);
      };
      environment.systemPackages = with pkgs; [
        binutils
        cmake
        gcc
        holoport-cloudflared
        holochain-conductor
        nodejs-8_13
        smartmontools
        stress-ng
        lshw
        yarn
        zeromq4
      ];
      systemd.services.holochain = {
        enable = true;
        wants = [ "multi-user.target" ];
        description = "Manage holochain (conductor) service";
        serviceConfig = {
          Type = "forking";
          User = "holoport";
          ExecStart = ''/run/current-system/sw/bin/holochain -c ${../scripts/holochain-config.toml}'';
          ExecReload = ''/run/current-system/sw/bin/kill $MAINPID'';
          KillMode = "process";
          Restart = "on-failure";
        };
      };
      systemd.services.pre-net-led = {
        enable = true;
        wantedBy = [ "default.target" ];
        before = [ "network.target" ];
        description = "Turn on blinking red until network";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = ''${pre-net-led}/bin/pre-net-led'';
          StandardOutput = "journal";
        };
      };
      systemd.services.holo-up = {
        enable = true;
        wantedBy = [ "default.target" ];
        after = [ "getty.target" ];
        description = "Turn on aurora when all systems go";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = ''${holo-led}/bin/holo-led'';
          StandardOutput = "journal";
        };
      };
      systemd.services.holo-shutdown = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        description = "Flash blue on any request for shutdown/poweroff/reboot";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStop = ''${shutdown-led}/bin/shutdown-led'';
          StandardOutput = "journal";
          RemainAfterExit = "yes";
        };
      };
      systemd.services.holo-health = {
        enable = true;
        after = [ "getty.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = ''${holo-health}/bin/holo-health'';
          StandardOutput = "journal";
          RemainAfterExit = "yes";
          startAt = "*:00/5";
        };
      };
      services.osquery.enable = true;
      services.osquery.loggerPath = "/var/log/osquery/logs";
      services.osquery.pidfile = "/var/run/osqueryd.pid";

    })
  ];
}
