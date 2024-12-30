{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord
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
    zulip
  ];

  imports = [
    ./modules/bash.nix
    ./modules/clojure
    ./modules/direnv.nix
    ./modules/ledger.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
    ./modules/ubuntu.nix
    ./modules/ulauncher.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
  ];

  home.stateVersion = "22.11";
}
