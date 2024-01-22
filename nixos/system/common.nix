{ config, lib, pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./modules/boot.nix
    ./modules/display.nix
    ./modules/network.nix
    ./modules/packages.nix
    ./modules/peripherals.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  virtualisation.virtualbox.guest.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tamayo = {
    isNormalUser = true;
    # go ahead, try it lol
    initialPassword = "pourover";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # TODO move this to home-manager?
    packages = with pkgs; [
      protonvpn-cli
      protonvpn-gui
    ];
  };

}
