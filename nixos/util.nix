{ system, pkgs, nixpkgs, ... }:

{
  mkComputer = {
    extraModules,
    user ? "tamayo"
  }: nixpkgs.lib.nixosSystem {
    inherit system pkgs;
    modules = [
      ({ pkgs, ... }: {
        environment.systemPackages = with pkgs; [ cowsay lolcat ];
      })
    ] ++ extraModules;
  };
}
