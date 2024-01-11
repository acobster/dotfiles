{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    lolcat
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
  ];
}
