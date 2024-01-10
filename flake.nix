{
  description = ".";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {

    homeConfigurations = {
      tamayo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nixos/home/tamayo.nix ];
      };
    };

  };
}
