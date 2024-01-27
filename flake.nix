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
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
      ];
    };
    util = import ./nixos/util.nix {
      inherit system pkgs nixpkgs home-manager;
    };
  in
  rec {

    # Bootstrap a minimual dev shell in case we're ever on a system where
    # our NixOS config and/or dotfiles are broken, so we can just do
    # `nix develop` to start working on a fix.
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
      nixpad = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nixos/home/nixpad.nix
        ];
      };

      toast = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nixos/home/toast.nix
        ];
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

      iso = util.mkComputer {
        inherit system;
        extraModules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./nixos/system/nixpad.nix
          ./nixos/system/common.nix
        ];
        userConfig = homeConfigurations.nixpad;
      };
    };

  };
}
