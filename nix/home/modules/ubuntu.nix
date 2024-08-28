{ pkgs, ... }:

{
  home.file.".profile".source = ../../../config/ubuntu.profile;
}
