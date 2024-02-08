{ nixpkgs, ... }:

{
  allowUnfree = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];
}
