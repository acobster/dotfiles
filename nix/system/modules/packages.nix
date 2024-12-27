{ lib, pkgs, nixpkgs, system, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "${system}";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker
    firefox
    fzf
    git
    gnome-terminal
    home-manager
    nettools
    silver-searcher
    # Steam needs to run at the system level
    steam
    vim
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-console
  ];
}
