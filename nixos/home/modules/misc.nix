{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    cowsay
    ffmpeg
    firefox
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
    ungoogled-chromium
    vlc
    wget
    xclip
  ];
}
