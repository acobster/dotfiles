{ pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";

    grub = {
      theme = pkgs.nixos-grub2-theme;
      #backgroundColor = "#FFCC00";
      backgroundColor = "#F0E3FF";
      splashImage = ../../img/grub.png;
    };
  };

  isoImage.splashImage = ../../img/live.png;
  isoImage.efiSplashImage = ../../img/live.png;

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
}
