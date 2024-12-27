{ pkgs, ... }:

{
  networking.hostName = "nixpad";

  # TODO
  #fileSystems."/" =
  #  {
  #    device = "/dev/disk/by-label/NIXOSROOT";
  #    fsType = "ext4";
  #  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11aba3d2-1a9f-4bf1-9b44-d2c1371267e7";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0d009137-ca91-4608-b436-67feeb0279ef".device = "/dev/disk/by-uuid/0d009137-ca91-4608-b436-67feeb0279ef";

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # TODO
  #fileSystems."/boot/efi" =
  #  { device = "/dev/disk/by-label/BOOT";
  #    fsType = "vfat";
  #  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/3753-49DD";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.pulseaudio.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
