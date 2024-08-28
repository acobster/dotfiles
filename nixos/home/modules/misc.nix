{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    curl
    ffmpeg
    fzf
    jq
    ledger
    ledger-web
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
