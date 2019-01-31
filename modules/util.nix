{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloudflared
    git
    vim
    htop
  ];

  programs.bash.enableCompletion = true;
  programs.command-not-found.enable = false;
}
