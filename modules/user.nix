{ ... }:

{
  users.extraUsers.holoport = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  services.mingetty.autologinUser = "holoport";
}
