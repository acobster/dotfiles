# https://fnordig.de/til/nix/home-manager-allow-unfree.html
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "slack"
  ];
}
