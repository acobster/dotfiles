{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    brave
    ungoogled-chromium
  ];

  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" "es" "fr" "ar" ];

    # See about:policies#documentation
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default = {
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nix" ];
        };
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        clearurls
        decentraleyes
        pinboard
        privacy-badger
        tridactyl
        ublock-origin
      ];
    };
  };
}
