{ lib, ... }:

{
  networking = {
    extraHosts = (lib.strings.concatStrings [
      ''
        # BEGIN CUSTOM HOSTS ENTRIES

        192.168.1.1   tripoli.wifi
        192.168.1.47  nastyboi
        127.0.1.1     toast

        # END CUSTOM HOSTS ENTRIES
      ''
      (builtins.readFile ../hosts)
    ]);
  };
}
