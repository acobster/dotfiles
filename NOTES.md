## PARTITIONS

On my main driver I want the following partitions:

- Boot
    - EFI
    - 200M
- Swap
    - Linux Swap
    - 2G
    - LUKS-encrypted
- NixOS
    - EXT4? Btrfs?
    - 100GB+
    - LUKS-encrypted
- Home
    - Btrfs
    - Remaining HD space
    - LUKS-encrypted

Look into [Disko](https://github.com/nix-community/disko?tab=readme-ov-file) to [provision](https://github.com/nix-community/disko?tab=readme-ov-file#sample-configuration-and-cli-command) this for us

## MISC

- [Horrible screen flickering on Dell XPS](https://www.dell.com/community/en/conversations/linux-general/xps-13-7390-ubuntu-screen-flickering/647f8528f4ccf8a8de410276)
