{ config, ... }:

let
  modulesURLFromEnv = builtins.getEnv "HOLOPORT_MODULES_URL";
  holoportModules = if modulesURLFromEnv != ""
    then (fetchTarball modulesURLFromEnv)
    # This will be replaced with the path to the module in the nix store
    else "%%HOLOPORT_MODULES_PATH%%";

in

{
  holoport.modules = holoportModules;

  imports = [
    # The local system's configuration
    "/etc/nixos/configuration.nix"
  ] ++ (import "${holoportModules}/modules/module-list.nix");
}
