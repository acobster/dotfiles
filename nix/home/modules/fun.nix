{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freetube
    rpi-imager
    signal-desktop
    vlc
    zulip
  ];
}
