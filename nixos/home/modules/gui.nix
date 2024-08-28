{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    gnome.gnome-terminal
    vlc
  ];
}
