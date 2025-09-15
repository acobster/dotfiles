{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "nvme"     # NVME SSD drives
        "xhci_pci" # USB 3.0 controllers
        "usbhid"   # USB keyboard/mouse
        "thunderbolt"
        "usb_storage"
      ];
      kernelModules = [ "kvm-amd" ];
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@root" "compress=zstd" "ssd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "ssd" "noatime" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "compress=zstd" "ssd" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/EFI_BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ { device = "/.swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # https://www.man7.org/linux/man-pages/man5/logind.conf.5.html
  services.logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
    IdleAction=lock
    SleepOperation=suspend-then-hibernate
  '';
}
