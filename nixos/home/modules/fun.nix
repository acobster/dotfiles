{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freetube
    signal-desktop
    transmission
    zulip
  ];
}
