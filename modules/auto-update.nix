{ lib, ... }:

{
  system.autoUpgrade = {
    enable = true;
    # FIXME: use tested channels from our hydra here
    channel = "https://nixos.org/channels/nixos-18.03";
    flags = [ "-I" "holoport=https://github.com/samrose/holoport/archive/master.tar.gz" ];
  };

  nix.gc = {
    automatic = true;
    dates = "*:0/30";
    options = "--max-freed $((64 * 1024**3))";
  };
}
