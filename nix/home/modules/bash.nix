{ pkgs, ... }:

{
  home.file.".bashrc".source = ../../../bash/.bashrc;
  home.file.".bash_profile".source = ../../../bash/.bash_profile;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
