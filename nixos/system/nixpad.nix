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
}
