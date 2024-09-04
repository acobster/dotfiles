## PARTITIONS

### Partitions strategy v2: BTRFS subvolums + LUKS

1. Boot
    - EFI
    - 200M 
3. Btrfs+LUKS
    - LUKS drive, with Btrfs filesystem mounted into it
    - 100% remaining disk space
    - A subvolume each for:
        - root
        - home
        - snapshots (this lets us browse snapshots as a regular file tree)
    - Swapfile

See also:

- [Ubuntu 20.04 btrfs-luks + timeshift](https://www.youtube.com/watch?v=yRSElRlp7TQ)
- [Disko Btrfs+LUKS example](https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix)

Tangentially related resources found while researching:

- [Introduction to LVM](https://www.youtube.com/watch?v=dMHFArkANP8)
- [Encrypting Linux fs with LUKS](https://www.youtube.com/watch?v=woHtfaFDWBU)
- [Btrfs + LUKS + Secure Boot on Arch](https://wiki.archlinux.org/title/User:ZachHilman/Installation_-_Btrfs_%2B_LUKS2_%2B_Secure_Boot)

#### Manual setup

Boot into the NixOS live environment. Close out of the graphical installer. Start an interactive sudo session with `sudo -i` and run `lsblk` and `fdisk -l` to get a lay of the land. You should see something like:

```
# lsblk
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0            7:0    0   2.4G  1 loop  /nix/.ro-store
sda              8:0    1  14.6G  0 disk  
├─sdb1           8:1    1   2.4G  0 part  /iso
└─sdb2           8:2    1     3M  0 part
sdb             259:0   0 238.5G  0 disk
├─ ...
└─ ...
```

Here, `sdb` is the device for the laptop drive we want to partition and format. This will depend on the type of drive(s) the computer came with. Choose carefully, and remember to replace `sdb` in the below comands with the right partition.

Let's start by creating a partition table with the `fdisk` utility. Run `fdisk /dev/sdb`, making sure to use the correct device name for the drive.

1. `g` to create a new GUID Partition Table (GPT)
2. `n` to create the first partition, which will be our boot partition
3. Hit `Enter` to accept the default **Partition number** of 1, and again to accept the default **First sector**
4. For **Last sector**, type `+200M` and hit `Enter`
5. `t` to set the type of the partition we just created and select `1` for **EFI System**
6. `n` to create our next partition
7. Now hit `Enter` three times for the default **Partition number**, **First sector**, and **Last sector**, which will tell it to allocate the remaining disk space to this partition
8. Leave type as **Linux filesystem**
9. `p` to doube-check the partition table we're about to write
10. `w` to write it

You should see some output like:

```
The partition table has been altered.
Calling ioclt() to re-read partition table.
Syncing disks.
```

Now run `lsblk` again to triple-check we got the layout we want:

```
# lsblk
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0            7:0    0   2.4G  1 loop  /nix/.ro-store
sda              8:0    1  14.6G  0 disk  
├─sdb1           8:1    1   2.4G  0 part  /iso
└─sdb2           8:2    1     3M  0 part
sdb             259:0   0 238.5G  0 disk
├─sdb1          259:1   0   200M  0 part 
└─sdb2          259:2   0 238.5G  0 part  
```

Looks good! `/dev/sdb1` is our 200M EFI boot partition, and `/dev/sdb3` is our filesystem partition which we will encrypt and then format with Btrfs.

First, make sure the boot partition is properly formatted and labeled:

```
# mkfs.fat -F 32 /dev/sdb1
mkfs.fat 4.2 (2021-01-31)
# fatlabel /dev/sdb1 EFI_BOOT
#
```

We'll mount this filesystem in a future step, but we have a few other steps first.

Now create the LUKS container for the encrypted umbrella filesystem, which will contain root, swap, and home. As of 2024 you probably still want to specify LUKS1, as the most detail I could find in my cursory search was that GRUB only has limited support for LUKS2.

```
# cryptsetup luksFormat --type=luks1 /dev/sdb2

WARNING!
========
This will overwrite data on /dev/sdb2 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase for /dev/sdb2:
Verify passphrase:
```

Follow the prompts, typing `YES` to confirm and enter a password (twice).

Map the encrypted partition to a device with:

```
# cryptsetup luksOpen --label=LUKS_CONTAINER /dev/sdb2 encrypted
Enter passphrase for /dev/sdb2:
```

The `encrypted` part is arbitrary.

We now have our encrypted container, so next we need to create the actual Btrfs filesystem inside it:

```
# mkfs.btrfs --label SYSTEM /dev/mapper/encrypted
```

Similarly to the `EFI_BOOT` label we set using `fatlabel`, we'll use the `SYSTEM` label in our NixOS hardware config later. But first, let's create our Btrfs subvolumes:

```
# mount -t btrfs LABEL=SYSTEM /mnt
# btrfs subvolume create /mnt/@root
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
```

We now have our subvolumes, but what we want to do now is actually mount them as separate mounts in the filesystem tree, each with their own set of options. We'll first _unmount_ root and then remount each subvolume with [fs_mntopts](https://www.man7.org/linux/man-pages/man5/fstab.5.html).

Okay, let's begin by recursively (hence `-R`) unmounting:

```
# umount -R /mnt
```

Now let's remount. Here are the options we'll pass:

- `defaults` - defaults for the kernel and filesystem.
- `x-mount.mkdir` - tells `mount` to create a directory for the mount if it doesn't exist.
- `compress=zstd` - optimize for storage. Defaults to no compression if not passed.
- `nodatacow` - disables Copy-On-Write for newly created files. Default is `datacow`, meaning COW is enabled.
- `ssd` - optimize for SSD performance.
- `noatime` - prevents inode updates when files are merely accessed (as opposed to actually written to, I think).
- `subvol=...` - indicates Btrfs subvolume explicitly.

```
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@root LABEL=SYSTEM /mnt
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@home LABEL=SYSTEM /mnt/home
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@snapshots LABEL=SYSTEM /mnt/.snapshots
```

Now that we have the root mount, we're also ready to mount the boot filesystem:

```
# mkdir /mnt/boot
# mount LABEL=EFI_BOOT /mnt/boot
```

And while we're at it, let's create a Btrfs swapfile:

```
# btrfs filesystem mkswapfile --size 2G /mnt/.swapfile
# swapon /mnt/.swapfile
```

Our disk layout should now look something like this:

```
# lsblk
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
...
sdb             259:0   0 238.5G  0 disk
├─sdb1          259:1   0   200M  0 part  /mnt/boot
└─sdb2          259:2   0 238.5G  0 part
  └─encrypted   259:0   0 238.5G  0 crypt /mnt/.snapshots
                                          /mnt/home
                                          /mnt
```

**NOTE:** that once you run `nixos-generate-config` with this setup, you may still need to edit your generated `hardware-configuration.nix` file to specify filesystems `by-label` instead of `by-uuid`, and to specify swapfile. For some reason the config gen script does not catch the fact that we're mapping `by-label`, although [apparently](https://youtu.be/axOxLJ4BWmY?si=6t4y0vR9vXWwnW1B&t=1300) it used to.

### Partitions strategy v1

**This is an old version of the partition strategy, preserved here for historical purposes. The strategy above is simpler and takes better advantage of Btrfs.**

On my main driver I want the following partitions:

1. Boot
    - EFI
    - 200M
2. Swap
    - Linux Swap
    - 2G
    - LUKS-encrypted
3. NixOS
    - EXT4? Btrfs?
    - 100GB+
    - LUKS-encrypted
4. Home
    - Btrfs
    - Remaining HD space
    - LUKS-encrypted

Look into [Disko](https://github.com/nix-community/disko?tab=readme-ov-file) to [provision](https://github.com/nix-community/disko?tab=readme-ov-file#sample-configuration-and-cli-command) this for us

Upon creating the above layout, running `nixos-generate-config` generated a `hardware-configuration.nix` file like this:

```nix
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b0beb6d3-b980-45c7-85fb-67191ff910b8";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5D57-A897";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5e39dd22-a482-4f3f-8453-f1471e333172";
      fsType = "btrfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1314445b-fd04-438a-b7da-ab9c4be1a747"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

## Fun FIFO / Named Pipes hack

The `bin/consume` script in this repo is my favorite Bash script I've ever written.

I originally learned the concept of FIFOs, AKA named pipes, from an episode of Gary Bernhardt's Destroy All Software screencast. In that episode, Gary describes a general Unix test runner that accepts arbitrary commands and prints their output, listening in an infinite loop and running each command as it comes in.

He starts with a humble offering, which you can run directly on the command line:

```
mkfifo test-commands
cat test-commands
```

What the `mkfifo` command does is create a file called `test-commands` of type named pipe, a special Unix file type. The `cat` command will block until it reads something from the pipe.

So when will that happen? When we write to it (from, say, a separate terminal window):

```sh
echo 'hello pipe' > test-commands
```

The `cat` process will now spit out `hello pipe` and exit normally. `echo` implicity writes an EOF to `test-commands`, so `cat` finished reading and terminates like it would on any other file.

This works because `test-commands`, like any ol' Unix pipe, has a "read end" and a "write end". The special thing about names pipes is that they get a concrete filesystem path, just like a normal file. This lets us write to it from anywhere else on the system, like we just did.

https://github.com/acobster/dotfiles/commit/9fdab8961771809bace27ff671dc49df069b6487
https://github.com/acobster/dotfiles/commit/c11edb0d3fd19ae6da8eadf7d0820cdd6a4f1e44

## MISC

- [Horrible screen flickering on Dell XPS](https://www.dell.com/community/en/conversations/linux-general/xps-13-7390-ubuntu-screen-flickering/647f8528f4ccf8a8de410276)