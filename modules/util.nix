{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    cloudflared
  ];

  programs.bash.enableCompletion = true;
  programs.command-not-found.enable = false;
}
