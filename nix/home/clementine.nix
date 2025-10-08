{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    cowsay
    curl
    neofetch
    ffmpeg
    freetube
    fzf
    gimp-with-plugins
    jq
    lolcat
    libreoffice-qt
    lua
    nix-info
    pdfsam-basic
    python3
    ripgrep
    rpi-imager
    ruby
    signal-desktop
    silver-searcher
    transmission_4-gtk
    tree
    vlc
    wget
    xclip
    yt-dlp
    zoom-us
    zulip-term
  ];

  imports = [
    ./modules/bash.nix
    ./modules/browsers.nix
    ./modules/clojure
    ./modules/colors
    ./modules/direnv.nix
    ./modules/ledger.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/plasma.nix
    ./modules/tmux.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "typora"
    "zoom"
  ];

  # Ignore project dependency files in syncs.
  # These can be restored easily, and so aren't worth the noise.
  home.file."projects/.stignore".source = ./syncthing/projects.stignore;

  home.stateVersion = "23.11";
}
