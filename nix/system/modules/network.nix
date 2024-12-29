{ lib, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  networking = {
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;

    # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

    # Need to disable this for xserver.desktopManager.gnome to work.
    wireless.enable = false;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  services.fail2ban.enable = true;
}
