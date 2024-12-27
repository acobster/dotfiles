{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freetube
    vlc
    rpi-imager
    zulip
    zulip-term
  ];
}
