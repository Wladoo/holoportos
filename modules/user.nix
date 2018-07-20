{ ... }:

{
  users.extraUsers.holoport = {
    isNormalUser = true;
  };
  services.mingetty.autologinUser = "holoport";
}
