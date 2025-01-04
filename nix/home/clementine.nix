{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    cowsay
    curl
    discord
    neofetch
    ffmpeg
    freetube
    fzf
    ghostwriter
    gimp-with-plugins
    jq
    lolcat
    lua
    nix-info
    pdfsam-basic
    ripgrep
    rpi-imager
    signal-desktop
    silver-searcher
    standardnotes
    transmission_4-gtk
    tree
    vlc
    wget
    xclip
    yt-dlp
    zoom-us
    zulip
    zulip-term
  ];

  imports = [
    ./modules/bash.nix
    ./modules/browsers.nix
    ./modules/clojure
    ./modules/colors
    ./modules/direnv.nix
    ./modules/keybase.nix
    ./modules/ledger.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/plasma.nix
    ./modules/tmux.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "zoom"
  ];

  home.stateVersion = "23.11";
}
