{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    firefox
    ungoogled-chromium
  ];
}
