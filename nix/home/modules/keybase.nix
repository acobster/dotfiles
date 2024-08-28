{ home, pkgs, ... }:

{
  home.packages = with pkgs; [
    kbfs
    keybase
    keybase-gui
  ];

  services = {
    keybase.enable = true;
    kbfs = {
      enable = true;
      mountPoint = "keybase";
    };
  };
}
