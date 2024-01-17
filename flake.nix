{
  # Greetings!
  description = ".";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
  in
  {

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.home-manager
        pkgs.direnv
      ];

      shellHook = ''
        NIX_DEVELOP=1;
        source ~/.bash_profile
      '';
    };

    homeConfigurations = {
      tamayo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nixos/home/tamayo.nix ];
      };
    };

    nixosConfigurations = {
      nixpad = lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/system/nixpad.nix
          ./nixos/system/common.nix
        ];
      };
    };

  };
}
