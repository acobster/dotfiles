{ config, pkgs, ... }:

{
  home.username = "coby";
  home.homeDirectory = "/home/coby";

  imports = [
    ./modules/ubuntu.nix
    # instead of common, pick and choose just the work stuff:
    ./modules/bash.nix
    ./modules/direnv.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/nix.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
