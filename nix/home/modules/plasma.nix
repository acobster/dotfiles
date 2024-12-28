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
        location = "right";
        hiding = "autohide";
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
    };
  };
}
