{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    lolcat
  ];
}
