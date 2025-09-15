## TODO

* secrets
* Syncthing GUI password
* app launcher
* desktop widgets
* weather location
* fix `clipboard=unnamedplus`
* audit vim config
    * color
    * syntastic => ALE
* port vim config to Lua
    * common.vim
    * color.vim
    * syntastic.vim (or just configure ALE in Lua)
    * racket.vim
    * mappings.vim
* Setup environmnets:
    * Generic server
    * Plex
    * Concierge
* Lando?

## SETUP 2025 - Clementine

### Partition Layout
```
/dev/sda1 - Boot partition (512MB-1GB, FAT32, labeled "EFI_BOOT")
/dev/sda2 - Encrypted root partition (rest of disk, LUKS, labeled "SYSTEM")
```

### LUKS + Btrfs Structure
```
/dev/sda2 (LUKS encrypted, labeled "SYSTEM")
└── /dev/mapper/crypt (decrypted btrfs filesystem)
    ├── @root (subvolume mounted at /)
    ├── @home (subvolume mounted at /home)
    └── @snapshots (subvolume mounted at /.snapshots)
```

### Installation Steps

#### 1. Partition Setup
```bash
# Create partitions (adjust size as needed)
# /dev/sda1 - 1GB for boot
# /dev/sda2 - remaining space for encrypted root

# Format boot partition
mkfs.fat -F32 /dev/sda1
fatlabel /dev/sda1 EFI_BOOT
```

#### 2. LUKS Encryption
```bash
# Encrypt root partition
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 crypt

# Create and label btrfs filesystem
mkfs.btrfs -L SYSTEM /dev/mapper/crypt
```

#### 3. Btrfs Subvolumes
```bash
# Mount and create subvolumes
mount /dev/mapper/crypt /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots

# Remount with proper subvolume structure
umount /mnt
mount -o subvol=@root /dev/mapper/crypt /mnt
mkdir -p /mnt/{home,.snapshots,boot}
mount -o subvol=@home /dev/mapper/crypt /mnt/home
mount -o subvol=@snapshots /dev/mapper/crypt /mnt/.snapshots
mount /dev/disk/by-label/EFI_BOOT /mnt/boot
```

#### 4. NixOS Installation
```bash
nixos-generate-config --root /mnt
# Edit configs (see below)
nixos-install
```

### NixOS Configuration Files

#### `/etc/nixos/configuration.nix`
```nix
{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "btrfs" ];
  };

  # Your users, networking, packages, etc.
  users.users.yourusername = {
    isNormalUser = true;
    home = "/home/yourusername";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;  # Match your backup if preserving ownership
  };

  system.stateVersion = "24.05";  # Match your NixOS version
}
```

