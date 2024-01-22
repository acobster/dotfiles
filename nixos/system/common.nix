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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
