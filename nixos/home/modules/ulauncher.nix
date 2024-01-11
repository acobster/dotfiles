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

  # https://discourse.nixos.org/t/ulauncher-and-the-debugging-journey/13141/4
  systemd.user.services.ulauncher = {
    enable = true;
    description = "Start Ulauncher";
    script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "display-manager.service" ];
    serviceConfig = {
      Restart = "on-failure";
    };
  };
}
