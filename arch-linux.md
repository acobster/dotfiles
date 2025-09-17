# Arch install

Playing around with installing Arch on a refurbished Lenovo ThinkPad (T470).

- Intel Core i5-6300U 2.4GHz Processor
- 16GB RAM
- 256GB SSD

## Boot mode

According to this section, this computer boots into BIOS mode (or possibly CSM):

```
# cat /sys/firmware/efi
...No such file or directory
```

I therefore tried setting up GRUB [in BIOS mode](https://wiki.archlinux.org/title/GRUB#BIOS_systems) but after doing so I'm not able to boot into Arch. I think it's because I set up an EFI boot partition as well as a BIOS boot partition. According to [this tutorial](https://youtu.be/5DHz23VQJxk) I just want the BIOS one, but that also didn't work.

The boot menu looks weird, displaying the following options:

- Ubuntu
- Ubuntu
- USB HDD: SanDisk Cruzer Fit (this is the live environment USB drive)
- ubuntu
- NVMe0: SAMSUNG MZVLB256HAHQ-000H1
- PCI LAN: IBA CL Slot 00FE v0109

I think there is some misconfiguration with EFI and/or GRUB.

## Partitions

What I've tried so far for the [Partition the disk](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks) step.

- 2M BIOS boot partition, no fs
- Btrfs root partition with three subvolumes

At first there was also an EFI partition which I kept because I thought it needed to be there. The GRUB Arch wiki page is not super clear.

Create subvolumes:

```
# mount -t btrfs LABEL=SYSTEM /mnt
# btrfs subvolume create /mnt/@root
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
```

Now remount subvolumes onto their own mountpoints:

```
# umount -R /mnt
# mount -t btrfs -o subvol=@root LABEL=SYSTEM /mnt
# mount -t btrfs -o subvol=@home LABEL=SYSTEM /mnt/home
# mount -t btrfs -o subvol=@snapshots LABEL=SYSTEM /mnt/.snapshots
```

### Packages

Install [essential packages](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages):

```bash
pacstrap /mnt base base-devel linux linux-firmware intel-ucode networkmanager vim man-db man-pages texinfo grub
```
