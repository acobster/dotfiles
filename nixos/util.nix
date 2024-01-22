{ system, pkgs, nixpkgs, home-manager, ... }:

{
  mkComputer = {
    extraModules,
    user ? "tamayo",
    userConfig
  }: nixpkgs.lib.nixosSystem {
    inherit system pkgs;

    modules = [
      #home-manager.nixosModules.home-manager {
      #  home-manager.useGlobalPkgs = true;
      #  home-manager.useUserPackages = true;
      #  home-manager.users."${user}" = userConfig;
      #}
    ] ++ extraModules;
  };
}
