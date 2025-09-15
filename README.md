# My dotfiles.

## SETUP

### With NixOS

Per-machine configs for running NixOS and all the nice dependencies.

Clementine's partition setup looks like:

```
$ lsblk -f
NAME        FSTYPE      FSVER LABEL    UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme1n1
├─nvme1n1p1 vfat        FAT32 EFI_BOOT B96C-E341                             955.2M     7% /boot
└─nvme1n1p2 crypto_LUKS 2              299f7c77-2ecd-4697-95fb-b930725208a5
  └─crypt   btrfs             SYSTEM   a9e06dee-1062-485d-8f85-284189eb2f2a                /var/lib/docker/btrfs
                                                                                           /home
                                                                                           /.snapshots
                                                                                           /nix/store
                                                                                           /
nvme0n1
└─nvme0n1p1
```

See `NOTES.md` for how to get to this state.

#### Installation

To install from scratch, first set up your partitions as above. You can ignore `/var/lib/docker/btrfs` and `/nix/store`; these will be generated for you.

Open the `crypt`:

```bash
cryptsetup open /dev/nvme1n1p2 crypt
```

**NOTE: make sure you use the right device path! These can sometimes change.**

Mount the subvolumes:

```bash
mkdir -p /mnt/{home,.snapshots,boot}
mount -o subvol=@root /dev/mapper/crypt /mnt
mount -o subvol=@root /dev/mapper/crypt /mnt
mount -o subvol=@root /dev/mapper/crypt /mnt
mount /dev/disk/by-label/EFI_BOOT /mnt/boot
```

Clone this repo into the home directory:

```bash
nix-shell -p git curl
mkdir /mnt/home/tamayo
git clone https://github.com/acobster/dotfiles.git /mnt/home/tamayo/dotfiles
```

DO THE THING!

```bash
nixos-install --flake /mnt/home/tamayo/dotfiles#clementine
```

Now reboot into your new system. It should prompt you to unlock `crypt` before loading the OS.

Once you reboot, you'll probably want to do some housekeeping things:

```bash
# reset password
passwd

# set the correct permissions on ~/dotfiles (which were cloned by root)
chown tamayo:users -R ~/dotfiles

# set up /home/tamayo
build home

# (reboot here)

# set up terminal theme
theme dark
```

You may also need to reset the default KDE Wallet password.

#### Reinstall preserving home directory

Start by unlocking `crypt`, like for a fresh install:

```bash
cryptsetup open /dev/nvme1n1p2 crypt
```

**NOTE: as always, be careful to get the right device path!**

Backup the `@home` subvolume by mounting it and manually copying it somewhere. Exclude `~/Sync` which is huge and has backups already. Once you're done, unmount and proceed with reinstall.

Mount and replace the root filesystem:

```bash
mount /dev/mapper/crypt /mnt
btrfs subvolume delete /mnt/@root
btrfs subvolume create /mnt/@root
brtfs subvolume list /mnt
```

Remount subvolumes for installation:

```bash
umount /mnt
mount -o subvol=@root /dev/mapper/crypt /mnt
mkdir -p /home/{home,.snapshots,boot}
mount -o subvol=@home /dev/mapper/crypt /mnt/home
mount -o subvol=@snapshots /dev/mapper/crypt /mnt/.snapshots
mount /dev/disk/by-label/EFI_BOOT /mnt/boot
```

Reinstall the OS from the preserve home directory:

```bash
nixos-install --flake /mnt/home/tamayo/dotfiles#clementine
```

#### Setting up syncthing

Standard shared folders should already be declared in your Nix config. To start syncing files from `nastyboi`, it's best to go to `nastyboi:8384` and manually add your local device from there. Then share the folders accordingly, and accept them on the other end. Syncthing should be smart enough to figure out which files need syncing (on a fresh install, all of them).

### Without NixOS

If you want to run Ubuntu or whatever instead, you can use just the home-manager setup.

#### Automatic install

First, [install Nix](https://nixos.org/download).

```sh
nix-shell -p curl --run 'sh <(curl https://raw.githubusercontent.com/acobster/dotfiles/main/bin/init)'
```

You can pass the following options (append to the `sh` command):

- `--skip-ssh` if you already created an SSH key
- `--skip-github` if you already authorized GitHub
- `--skip-profile` to skip sourcing `~/.profile` from `/etc/profile.d/nix.sh` (required for desktop apps)

#### Manual Setup

[Install Nix](https://nixos.org/download).

Start a new shell with the stuff we'll need:

```sh
nix-shell -p curl git home-manager
```

Clone the repo:

```sh
git clone git@github.com:acobster/dotfiles.git # over SSH - requires a key
git clone https://github.com/acobster/dotfiles.git # over HTTPS
```

Note that cloning over HTTPS may require you to change your origin later if you want to push changes.

Finally, we can run the thing:

```sh
bin/build home -b backup --extra-experimental-features 'nix-command flakes'
```

**NOTE: for desktop apps on Ubuntu, you need to explicitly source `~/.profile` from a script inside `/etc/profile.d/`:**

```sh
# /etc/profile.d/nix.sh

if [ -f /home/tamayo/.profile ] ; then
  . /home/tamayo/.profile
fi
```

#### UNINSTALL

```sh
./uninstall.sh
```

## INCLUDED SOFTWARE

### ✅ Daily Essentials

* dotfiles
* neovim
* git
* fzf
* tmux
* silversearcher-ag
* tree
* xclip
* net-tools
* ulauncher

### λ Languages

* Java (OpenJDK 21)
* Clojure
* Babashka
* Joker
* Lua

### 🤷 Misc.

* VLC
* Ungoogled Chromium
* Brave
* GIMP

## TOOLING

To build the home-manager environment:

```sh
build home
```

To build the system config (only works on NixOS):

```sh
build system
```

To build a live ISO:

```sh
build iso
```

## HELPFUL LINKS

* [Generating an ISO with my entire system configuration inside it](https://www.reddit.com/r/NixOS/comments/18lixd3/generating_an_iso_with_my_entire_system/) - from Yours Truly 😘
* [Creating a NixOS live "CD"](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
* [Declarative GNOME configuration with NixOS](https://determinate.systems/posts/declarative-gnome-configuration-with-nixos)
* [nixpkgs legacyPackages vs import](https://discourse.nixos.org/t/using-nixpkgs-legacypackages-system-vs-import/17462)
* Inspo:
    * [dmadisetti/.dots](https://github.com/dmadisetti/.dots)
    * [nyabinary/dotfiles](https://github.com/nyabinary/dotfiles)
* Backups:
    * [NixOS/Borg backup docs](https://nixos.wiki/wiki/Borg_backup)
    * [How to set up Borg Backup on NixOS](https://xeiaso.net/blog/borg-backup-2021-01-09/)

## NOTES

These apps require a system-level install, and don't work when installed at user-level:

- steam
- signal-desktop
- zoom-us
