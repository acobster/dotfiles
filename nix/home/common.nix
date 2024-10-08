{ config, pkgs, ... }:

{
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
    ./modules/ulauncher.nix
    ./modules/unfree.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
