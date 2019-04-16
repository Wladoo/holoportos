{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.holochain; in {
  options = {
    services.holochain = {
      enable = mkEnableOption "Holochain conductor service";

      home = mkOption {
        type = types.path;
        default = "/var/lib/holochain";
        description = ''
          The directory where holochain will create files.
          Make sure it is writable.
        '';
      };

    };
  };


  config = mkIf cfg.enable {
    systemd.services.holochain = {
      description = "Holochain conductor service";
      after = [ "local-fs.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''/run/current-system/sw/bin/holochain -c /etc/holochain/holochain.toml'';
        WorkingDirectory = "${cfg.home}";
        Restart = "always";
        User = "holochain";
        StandardOutput = "journal";
      };
    };

    users.users.holochain = {
      description = "Holochain conductor service user";
      home = cfg.home;
      createHome = false;
      group = "holchain";
      uid = 401;
      gid = 401;
    };

  };

}