#### `/etc/nixos/hardware-configuration.nix`
```nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Kernel modules for hardware detection during boot
  boot.initrd.availableKernelModules = [
    "nvme"        # NVMe SSDs
    "xhci_pci"    # USB 3.0 controllers
    "thunderbolt" # Thunderbolt support
    "usbhid"      # USB keyboard/mouse
    "usb_storage" # USB drives
  ];

  # Modules loaded after boot (virtualization, etc.)
  boot.kernelModules = [ "kvm-amd" ];  # or "kvm-intel"

  # LUKS encryption setup
  boot.initrd.luks.devices."crypt" = {
    device = "/dev/disk/by-label/SYSTEM";
    preLVM = true;        # Decrypt before LVM
    allowDiscards = true; # Enable TRIM for SSD performance
  };

  # Filesystem configuration using labels
  fileSystems."/" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI_BOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

### Key Benefits of This Setup

- **Full disk encryption** (except boot partition)
- **Persistent device names** using labels instead of `/dev/sdaX`
- **Flexible storage** with btrfs subvolumes sharing space
- **Easy OS reinstalls** while preserving `/home` data
- **Snapshot capability** with dedicated `.snapshots` subvolume
- **SSD optimization** with TRIM support and compression

### Boot Process

1. **UEFI** loads systemd-boot from `/boot`
2. **Kernel** loads with initrd containing hardware modules
3. **LUKS password prompt** appears for decryption
4. **Btrfs subvolumes** mount automatically after decryption
5. **System boots** normally with encrypted root and preserved home data

This setup gives you a secure, flexible, and maintainable NixOS installation!

## MISC

- [Horrible screen flickering on Dell XPS](https://www.dell.com/community/en/conversations/linux-general/xps-13-7390-ubuntu-screen-flickering/647f8528f4ccf8a8de410276)

### KDE Plasma Widget options

```
org.kde.plasma.activitybar
org.kde.plasma.activitypager
org.kde.plasma.addons.katesessions
org.kde.plasma.analogclock
org.kde.plasma_applet_dict
org.kde.plasma.appmenu
org.kde.plasma.battery
org.kde.plasma.binaryclock
org.kde.plasma.brightness
org.kde.plasma.calculator
org.kde.plasma.calendar
org.kde.plasma.cameraindicator
org.kde.plasma.clipboard
org.kde.plasma.colorpicker
org.kde.plasma.comic
org.kde.plasma.devicenotifier
org.kde.plasma.digitalclock
org.kde.plasma.diskquota
org.kde.plasma.fifteenpuzzle
org.kde.plasma.folder
org.kde.plasma.fuzzyclock
org.kde.plasma.grouping
org.kde.plasma.icon
org.kde.plasma.icontasks
org.kde.plasma.keyboardindicator
org.kde.plasma.keyboardlayout
org.kde.plasma.kicker
org.kde.plasma.kickerdash
org.kde.plasma.kickoff
org.kde.plasma.kimpanel
org.kde.plasma.konsoleprofiles
org.kde.plasma.lock_logout
org.kde.plasma.manage-inputmethod
org.kde.plasma.marginsseparator
org.kde.plasma.mediacontroller
org.kde.plasma.mediaframe
org.kde.plasma.minimizeall
org.kde.plasma.networkmanagement
org.kde.plasma.notes
org.kde.plasma.notifications
org.kde.plasma.pager
org.kde.plasma.panelspacer
org.kde.plasma.printmanager
org.kde.plasma.private.grouping
org.kde.plasma.private.systemtray
org.kde.plasma.quicklaunch
org.kde.plasma.showActivityManager
org.kde.plasma.showdesktop
org.kde.plasma.systemmonitor
org.kde.plasma.systemmonitor.cpu
org.kde.plasma.systemmonitor.cpucore
org.kde.plasma.systemmonitor.diskactivity
org.kde.plasma.systemmonitor.diskusage
org.kde.plasma.systemmonitor.memory
org.kde.plasma.systemmonitor.net
org.kde.plasma.systemtray
org.kde.plasma.taskmanager
org.kde.plasma.timer
org.kde.plasma.trash
org.kde.plasma.userswitcher
org.kde.plasma.volume
org.kde.plasma.weather
org.kde.plasma.webbrowser
org.kde.plasma.windowlist
```

Compiled with this command (and therefore probably not complete):

```
find /nix/store -name plasmoids | while read f; do ls $f; done | grep org.kde.plasma | sort | uniq
```

## Syncthing on a Synology NAS

For me, setting up Syncthing on a Synology NAS was mostly a process of discover. It's not that complicated once you get the details right, but I wished there was a .

The basic process that worked for me was:

1. Install [Container Manager](https://www.synology.com/en-us/dsm/packages/ContainerManager)
2. Install the official [`syncthing/syncthing` Docker image](https://github.com/syncthing/syncthing/blob/main/README-Docker.md)
3. Configure and run the Docker container to sync individual folders within `$HOME`, the root sync folder

### Specs

As always, your mileage may vary. I imagine these steps are fairly universal, but my versions at time of writing are:

- Linux kernel 4.4.302+ x86_64
- DSM 7.2
- Syncthing 1.28 (`syncthing/syncthing:1.28` Docker image)

One thing to note is that I did have SSH set up already. I _think_ that was a bit of manual setup, but it was unremarkable enough to not write down, so it's out of scope here.

### Installing Syncthing

I tried the Syncthing [SynoCommunity app](https://synocommunity.com/package/syncthing), but due to DSM being a "[spectacularly unrewarding platform to work with](https://forum.syncthing.net/t/synology-dsm-7-kastelo-synocommunity-either/17006/8)" (one can only imagine) that integration is unmaintained. So Docker it is!

There's nothing very special about this installation method. I had never used Container Manager or set up a Docker container on Synology/DSM and I found it pretty straightforward. Container Manager is a standard Synology app available from the Package Center.

Install it and open it up. Go to **Container > Create**, search for syncthing, and choose the official `syncthing/syncthing` image. It should prompt you for a tag. I prefer to pin my Docker images, so I chose the latest stable minor version at time of writing, which was 1.28.

Once you pick a tag it should start a download and then it's onto configuration!

### Setting up the container

Container Manager exposes a nice GUI that maps pretty intuitively onto Docker's CLI args. Give the container a name (I named mine `syncthing-1.28`) and start configure the ports. Synology knows to forward ports 8384
