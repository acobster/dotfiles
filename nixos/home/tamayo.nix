{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  home.file.".bashrc".source = ../../.bash_profile;
  home.file.".bash_profile".source = ../../.bash_profile;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./modules/misc.nix
    ./modules/neovim.nix
    ./modules/git.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
