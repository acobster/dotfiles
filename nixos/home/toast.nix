{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./common.nix
  ];

  home.stateVersion = "22.11";
}
