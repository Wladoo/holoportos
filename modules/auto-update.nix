{ lib, ... }:

{
  system.autoUpgrade = {
    enable = true;
    # FIXME: use tested channels from our hydra here
    channel = "https://nixos.org/channels/nixos-18.03";
    flags = [ "-I" "holoport=https://github.com/samrose/holoport/archive/master.tar.gz" ];
  };

  nix.nixPath = lib.mkForce [
    "nixpkgs=https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz"
    "holoport=https://github.com/samrose/holoport/archive/master.tar.gz"
    "nixos-config=https://raw.githubusercontent.com/samrose/nixpkgs/master/configuration.nix"
  ];

  nix.gc = {
    automatic = true;
    dates = "*:0/30";
    options = "--max-freed $((64 * 1024**3))";
  };
}
