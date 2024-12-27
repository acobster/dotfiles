{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  imports = [
    ./modules/bash.nix
    ./modules/clojure.nix
    ./modules/direnv.nix
    ./modules/fun.nix
    ./modules/ledger.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
    ./modules/ubuntu.nix
    ./modules/ulauncher.nix
  ];

  home.packages = with pkgs; [
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "zoom"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
