# https://discourse.nixos.org/t/ulauncher-and-the-debugging-journey/13141/4
# https://github.com/AlexNabokikh/nix-config/blob/master/home/modules/ulauncher.nix
{ pkgs, ... }:

{
  # Ulauncher plugins dependecies installation via overlay
  nixpkgs = {
    overlays = [
      (final: prev: {
        ulauncher = prev.ulauncher.overrideAttrs (old: {
          propagatedBuildInputs = with prev.python3Packages;
            old.propagatedBuildInputs
            ++ [
              thefuzz
              tornado
            ];
        });
      })
    ];
  };

  home.packages = with pkgs; [
    ulauncher
  ];

  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Start Ulauncher";
      Documentation = "https://ulauncher.io";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      Restart = "always";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
