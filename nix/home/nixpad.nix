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
    lua
    ripgrep
    silver-searcher
    tree
    vlc
    wget
    xclip
  ];

  imports = [
    ./modules/bash.nix
    ./modules/clojure.nix
    ./modules/direnv.nix
    ./modules/ledger.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
    ./modules/ulauncher.nix
  ];

  home.stateVersion = "23.11";
}
