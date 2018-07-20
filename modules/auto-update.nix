{ lib, config, ... }:

{
  system.autoUpgrade = {
    enable = true;
    # The nixpkgs used for automatic upgrades
    channel = config.holoport.channels.nixpkgs;
  };

  # On automatic upgrades we fetch new versions of our modules
  systemd.services.nixos-upgrade.environment = {
    HOLOPORT_MODULES_URL = config.holoport.channels.holoport;
  };

  # Remove old system revisions and store paths that were referenced by them
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}
