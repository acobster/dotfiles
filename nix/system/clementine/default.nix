{ pkgs, ... }:

{
  networking.hostName = "clementine";

  imports = [
    ../users/tamayo.nix

    # Common config
    ../modules/fonts.nix
    ../modules/docker.nix
    ../modules/kde.nix
    ../modules/network.nix
    ../modules/packages.nix
    ../modules/ssh.nix

    # Machine-specific config
    ./boot.nix
    ./syncthing.nix
    ./audio.nix
    ./hardware.nix
    ./hosts.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # SANE scanners
  hardware.sane.enable = true;

  nixpkgs.config.packagesOverrides = pkgs: {
    xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
