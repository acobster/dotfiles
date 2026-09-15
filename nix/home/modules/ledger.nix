{ pkgs, lib, rustPlatform, fetchFromGithub, ... }:

{
  home.packages = with pkgs; [
    ledger
    ledger-web
    (pkgs.callPackage ./ledger-lsp.nix {})
  ];
}
