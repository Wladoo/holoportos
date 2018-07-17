{ ... }:

{
  imports = [
    "/etc/nixos/configuration.nix"
  ] ++ (import <holoport/modules/module-list.nix>);
}
