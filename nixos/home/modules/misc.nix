{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    curl
    ffmpeg
    fzf
    jq
    lolcat
    lua
    ripgrep
    silver-searcher
    syncthing
    tree
    wget
    xclip
  ];
}
