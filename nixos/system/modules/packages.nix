{ config, lib, pkgs, nixpkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fzf
    git
    home-manager
    nettools
    silver-searcher
    steam
  ];

  # https://nixos.wiki/wiki/Steam
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-console
  ];
}
