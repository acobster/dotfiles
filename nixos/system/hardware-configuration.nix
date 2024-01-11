{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  virtualisation.virtualbox.guest.enable = true;
}
