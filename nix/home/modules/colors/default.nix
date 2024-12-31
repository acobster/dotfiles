{ pkgs, ... }:

{
  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".dircolors/solarized.ansi-light".source = ./solarized.ansi-light;
  home.file.".dircolors/solarized.ansi-dark".source = ./solarized.ansi-dark;
}
