{ pkgs, lib, ... }:

{
  nix.nixPath = lib.mkForce [
    # The nixpkgs used for nixos-rebuild and all other nix commands
    "nixpkgs=https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz"

    # The custom configuration.nix that injects our modules
    "nixos-config=/etc/nixos/holoport/configuration.nix"
    "holoport=/etc/nixos/holoport"
  ];
  environment.etc."nixos/holoport" = {
    source = pkgs.holoportModules;
  };

  nixpkgs.overlays = [ (import ../overlay.nix) ];
}
