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
    nix-info
    pdfsam-basic
    ripgrep
    silver-searcher
    syncthing
    tree
    wget
    xclip
  ];
}
