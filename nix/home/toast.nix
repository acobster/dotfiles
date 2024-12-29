{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord
  ];

  imports = [
    ./modules/bash.nix
    ./modules/clojure.nix
    ./modules/direnv.nix
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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "zoom"
  ];

  home.stateVersion = "22.11";
}
