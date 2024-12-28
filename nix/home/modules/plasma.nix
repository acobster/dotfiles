{ pkgs, ... }:


{
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    shortcuts = {
      "ksmserver"."Lock Session" = "Meta+L";
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "kwin"."Increase Opacity" = "Shift+Alt+Up,Increase Opacity of Active Window by 5%";
      "kwin"."Decrease Opacity" = "Shift+Alt+Down,Decrease Opacity of Active Window by 5%";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9,Meta+Tab";
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Window Maximize" = "Meta+Up";
      "kwin"."Window Minimize" = "Meta+H";
      "kwin"."Window Quick Tile Bottom" = ["Meta+Shift+Down" "Meta+PgDown"];
      "kwin"."Window Quick Tile Top" = ["Meta+PgUp" "Meta+Shift+Up"];
    };
  };
}
