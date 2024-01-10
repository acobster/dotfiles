{ pkgs, ... }:

{
  home.file.".bashrc".source = ../../../.bashrc;
  home.file.".bash_profile".source = ../../../.bash_profile;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
