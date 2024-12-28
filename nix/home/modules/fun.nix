{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freetube
    gimp-with-plugins
    vlc
    rpi-imager
    zulip
    zulip-term
  ];
}
