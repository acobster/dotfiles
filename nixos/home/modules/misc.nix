{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    brave
    clojure
    cowsay
    ffmpeg
    firefox
    gimp
    gnome.gnome-terminal
    ledger
    ledger-web
    lolcat
    ripgrep
    rpi-imager
    signal-desktop
    syncthing
    transmission
    ungoogled-chromium
    vlc
    zulip
  ];
}
