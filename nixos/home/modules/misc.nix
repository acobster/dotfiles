{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    lolcat
    discord
    zoom-us
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "zoom"
  ];
}
