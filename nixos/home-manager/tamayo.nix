{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  home.packages = [
    pkgs.cowsay
    pkgs.lolcat
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "22.11";

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Coby Tamayo";
      userEmail = "coby@tamayo.email";
      aliases = {
        st = "status";
      };
    };
  };
}
