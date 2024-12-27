# https://fnordig.de/til/nix/home-manager-allow-unfree.html
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
  ];
}
