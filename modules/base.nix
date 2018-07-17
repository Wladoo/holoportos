{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    holoport.modules = mkOption {
      type = types.path;
    };
  };

  config = {
    holoport.modules = pkgs.holoportModules;

    nix.nixPath = lib.mkForce [
      # The nixpkgs used for nixos-rebuild and all other nix commands
      "nixpkgs=https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz"

      # The custom configuration.nix that injects our modules
      "nixos-config=/etc/nixos/holoport-configuration.nix"
    ];

    environment.etc."nixos/holoport-configuration.nix" = {
      text = replaceStrings ["%%HOLOPORT_MODULES_PATH%%"] [pkgs.holoportModules]
        (readFile "${pkgs.holoportModules}/configuration.nix");
    };

    nixpkgs.overlays = [ (import ../overlay.nix) ];
  };
}
