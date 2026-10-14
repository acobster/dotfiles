{ pkgs, ... }:

{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
    supportedFilesystems = [ "btrfs" ];
  };

  # The ESP's partition type is "Linux filesystem", so fwupd can't
  # auto-detect it; point it at the mount for BIOS capsule updates.
  services.fwupd.daemonSettings.EspLocation = "/boot";
}
