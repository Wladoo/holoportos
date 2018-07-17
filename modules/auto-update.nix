{ lib, ... }:

{
  system.autoUpgrade = {
    enable = true;
    # The nixpkgs used for automatic upgrades
    # FIXME: use tested channels from our hydra here
    channel = "https://nixos.org/channels/nixos-18.03";
    # On automatic upgrades we fetch new versions of our modules
    # FIXME: use tested channels from our hydra here
    flags = [ "-I" "holoport=https://github.com/samrose/holoport/archive/master.tar.gz" ];
  };

  # Remove old system revisions and store paths that were referenced by them
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}
