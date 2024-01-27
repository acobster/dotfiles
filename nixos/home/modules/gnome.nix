{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-panel
  ];

  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
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
        start-with-sidebar = false;
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Graphite";
      package = pkgs.graphite-gtk-theme;
    };

    iconTheme = {
      name = "Tela Circle";
      package = pkgs.tela-circle-icon-theme;
    };

    cursorTheme = {
      name = "Graphite cursors";
      package = pkgs.graphite-cursors;
    };

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
