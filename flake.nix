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
    unfree = import ./nix/system/unfree.nix {
      inherit nixpkgs;
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = unfree.allowUnfree;
    };
    util = import ./nix/util.nix {
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
        source ~/dotfiles/bash/.bash_profile
      '';
    };

    homeConfigurations = {
      clementine = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home/clementine.nix
        ];
      };

      nixpad = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home/nixpad.nix
        ];
      };

      toast = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home/toast.nix
        ];
      };

      damperon = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home/damperon.nix
        ];
      };
    };

    nixosConfigurations = {
      clementine = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs system; };
        modules = [
          ./nix/system/common.nix
          ./nix/system/clementine
          ./nix/system/users/tamayo.nix
        ];
      };

      nixpad = lib.nixosSystem {
        inherit system;
        modules = [
          ./nix/system/nixpad.nix
          ./nix/system/common.nix
        ];
      };

      iso = util.mkComputer {
        inherit system;
        extraModules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./nix/system/nixpad.nix
          ./nix/system/common.nix
        ];
        userConfig = homeConfigurations.nixpad;
      };
    };

  };
}
