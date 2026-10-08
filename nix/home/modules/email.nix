{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mutt
    protonmail-bridge
  ];
}
