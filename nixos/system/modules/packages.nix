{ lib, pkgs, nixpkgs, system, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "${system}";

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

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-console
  ];
}
