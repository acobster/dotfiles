# https://fnordig.de/til/nix/home-manager-allow-unfree.html
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zoom-us
  ];
}
