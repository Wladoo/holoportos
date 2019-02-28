{ stdenv, pkgs, lib, config, fetchurl, ... }:

{
   systemd.services.conductor = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start conductor service";
      serviceConfig = {
        Type = "forking";
        User = "holoport";
        ExecStart = ''/run/current-system/sw/bin/holochain -c test.toml'';
        #ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
   };

   #environment.systemPackages = [ pkgs.screen ];
}