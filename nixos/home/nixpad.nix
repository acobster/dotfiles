{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./common.nix
    ./modules/keybase.nix
  ];

  home.stateVersion = "22.11";
}
