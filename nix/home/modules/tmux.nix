{ pkgs, ... }:

{
  home.file.".tmux.conf".source = ../../../config/tmux.conf;

  programs.tmux = {
    enable = true;
  };
}
