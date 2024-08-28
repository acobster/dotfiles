{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freetube
    transmission
    zulip
  ];
}
