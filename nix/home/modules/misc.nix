{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    curl
    ffmpeg
    freetube
    fzf
    gimp-with-plugins
    jq
    lolcat
    lua
    nix-info
    pdfsam-basic
    ripgrep
    rpi-imager
    silver-searcher
    syncthing
    tree
    vlc
    wget
    xclip
    zulip
    zulip-term
  ];
}
