{ pkgs, inputs, ... }:

let
  lock-false = { Value = false; Status = "locked"; };
  lock-true = { Value = true; Status = "locked"; };
  lock-empty = { Value = ""; Status = "locked"; };
  nixGLIntel = inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel;
in
{
  home.packages = with pkgs; [
    brave
    ungoogled-chromium
  ];

  # https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
  programs.firefox = {
    enable = true;
    # home-manager calls package.override to inject profile/extension config,
    # so we intercept override to apply the nixGL wrapper after that step.
    package =
      let
        wrapWithNixGL = drv: pkgs.symlinkJoin {
          name = "firefox-nixgl";
          paths = [ drv ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            rm $out/bin/firefox
            makeWrapper ${nixGLIntel}/bin/nixGLIntel $out/bin/firefox \
              --add-flags "${drv}/bin/firefox"
          '';
        };
      in
      pkgs.firefox // {
        override = args: wrapWithNixGL (pkgs.firefox.override args);
        overrideAttrs = f: wrapWithNixGL (pkgs.firefox.overrideAttrs f);
      };

    configPath = ".mozilla/firefox";

    languagePacks = [ "en-US" "es" "fr" "ar" ];

    # See about:policies#documentation
    # See also: https://mozilla.github.io/policy-templates/
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences = {
        "browser.engagement.home-button.has-removed" = lock-true;
        "browser.newtabpage.pinned" = lock-empty;
        "browser.newtabpage.activity-stream.discoverystream.spoc.impressions" = lock-empty;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topsites" = lock-false;
        "browser.newtabpage.activity-stream.impressionId" = lock-empty;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "browser.newtabpage.activity-stream.showWeather" = lock-true;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.startup.homepage" = "https://isitbandcampfriday.com/";
        "browser.topsites.contile.enabled" = lock-false;
        "extensions.pocket.enabled" = lock-false;
      };
    };

    profiles.default = {
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };

      search = {
        default = "ddg";
        privateDefault = "ddg";

        engines = {
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
      };

      # TODO
      # notion
      # jira
      # github/amperon
    };
  };
}
