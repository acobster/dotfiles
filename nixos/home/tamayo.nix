{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./modules/bash.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/ulauncher.nix
    ./modules/unfree.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
