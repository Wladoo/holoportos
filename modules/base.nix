{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ htop ];

  nix.nixPath = lib.mkForce [
    "nixpkgs=https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz"
    "holoport=/etc/nixos/holoport"
    "nixos-config=/etc/nixos/holoport/configuration.nix"
  ];
  environment.etc."nixos/holoport" = {
    source = pkgs.holoportModules;
  };

  nixpkgs.overlays = [ (import ../overlay.nix) ];
}
