{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    ffmpeg
    gimp
    ledger
    ledger-web
    lolcat
    rpi-imager
    signal-desktop
    syncthing
    ungoogled-chromium
    zulip
  ];
}
