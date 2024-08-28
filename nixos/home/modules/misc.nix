{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
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
