{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    ffmpeg
    fzf
    gimp
    gnome.gnome-terminal
    jq
    ledger
    ledger-web
    lolcat
    lua
    ripgrep
    rpi-imager
    signal-desktop
    silver-searcher
    syncthing
    tree
    vlc
    wget
    xclip
  ];
}
