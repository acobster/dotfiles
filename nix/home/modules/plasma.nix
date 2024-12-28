{ pkgs, ... }:


{
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    hotkeys.commands."launch-terminal" = {
      name = "Launch GNOME Terminal";
      key = "Ctrl+Alt+T";
      command = "gnome-terminal";
    };

    panels = [
      {
        location = "top";
        hiding = "normalpanel";
        height = 24;
        widgets = [
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              time.format = "12h";
              date.enable = false;
            };
          }
          "org.kde.plasma.weather"
          "org.kde.plasma.panelspacer"
          {
            systemTray = {
              items = {
                shown = [
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.battery"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.notifications"
                ];
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
      {
        location = "left";
        hiding = "dodgewindows";
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
        ];
      }
    ];

    shortcuts = {
      "ksmserver"."Lock Session" = "Meta+L";
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9,Meta+Tab";
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Window Maximize" = "Meta+Up";
      "kwin"."Window Minimize" = "Meta+H";
      "kwin"."Window Quick Tile Bottom" = ["Meta+Shift+Down" "Meta+PgDown"];
      "kwin"."Window Quick Tile Top" = ["Meta+PgUp" "Meta+Shift+Up"];
    };

    configFile = {
      "kwinrc"."MouseBindings"."CommandAllWheel" = "Change Opacity";
      "kwinrc"."NightColor"."Active" = true;
    };
  };
}
