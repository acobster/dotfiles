{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-panel
  ];

  # `dconf watch /` is your friend
  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Yaru-red-dark";
        icon-theme = "Yaru-red";
        color-scheme = "prefer-dark";
      };
      "org/gtk/settings/file-chooser" = {
        sort-directories-first = true;
        show-hidden = true;
      };
      "org/gnome/nautilus/list-view" = {
        use-tree-view = true;
      };
      "org/gnome/nautilus/window-state" = {
        start-with-sidebar = true;
      };
    };
  };

  gtk = {
    enable = true;

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "Graphite";
}
