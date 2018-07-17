{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ htop ];
}
