{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./modules/ubuntu.nix
    ./common.nix
  ];

  home.stateVersion = "22.11";
}
