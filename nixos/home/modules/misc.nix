{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    brave
    clojure
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
    tmux
    transmission
    tree
    ungoogled-chromium
    vlc
    wget
    xclip
    zulip
  ];
}
