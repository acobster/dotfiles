{ pkgs, ... }:

{
  home.packages = [
    pkgs.cowsay
    pkgs.lolcat
  ];
}
