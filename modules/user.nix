{ ... }:

{
  users.extraUsers.holoport = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  services.mingetty.autologinUser = "holoport";
  security.sudo.wheelNeedsPassword = false;
  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      holoport ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';
  services.openssh.authorizedKeyfiles = ["/home/holoport/.ssh/support_key"];
}
