{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Hint Electron to use Wayland.
    NIXOS_OZONE_WL = "1";
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    dunst # notification daemon

    # Might not need these overrides, idk :shrug:
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

    # Required by waybar and dunst.
    libnotify

    # App Launcher
    rofi-wayland
    # To try:
    # bemenu
    # fuzzel
    # tofi

    # Wallpaper
    swww
    # To try:
    # hyprpaper
    # swaybg
    # wpaperd
    # mpvpaper
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
