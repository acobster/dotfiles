{ config, pkgs, ... }:

{
  imports = [
    ./modules/bash.nix
    ./modules/clojure.nix
    ./modules/direnv.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/ulauncher.nix
    ./modules/unfree.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
