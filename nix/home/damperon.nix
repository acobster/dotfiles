{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  home.packages = with pkgs; [
    clickhouse
    mariadb_105
    nodejs_20
    pkg-config
    python3
    python311Packages.pip
    python311Packages.virtualenv
    yarn-berry
  ];

  imports = [
    ./modules/ubuntu.nix
    # instead of common, pick and choose just the work stuff:
    ./modules/bash.nix
    ./modules/browsers.nix
    ./modules/direnv.nix
    ./modules/gui.nix
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/tmux.nix
    ./modules/slack.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
