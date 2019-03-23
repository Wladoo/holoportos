{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    emacs
  ];

  programs.bash.enableCompletion = true;
  programs.command-not-found.enable = false;
}
