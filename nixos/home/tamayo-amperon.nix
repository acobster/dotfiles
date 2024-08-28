{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./modules/ubuntu.nix
    # instead of common, pick and choose just the work stuff:
    ./modules/bash.nix
    ./modules/browsers.nix
    ./modules/direnv.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/nodejs.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/python.nix
    ./modules/tmux.nix
    ./modules/slack.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
