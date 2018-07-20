{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    #scm
    pkgs.git
  ];

}