{ pkgs, ... }:

{
  networking.hostName = "clementine";

  imports = [
    ../users/tamayo.nix

    # Common config
    ../modules/boot.nix
    ../modules/fonts.nix
    ../modules/docker.nix
    ../modules/kde.nix
    ../modules/network.nix
    ../modules/packages.nix

    # Machine-specific config
    ./syncthing.nix
    ./audio.nix
    ./hardware.nix
    ./hosts.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
