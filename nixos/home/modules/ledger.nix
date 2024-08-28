{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ledger
    ledger-web
  ];
}
