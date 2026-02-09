{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    curl
    jq
    silver-searcher
    tree
    vlc
    wget
    xclip
  ];

  imports = [
    ./modules/bash.nix
    ./modules/direnv.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
    ./modules/ubuntu.nix
  ];

  home.stateVersion = "22.11";
}
