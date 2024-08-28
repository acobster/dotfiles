{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./modules/ubuntu.nix
    # instead of common, pick and choose just the work stuff:
    ./modules/bash.nix
    ./modules/direnv.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
  ];

  home.stateVersion = "24.05";
}
