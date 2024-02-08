{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    cowsay
    ffmpeg
    firefox
    freetube
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
    transmission
    tree
    ungoogled-chromium
    vlc
    wget
    xclip
    zulip
  ];
}
