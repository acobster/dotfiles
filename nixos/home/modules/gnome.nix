{ config, pkgs, ... }:

{
  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # https://determinate.systems/posts/declarative-gnome-configuration-with-nixos
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
