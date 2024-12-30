{ lib, ... }:

{
  networking = {
    extraHosts = ''
      192.168.1.1   tripoli.wifi
      192.168.1.47  nastyboi
      127.0.1.1     toast
    '';
  };
}
