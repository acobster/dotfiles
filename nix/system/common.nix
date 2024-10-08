{ config, lib, pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./modules/boot.nix
    ./modules/display.nix
    ./modules/fonts.nix
    ./modules/network.nix
    ./modules/packages.nix
    ./modules/peripherals.nix
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  virtualisation.virtualbox.guest.enable = true;

}
