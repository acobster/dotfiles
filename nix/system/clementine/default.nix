{ pkgs, ... }:

{
  networking.hostName = "clementine";

  imports = [
    ../users/tamayo.nix

    # Common config
    ../modules/clamav.nix
    ../modules/fonts.nix
    ../modules/docker.nix
    ../modules/kde.nix
    ../modules/network.nix
    ../modules/packages.nix
    ../modules/ssh.nix

    # Machine-specific config
    ./bootloader.nix
    ./borg.nix
    ./syncthing.nix
    ./audio.nix
    ./hardware.nix
    ./hosts.nix
  ];

  services.desktopManager.plasma6.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # SANE scanners
  hardware.sane.enable = true;

  nixpkgs.config.packagesOverrides = pkgs: {
    xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  };

  systemd.timers."update-lockscreen-background" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "update-lockscreen-background.service";
    };
  };
  systemd.services."update-lockscreen-background" = {
    script = ''
      set -eu
      dir_path='/home/tamayo/Sync/pictures/copyleft'
      (
        cd $dir_path
        dest=$(shuf -n 1 < <(ls -1))
        ln -sf "$dest" lockscreen.pic
      )
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers."extract-music-downloads" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "extract-music-downloads.service";
    };
  };
  systemd.services."extract-music-downloads" = {
    script = ''
      set -eu
      src_path='/home/tamayo/Downloads/music'
      dest_path='/home/tamayo/Sync/music'

      date +'%Y-%m-%d %H:%M:%S' >> $src_path/extract.log
      mkdir -p $src_path
      ${pkgs.babashka}/bin/bb /home/tamayo/dotfiles/bin/extract.clj --delete --source $src_path --dest $dest_path >> $src_path/extract.log
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "tamayo";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
