{ pkgs, ... }:

{
  home.file.".config/nix/nix.conf".source = ../../../nix/nix.conf;
}
