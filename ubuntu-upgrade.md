# Ubuntu 24.04 Upgrade Guide with LUKS + LVM Encryption

## System Specifications
- Laptop: 512GB NVMe disk (nvme0n1)
- Firmware: UEFI
- Encryption: LUKS + LVM
- Target: Separate /home partition for easier future upgrades

## Partition Layout

```
/dev/nvme0n1p1    512 MB     EFI System Partition (FAT32, mounted at /boot/efi)
/dev/nvme0n1p2    ~511 GB    LUKS encrypted container
  └─ LVM inside encryption:
     ├─ root:  100 GB   / (ext4, contains /boot)
     └─ home:  ~411 GB  /home (ext4)
```

**Notes:** 
- No separate /boot partition needed - it lives on encrypted root
- No swap partition - we'll use a swapfile instead for flexibility

## Pre-Installation Checklist

- [ ] Verify backup of /home directory is complete and accessible
- [ ] Note current disk layout: `lsblk` and `sudo fdisk -l`
- [ ] (Optional) Save list of installed packages: `dpkg --get-selections > packages.txt`
- [ ] Create Ubuntu 24.04 USB installer
- [ ] Ensure laptop is plugged into power

## Installation Steps

### Step 1: Boot from USB

1. Insert Ubuntu 24.04 USB drive
2. Restart laptop and enter boot menu (usually F12, F2, or ESC)
3. Select USB drive to boot from
4. Choose "Try Ubuntu" (we'll set up encryption manually first)

### Step 2: Set Up Partitions and Encryption

Open a terminal and run these commands:

#### Create Partitions with fdisk

```bash
# Start fdisk
sudo fdisk /dev/nvme0n1
```

In fdisk, type these commands:
```
g          # Create new GPT partition table
n          # New partition
1          # Partition number 1
<Enter>    # Default first sector (2048)
+512M      # Size: 512 MB
t          # Change partition type
1          # EFI System
n          # New partition
2          # Partition number 2
<Enter>    # Default first sector
<Enter>    # Use all remaining space
w          # Write changes and exit
```

#### Format ESP and Set Up Encryption

```bash
# Format the EFI System Partition
sudo mkfs.vfat -F32 /dev/nvme0n1p1

# Set up LUKS encryption on the second partition
sudo cryptsetup luksFormat /dev/nvme0n1p2
# Enter a strong passphrase when prompted (you'll need this at every boot)
# Confirm with uppercase YES when asked

# Open the encrypted container
sudo cryptsetup luksOpen /dev/nvme0n1p2 cryptdata
# Enter your passphrase again

# Create LVM physical volume
sudo pvcreate /dev/mapper/cryptdata

# Create LVM volume group
sudo vgcreate vgubuntu /dev/mapper/cryptdata

# Create root logical volume (100 GB)
sudo lvcreate -L 100G -n root vgubuntu

# Create home logical volume (all remaining space)
sudo lvcreate -l 100%FREE -n home vgubuntu

# Verify your setup
sudo lvdisplay
```

### Step 3: Start the Ubuntu Installer

1. Click "Install Ubuntu" on the desktop
2. Select language and click "Continue"
3. Choose keyboard layout and click "Continue"
4. Select "Normal installation"
5. Check "Download updates while installing Ubuntu" (recommended)
6. Continue to installation type

### Step 4: Choose Manual Installation

1. Select **"Manual installation"**
2. Click "Continue"

### Step 5: Configure Partitions in Installer

You'll see your partitions and LVM volumes. Configure them as follows:

#### EFI System Partition (/dev/nvme0n1p1)

1. Select `/dev/nvme0n1p1` (512 MB)
2. Click "Change" or double-click
3. Configure:
   - Use as: `VFAT` (or `FAT32`)
   - Mount point: `/boot/efi`
   - Format: Yes (if asked)
4. Click "OK"

#### Root Volume (/dev/mapper/vgubuntu-root)

1. Select `/dev/mapper/vgubuntu-root` (~100 GB)
2. Click "Change" or double-click
3. Configure:
   - Use as: `Ext4 journaling file system`
   - Mount point: `/`
   - Format: Yes (check the box)
4. Click "OK"

#### Home Volume (/dev/mapper/vgubuntu-home)

1. Select `/dev/mapper/vgubuntu-home` (~411 GB)
2. Click "Change" or double-click
3. Configure:
   - Use as: `Ext4 journaling file system`
   - Mount point: `/home`
   - Format: Yes (check the box)
4. Click "OK"

### Step 6: Verify and Install

1. Review your partition layout:
   - /boot/efi: 512 MB, FAT32 on /dev/nvme0n1p1
   - /: 100 GB, ext4, encrypted (on /dev/mapper/vgubuntu-root)
   - /home: ~411 GB, ext4, encrypted (on /dev/mapper/vgubuntu-home)

2. Verify "Device for boot loader installation" is set to `/dev/nvme0n1`

3. Click "Install Now"

4. Confirm changes when prompted

### Step 7: Complete Installation

1. Select your timezone
2. Create your user account:
   - Your name
   - Computer name
   - Username
   - Password (this is separate from disk encryption password)
3. Wait for installation to complete
4. Click "Restart Now" when prompted
5. Remove USB drive when instructed

## Post-Installation

### First Boot

1. You'll be prompted for your **LUKS encryption passphrase** (the one you set with cryptsetup)
2. After decryption, you'll see the normal login screen
3. Log in with your **user password**

### Restore Your Home Directory

```bash
# Mount your backup drive (it should auto-mount when plugged in)
# It will typically appear at /media/youruser/drivename

# Navigate to where your backup is mounted
cd /media/youruser/your-backup-drive

# Restore your home directory
# Replace 'youruser' with your actual username
sudo rsync -av --progress ./home/youruser/ /home/youruser/

# Fix ownership and permissions
sudo chown -R youruser:youruser /home/youruser
chmod 700 /home/youruser

# Verify your files are there
ls -la /home/youruser
```

### Update System

```bash
sudo apt update
sudo apt upgrade
```

### Set Up Swap (Optional but Recommended)

Ubuntu 24.04 usually creates a small swapfile automatically, but you may want to adjust it:

```bash
# Check current swap
swapon --show
free -h

# If you want to create/resize swapfile (example: 16GB)
# First, turn off existing swap if present
sudo swapoff /swapfile

# Create new swapfile
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make it permanent (check if already in fstab first)
grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verify
swapon --show
```

**Swapfile size recommendations:**
- 8GB RAM or less: 1-2x RAM size
- 16GB RAM: 8-16GB swap
- 32GB+ RAM: 4-8GB swap (unless you need hibernation)
- For hibernation: swap should be ≥ RAM size

### Restore Additional Settings (Optional)

Your personal files and most application settings are now restored since they were in /home. You may want to:

1. Reinstall applications that weren't system-default
2. Restore any system-wide configuration you modified (from `/etc/`)

## Future Upgrades

With your separate /home partition, future Ubuntu upgrades are simple:

1. Boot Ubuntu installer USB
2. Choose "Manual installation"
3. Format and mount existing root volume (`/dev/mapper/vgubuntu-root`) as `/`
4. Mount existing home volume (`/dev/mapper/vgubuntu-home`) as `/home` - **DO NOT FORMAT**
5. Install
6. Your files and settings are preserved!

## Troubleshooting

### Can't unlock encrypted disk at boot
- Double-check your passphrase (it's case-sensitive)
- Try using a USB keyboard if using laptop keyboard
- Boot from live USB and decrypt manually to verify passphrase

### Forgot encryption passphrase
- If you have a backup, you'll need to reinstall
- Without the passphrase, the data is unrecoverable (that's the point of encryption!)

### Need to resize partitions later
```bash
# Check current sizes
sudo lvdisplay

# Example: Take 10GB from home, give to root
sudo lvreduce -L -10G /dev/mapper/vgubuntu-home
sudo resize2fs /dev/mapper/vgubuntu-home

sudo lvextend -L +10G /dev/mapper/vgubuntu-root
sudo resize2fs /dev/mapper/vgubuntu-root
```

### System won't boot after installation
- Verify Secure Boot settings in BIOS/UEFI
- Check that boot loader is installed on `/dev/nvme0n1`
- Boot from live USB and use `boot-repair` utility

## Notes

- The encryption passphrase unlocks all volumes (root, home) at once
- EFI System Partition must be FAT32 for UEFI firmware compatibility
- /boot directory lives on encrypted root partition (this is Ubuntu's standard for encrypted installs)
- 100GB for root is generous - typical Ubuntu uses 15-30GB
- Using a swapfile instead of swap partition gives you flexibility to resize later
- All your personal data, application settings, and system files are encrypted
